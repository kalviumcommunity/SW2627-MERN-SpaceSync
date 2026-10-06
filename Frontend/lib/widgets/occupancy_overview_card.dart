import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';

class OccupancyOverviewCard extends StatelessWidget {
  const OccupancyOverviewCard({super.key, required this.data});

  final OccupancyData data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: colors.shadow, blurRadius: 18, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 108,
                height: 108,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: data.percentage,
                        strokeWidth: 9,
                        strokeCap: StrokeCap.round,
                        backgroundColor: colors.outlineSoft,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(data.percentage * 100).round()}%',
                          style: textTheme.titleLarge?.copyWith(
                            fontSize: 25,
                            height: 1,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'occupied',
                          style: textTheme.labelMedium?.copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current occupancy', style: textTheme.bodyMedium),
                    const SizedBox(height: 13),
                    Row(
                      children: [
                        Expanded(
                          child: _OccupancyCount(
                            value: '${data.occupied}',
                            label: 'Occupied',
                            color: colors.info,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _OccupancyCount(
                            value: '${data.available}',
                            label: 'Available',
                            color: colors.success,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _UtilizationBar(
            label: 'Desk utilization',
            value: data.deskUtilization,
            color: colors.info,
          ),
          const SizedBox(height: 13),
          _UtilizationBar(
            label: 'Room utilization',
            value: data.roomUtilization,
            color: colors.success,
          ),
        ],
      ),
    );
  }
}

class _OccupancyCount extends StatelessWidget {
  const _OccupancyCount({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 19,
            fontWeight: FontWeight.w700,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 3),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}

class _UtilizationBar extends StatelessWidget {
  const _UtilizationBar({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(fontSize: 11),
              ),
            ),
            Text(
              '${(value * 100).round()}%',
              style: Theme.of(context).textTheme.labelMedium
                  ?.copyWith(color: colors.muted, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 6,
            color: color,
            backgroundColor: colors.outlineSoft,
          ),
        ),
      ],
    );
  }
}
