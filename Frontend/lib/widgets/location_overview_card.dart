import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';

class LocationOverviewCard extends StatelessWidget {
  const LocationOverviewCard({super.key, required this.location, this.onTap});

  final LocationData location;
  final VoidCallback? onTap;

  String get _statusLabel => switch (location.status) {
    LocationStatus.nearCapacity => 'Near Capacity',
    LocationStatus.available => 'Available',
    LocationStatus.highDemand => 'High Demand',
  };

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);
    final statusColor = switch (location.status) {
      LocationStatus.nearCapacity => colors.warning,
      LocationStatus.available => colors.success,
      LocationStatus.highDemand => colors.danger,
    };
    final statusBackground = switch (location.status) {
      LocationStatus.nearCapacity => colors.warningContainer,
      LocationStatus.available => colors.successContainer,
      LocationStatus.highDemand => colors.dangerContainer,
    };
    final percentage = (location.utilization * 100).round();

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(20),
      elevation: 1.5,
      shadowColor: colors.shadow,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: colors.primarySoft,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      Icons.location_city_rounded,
                      size: 19,
                      color: colors.info,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      location.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$percentage%',
                    style: textTheme.titleMedium?.copyWith(
                      color: statusColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          '${location.occupied} / ${location.capacity}',
                          style: textTheme.titleMedium?.copyWith(fontSize: 12),
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            'occupied',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.labelMedium?.copyWith(
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusBackground,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _statusLabel,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: location.utilization,
                  minHeight: 6,
                  color: statusColor,
                  backgroundColor: colors.outlineSoft,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
