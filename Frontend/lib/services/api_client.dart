import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/booking.dart';
import '../models/workspace_space.dart';

const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:5000/api',
);

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  String? _token;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  Future<void> ensureDemoSession() async {
    if (_token != null) return;

    final response = await http.post(
      Uri.parse('$apiBaseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': 'admin@example.com',
        'password': 'Password123!',
      }),
    );
    final body = _decode(response);
    _token = body['token'] as String?;
    if (_token == null) {
      throw const ApiException('Login succeeded but no token was returned.');
    }
  }

  Future<DashboardData> fetchDashboard() async {
    await ensureDemoSession();
    final results = await Future.wait([
      _get('/branches'),
      _get('/bookings'),
      _get('/analytics/utilization'),
    ]);

    final branches = (results[0]['branches'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    final bookings = (results[1]['bookings'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    final report = (results[2]['report'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();

    return DashboardData(
      branchCount: branches.length,
      bookingCount: bookings.length,
      totalCapacity: report.fold<int>(
        0,
        (total, row) => total + ((row['totalCapacity'] as num?)?.toInt() ?? 0),
      ),
      activeSpaces: report.fold<int>(
        0,
        (total, row) => total + ((row['activeSpaces'] as num?)?.toInt() ?? 0),
      ),
      averageUtilization: report.isEmpty
          ? 0
          : report.fold<double>(
                0,
                (total, row) =>
                    total + ((row['utilizationRate'] as num?)?.toDouble() ?? 0),
              ) /
              report.length,
      locations: report.map(LocationSummary.fromApi).toList(),
      bookings: bookings.map(Booking.fromApi).toList(),
    );
  }

  Future<List<WorkspaceLocation>> fetchLocationsWithSpaces() async {
    await ensureDemoSession();
    final branchBody = await _get('/branches');
    final branches = (branchBody['branches'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();

    final locations = <WorkspaceLocation>[];
    for (final branch in branches) {
      final branchId = branch['_id'] as String;
      final slot = _demoSlot();
      final spacesBody = await _get(
        '/branches/$branchId/spaces?startTime=${Uri.encodeComponent(slot.start.toIso8601String())}&endTime=${Uri.encodeComponent(slot.end.toIso8601String())}',
      );
      final spaces = (spacesBody['spaces'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>()
          .map(WorkspaceSpace.fromApi)
          .toList();
      final roomCount = spaces
          .where((space) => space.kind == WorkspaceKind.meetingRoom)
          .length;

      locations.add(
        WorkspaceLocation(
          id: branchId,
          label: branch['city'] as String? ?? branch['name'] as String? ?? 'Hub',
          name: branch['name'] as String? ?? 'Unnamed branch',
          spaces: spaces,
          roomCount: roomCount,
          deskCount: spaces.length - roomCount,
        ),
      );
    }

    return locations;
  }

  Future<List<Booking>> fetchBookings() async {
    await ensureDemoSession();
    final body = await _get('/bookings');
    return (body['bookings'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .map(Booking.fromApi)
        .toList();
  }

  Future<List<LocationSummary>> fetchUtilization() async {
    await ensureDemoSession();
    final body = await _get('/analytics/utilization');
    return (body['report'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .map(LocationSummary.fromApi)
        .toList();
  }

  Future<void> bookDemoSlot(String spaceId) async {
    await ensureDemoSession();
    final slot = _demoSlot(daysFromNow: 1);
    await _post('/bookings', {
      'space': spaceId,
      'startTime': slot.start.toIso8601String(),
      'endTime': slot.end.toIso8601String(),
      'notes': 'Demo booking created from the Flutter frontend',
    });
  }

  Future<Map<String, dynamic>> _get(String path) async {
    final response = await http.get(Uri.parse('$apiBaseUrl$path'), headers: _headers);
    return _decode(response);
  }

  Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _decode(response);
  }

  Map<String, dynamic> _decode(http.Response response) {
    final body = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(body['message'] as String? ?? 'API request failed.');
    }
    return body;
  }

  ({DateTime start, DateTime end}) _demoSlot({int daysFromNow = 0}) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day + daysFromNow, 10);
    return (start: start, end: start.add(const Duration(hours: 2)));
  }
}

class DashboardData {
  const DashboardData({
    required this.branchCount,
    required this.bookingCount,
    required this.totalCapacity,
    required this.activeSpaces,
    required this.averageUtilization,
    required this.locations,
    required this.bookings,
  });

  final int branchCount;
  final int bookingCount;
  final int totalCapacity;
  final int activeSpaces;
  final double averageUtilization;
  final List<LocationSummary> locations;
  final List<Booking> bookings;

  int get availableSpaces =>
      (activeSpaces - bookingCount).clamp(0, activeSpaces).toInt();
}

class LocationSummary {
  const LocationSummary({
    required this.name,
    required this.occupied,
    required this.capacity,
    required this.utilizationRate,
    required this.walkInCount,
  });

  final String name;
  final int occupied;
  final int capacity;
  final double utilizationRate;
  final int walkInCount;

  factory LocationSummary.fromApi(Map<String, dynamic> json) {
    final branch = json['branch'] as Map<String, dynamic>? ?? {};
    return LocationSummary(
      name: branch['name'] as String? ?? 'Location',
      occupied: (json['bookingCount'] as num?)?.toInt() ?? 0,
      capacity: (json['activeSpaces'] as num?)?.toInt() ?? 0,
      utilizationRate: (json['utilizationRate'] as num?)?.toDouble() ?? 0,
      walkInCount: (json['walkInCount'] as num?)?.toInt() ?? 0,
    );
  }
}
