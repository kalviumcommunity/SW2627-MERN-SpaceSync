import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/alert_card.dart';
import '../widgets/app_header.dart';
import '../widgets/location_overview_card.dart';
import '../widgets/occupancy_overview_card.dart';
import '../widgets/peak_hours_section.dart';
import '../widgets/stat_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                  _buildDashboard(context, availableWidth),
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

  Widget _buildDashboard(BuildContext context, double availableWidth) {
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
          'Monday, September 29, 2026',
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.of(context).muted,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 7),
        Text('Good morning, Admin 👋', style: textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text(
          "Here's what's happening across your workspaces today.",
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 22),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: summaryMetrics
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
        const OccupancyOverviewCard(data: occupancyData),
        const SizedBox(height: 25),
        const _SectionHeading(title: 'Peak Hours'),
        const SizedBox(height: 12),
        const PeakHoursSection(hours: peakHours),
        const SizedBox(height: 25),
        const _SectionHeading(title: 'Location Overview'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: locations
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
        ...activeAlerts.map(
          (alert) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AlertCard(alert: alert),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) =>
      Text(title, style: Theme.of(context).textTheme.titleLarge);
}
