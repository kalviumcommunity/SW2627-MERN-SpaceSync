import 'package:flutter/material.dart';

import '../data/analytics_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = constraints.maxWidth.isFinite
            ? (constraints.maxWidth - 36).clamp(0.0, 400.0).toDouble()
            : 360.0;
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
          child: Center(
            child: SizedBox(
              width: contentWidth,
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
                  const SizedBox(height: 21),
                  Text(
                    'Analytics',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Track utilization and business performance',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 18),
                  const _KpiGrid(),
                  const SizedBox(height: 24),
                  const _SectionTitle(
                    title: 'Occupancy Trend',
                    trailing: '2026',
                  ),
                  const SizedBox(height: 11),
                  const _OccupancyChartCard(),
                  const SizedBox(height: 24),
                  const _SectionTitle(title: 'Expansion Candidates'),
                  const SizedBox(height: 4),
                  Text(
                    'Locations showing sustained demand',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  for (final candidate in expansionCandidates)
                    _ExpansionCandidateCard(candidate: candidate),
                  const SizedBox(height: 4),
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
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid();

  static const _metrics = <_KpiMetric>[
    _KpiMetric(
      '78%',
      'Avg. Occupancy',
      '+4.2% vs last month',
      Icons.trending_up_rounded,
    ),
    _KpiMetric(
      'Mon',
      'Peak Day',
      '93% avg occupancy',
      Icons.calendar_today_rounded,
    ),
    _KpiMetric(
      '₹12.4L',
      'Revenue (MTD)',
      '+18% vs last month',
      Icons.trending_up_rounded,
    ),
    _KpiMetric(
      '22%',
      'Walk-in Rate',
      '+3% vs last month',
      Icons.trending_up_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 10) / 2;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final metric in _metrics)
              SizedBox(
                width: cardWidth,
                child: _KpiCard(metric: metric),
              ),
          ],
        );
      },
    );
  }
}

class _KpiMetric {
  const _KpiMetric(this.value, this.label, this.caption, this.icon);

  final String value;
  final String label;
  final String caption;
  final IconData icon;
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.metric});

  final _KpiMetric metric;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      constraints: const BoxConstraints(minHeight: 116),
      padding: const EdgeInsets.fromLTRB(12, 12, 10, 11),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outline),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  metric.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium
                      ?.copyWith(fontSize: 11),
                ),
              ),
              Icon(metric.icon, size: 16, color: colors.success),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            metric.value,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            metric.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: colors.success, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(fontSize: 12, fontWeight: FontWeight.w700),
          ),
      ],
    );
  }
}

class _OccupancyChartCard extends StatelessWidget {
  const _OccupancyChartCard();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      height: 228,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.outline),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _OccupancyChartPainter(
            colors: colors,
            lineColor: Theme.of(context).colorScheme.primary,
          ),
          child: SizedBox.expand(),
        ),
      ),
    );
  }
}

class _OccupancyChartPainter extends CustomPainter {
  const _OccupancyChartPainter({required this.colors, required this.lineColor});

  final AppColors colors;
  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 29.0;
    const right = 5.0;
    const top = 12.0;
    const bottom = 30.0;
    final chart = Rect.fromLTRB(
      left,
      top,
      size.width - right,
      size.height - bottom,
    );
    final gridPaint = Paint()
      ..color = colors.chartGrid
      ..strokeWidth = 1;
    final labelStyle = TextStyle(
      color: colors.muted,
      fontSize: 9,
      fontWeight: FontWeight.w500,
    );

    for (final level in [40, 60, 80, 100]) {
      final y = chart.bottom - ((level - 40) / 60) * chart.height;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
      _drawLabel(canvas, '$level%', Offset(0, y - 6), labelStyle);
    }

    final points = <Offset>[
      for (var index = 0; index < occupancyTrend.length; index++)
        Offset(
          chart.left + index * chart.width / (occupancyTrend.length - 1),
          chart.bottom -
              ((occupancyTrend[index].percentage - 40) / 60) * chart.height,
        ),
    ];
    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (var index = 1; index < points.length; index++) {
      linePath.lineTo(points[index].dx, points[index].dy);
    }
    final fillPath = Path.from(linePath)
      ..lineTo(points.last.dx, chart.bottom)
      ..lineTo(points.first.dx, chart.bottom)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colors.chartFill, colors.chartFill.withValues(alpha: 0)],
        ).createShader(chart),
    );
    canvas.drawPath(
      linePath,
      Paint()
        ..color = lineColor
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke,
    );
    for (var index = 0; index < points.length; index++) {
      canvas.drawCircle(
        points[index],
        index == points.length - 1 ? 4 : 2.5,
        Paint()..color = lineColor,
      );
      canvas.drawCircle(
        points[index],
        index == points.length - 1 ? 2 : 1,
        Paint()..color = colors.surface,
      );
      _drawLabel(
        canvas,
        occupancyTrend[index].month,
        Offset(points[index].dx - 9, chart.bottom + 9),
        labelStyle,
      );
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset offset, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _OccupancyChartPainter oldDelegate) =>
      oldDelegate.colors != colors || oldDelegate.lineColor != lineColor;
}

class _ExpansionCandidateCard extends StatelessWidget {
  const _ExpansionCandidateCard({required this.candidate});

  final ExpansionCandidate candidate;

  @override
  Widget build(BuildContext context) {
    final highPriority = candidate.priority == 'High';
    final colors = AppColors.of(context);
    final accent = highPriority ? colors.warning : colors.info;
    final tint = highPriority ? colors.warningContainer : colors.infoContainer;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: colors.outline),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colors.iconSurface,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(Icons.apartment_rounded, color: colors.info),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  candidate.location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontSize: 13),
                ),
                const SizedBox(height: 3),
                Text(
                  candidate.recommendation,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(fontSize: 11),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      size: 15,
                      color: colors.success,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${candidate.occupancy}% occupancy',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colors.success,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 7),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              candidate.priority,
              style: TextStyle(
                color: accent,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
