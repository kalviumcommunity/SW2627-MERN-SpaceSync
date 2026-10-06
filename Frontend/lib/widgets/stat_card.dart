import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';

class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.metric, this.onTap});

  final SummaryMetric metric;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);
    final iconTint = switch (metric.title) {
      'Occupancy' => colors.successContainer,
      'Available' => colors.warningContainer,
      'Bookings' => colors.infoContainer,
      _ => colors.primarySoft,
    };
    final iconColor = switch (metric.title) {
      'Occupancy' => colors.success,
      'Available' => colors.warning,
      _ => Theme.of(context).colorScheme.primary,
    };

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
                      color: iconTint,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(metric.icon, size: 19, color: iconColor),
                  ),
                  const Spacer(),
                  Expanded(
                    child: Text(
                      metric.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: textTheme.labelMedium?.copyWith(
                        color: colors.muted,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 11),
              Text(
                metric.value,
                style: textTheme.titleLarge?.copyWith(
                  fontSize: 24,
                  height: 1,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                metric.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelMedium?.copyWith(fontSize: 10.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
