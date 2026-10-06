import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';

class AlertCard extends StatelessWidget {
  const AlertCard({super.key, required this.alert});

  final AlertData alert;

  IconData get _icon => switch (alert.severity) {
    AlertSeverity.warning => Icons.warning_amber_rounded,
    AlertSeverity.highDemand => Icons.trending_up_rounded,
    AlertSeverity.conflict => Icons.event_busy_rounded,
  };

  String get _label => switch (alert.severity) {
    AlertSeverity.warning => 'Warning',
    AlertSeverity.highDemand => 'High demand',
    AlertSeverity.conflict => 'Conflict',
  };

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);
    final accent = alert.severity == AlertSeverity.warning
        ? colors.warning
        : colors.danger;
    final tint = alert.severity == AlertSeverity.warning
        ? colors.warningContainer
        : colors.dangerContainer;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: colors.shadow, blurRadius: 14, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(_icon, color: accent, size: 19),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        alert.title,
                        style: textTheme.titleMedium?.copyWith(fontSize: 13),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      _label,
                      style: TextStyle(
                        color: accent,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(alert.description, style: textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
