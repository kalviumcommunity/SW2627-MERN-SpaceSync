enum BookingStatus { active, confirmed, conflict, walkIn, pending, cancelled }

extension BookingStatusLabel on BookingStatus {
  String get label => switch (this) {
    BookingStatus.active => 'Active',
    BookingStatus.confirmed => 'Confirmed',
    BookingStatus.conflict => 'Conflict',
    BookingStatus.walkIn => 'Walk-in',
    BookingStatus.pending => 'Pending',
    BookingStatus.cancelled => 'Cancelled',
  };
}

class Booking {
  const Booking({
    this.id,
    required this.name,
    required this.initials,
    required this.status,
    required this.workspace,
    required this.location,
    required this.date,
    required this.time,
  });

  final String? id;
  final String name;
  final String initials;
  final BookingStatus status;
  final String workspace;
  final String location;
  final String date;
  final String time;

  factory Booking.fromApi(Map<String, dynamic> json) {
    final member = json['member'];
    final space = json['space'];
    final branch = json['branch'];
    final memberName = member is Map<String, dynamic>
        ? member['name'] as String? ?? 'Member'
        : 'Member';
    final workspace = space is Map<String, dynamic>
        ? space['name'] as String? ?? 'Workspace'
        : 'Workspace';
    final location = branch is Map<String, dynamic>
        ? branch['name'] as String? ?? 'Location'
        : 'Location';
    final start = DateTime.tryParse(json['startTime'] as String? ?? '');
    final end = DateTime.tryParse(json['endTime'] as String? ?? '');

    return Booking(
      id: json['_id'] as String?,
      name: memberName,
      initials: _initials(memberName),
      status: _statusFromApi(json['status'] as String?),
      workspace: workspace,
      location: location,
      date: _dateLabel(start),
      time: start == null || end == null
          ? 'Time unavailable'
          : '${_timeLabel(start)} - ${_timeLabel(end)}',
    );
  }
}

BookingStatus _statusFromApi(String? status) => switch (status) {
  'confirmed' => BookingStatus.confirmed,
  'cancelled' => BookingStatus.cancelled,
  'completed' => BookingStatus.active,
  _ => BookingStatus.pending,
};

String _initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty || parts.first.isEmpty) return 'M';
  return parts.take(2).map((part) => part[0].toUpperCase()).join();
}

String _dateLabel(DateTime? value) {
  if (value == null) return 'Date unavailable';
  final now = DateTime.now();
  final local = value.toLocal();
  final today = DateTime(now.year, now.month, now.day);
  final date = DateTime(local.year, local.month, local.day);
  if (date == today) return 'Today';
  if (date == today.add(const Duration(days: 1))) return 'Tomorrow';
  return '${local.day}/${local.month}/${local.year}';
}

String _timeLabel(DateTime value) {
  final local = value.toLocal();
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
