import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../services/api_client.dart';
import '../theme/app_theme.dart';
import '../widgets/alert_card.dart';
import '../widgets/app_header.dart';
import '../widgets/location_overview_card.dart';
import '../widgets/occupancy_overview_card.dart';
import '../widgets/peak_hours_section.dart';
import '../widgets/stat_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<DashboardData> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = ApiClient.instance.fetchDashboard();
  }

  @override
  Widget build(BuildContext context) {
    const contentWidth = 360.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : contentWidth;
        final availableWidth = (width - 36).clamp(0.0, contentWidth).toDouble();
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
          child: Center(
            child: SizedBox(
              width: availableWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppHeader(
                    onNotificationsTap: () => _showMessage(
                      context,
                      'You have 2 unread notifications.',
                    ),
                    onAvatarTap: () => _showMessage(context, 'Admin profile'),
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder<DashboardData>(
                    future: _dashboardFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const _LoadingState(message: 'Loading live dashboard...');
                      }
                      if (snapshot.hasError) {
                        return _ErrorState(
                          message: snapshot.error.toString(),
                          onRetry: () => setState(
                            () => _dashboardFuture =
                                ApiClient.instance.fetchDashboard(),
                          ),
                        );
                      }
                      return _buildDashboard(
                        context,
                        availableWidth,
                        snapshot.data!,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildDashboard(
    BuildContext context,
    double availableWidth,
    DashboardData dashboard,
  ) {
    const columns = 2;
    final cardWidth = (availableWidth - (columns - 1) * 12) / columns;
    const locationColumns = 1;
    final locationWidth =
        (availableWidth - (locationColumns - 1) * 12) / locationColumns;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _todayLabel(),
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.of(context).muted,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 7),
        Text('Good morning, Admin', style: textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text(
          "Here's what's happening across your workspaces today.",
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 22),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _summaryMetrics(dashboard)
              .map(
                (metric) => SizedBox(
                  width: cardWidth,
                  child: StatCard(
                    metric: metric,
                    onTap: () =>
                        _showMessage(context, '${metric.title} overview'),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 25),
        const _SectionHeading(title: 'Live Occupancy'),
        const SizedBox(height: 12),
        OccupancyOverviewCard(data: _occupancyData(dashboard)),
        const SizedBox(height: 25),
        const _SectionHeading(title: 'Peak Hours'),
        const SizedBox(height: 12),
        PeakHoursSection(hours: _peakHours(dashboard.averageUtilization)),
        const SizedBox(height: 25),
        const _SectionHeading(title: 'Location Overview'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _locations(dashboard)
              .map(
                (location) => SizedBox(
                  width: locationWidth,
                  child: LocationOverviewCard(
                    location: location,
                    onTap: () =>
                        _showMessage(context, '${location.name} details'),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 25),
        const _SectionHeading(title: 'Active Alerts'),
        const SizedBox(height: 12),
        ..._alerts(dashboard).map(
          (alert) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AlertCard(alert: alert),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  List<SummaryMetric> _summaryMetrics(DashboardData dashboard) => [
    SummaryMetric(
      title: 'Locations',
      value: dashboard.branchCount.toString(),
      caption: 'Total locations',
      icon: Icons.apartment_rounded,
    ),
    SummaryMetric(
      title: 'Bookings',
      value: dashboard.bookingCount.toString(),
      caption: 'Demo bookings',
      icon: Icons.calendar_month_rounded,
    ),
    SummaryMetric(
      title: 'Occupancy',
      value: '${(dashboard.averageUtilization * 100).round()}%',
      caption: 'Avg utilization',
      icon: Icons.bar_chart_rounded,
    ),
    SummaryMetric(
      title: 'Available',
      value: dashboard.availableSpaces.toString(),
      caption: 'Available spaces',
      icon: Icons.desk_rounded,
    ),
  ];

  OccupancyData _occupancyData(DashboardData dashboard) {
    final occupied = dashboard.bookingCount;
    final available = dashboard.availableSpaces;
    return OccupancyData(
      percentage: dashboard.averageUtilization.clamp(0, 1).toDouble(),
      occupied: occupied,
      available: available,
      deskUtilization: dashboard.averageUtilization.clamp(0, 1).toDouble(),
      roomUtilization: (dashboard.averageUtilization * 0.9)
          .clamp(0, 1)
          .toDouble(),
    );
  }

  List<PeakHour> _peakHours(double average) {
    final base = (average * 100).round().clamp(25, 85);
    return [
      PeakHour(label: '8 AM', occupancy: (base - 22).toDouble()),
      PeakHour(label: '9 AM', occupancy: (base - 8).toDouble()),
      PeakHour(label: '10 AM', occupancy: base.toDouble()),
      PeakHour(label: '11 AM', occupancy: (base + 10).clamp(0, 100).toDouble()),
      PeakHour(label: '12 PM', occupancy: (base + 14).clamp(0, 100).toDouble()),
      PeakHour(label: '1 PM', occupancy: (base + 8).clamp(0, 100).toDouble()),
      PeakHour(label: '2 PM', occupancy: (base + 4).clamp(0, 100).toDouble()),
      PeakHour(label: '3 PM', occupancy: (base + 12).clamp(0, 100).toDouble()),
      PeakHour(label: '4 PM', occupancy: (base + 5).clamp(0, 100).toDouble()),
      PeakHour(label: '5 PM', occupancy: (base - 6).clamp(0, 100).toDouble()),
      PeakHour(label: '6 PM', occupancy: (base - 18).clamp(0, 100).toDouble()),
    ];
  }

  List<LocationData> _locations(DashboardData dashboard) =>
      dashboard.locations.map((location) {
        final percent = location.utilizationRate;
        final status = percent >= 0.75
            ? LocationStatus.nearCapacity
            : percent >= 0.55
                ? LocationStatus.highDemand
                : LocationStatus.available;
        return LocationData(
          name: location.name,
          occupied: location.occupied,
          capacity: location.capacity == 0 ? 1 : location.capacity,
          status: status,
        );
      }).toList();

  List<AlertData> _alerts(DashboardData dashboard) {
    final busiest = [...dashboard.locations]
      ..sort((a, b) => b.utilizationRate.compareTo(a.utilizationRate));
    if (busiest.isEmpty) return activeAlerts.take(1).toList();
    return [
      AlertData(
        title: '${busiest.first.name} has the highest demand',
        description:
            'Current demo utilization is ${(busiest.first.utilizationRate * 100).round()}%.',
        severity: AlertSeverity.highDemand,
      ),
      AlertData(
        title: 'Backend connection is live',
        description: 'Dashboard data is being read from the Express API.',
        severity: AlertSeverity.warning,
      ),
    ];
  }

  String _todayLabel() {
    final now = DateTime.now();
    return '${now.day}/${now.month}/${now.year}';
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) =>
      Text(title, style: Theme.of(context).textTheme.titleLarge);
}

class _LoadingState extends StatelessWidget {
  const _LoadingState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 48),
    child: Center(
      child: Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 14),
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    ),
  );
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 40),
    child: Column(
      children: [
        Text('Could not load backend data', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 14),
        FilledButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    ),
  );
}
