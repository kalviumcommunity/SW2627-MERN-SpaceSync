import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';

class PeakHoursSection extends StatelessWidget {
  const PeakHoursSection({super.key, required this.hours});

  final List<PeakHour> hours;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(17, 16, 17, 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: colors.shadow, blurRadius: 18, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Today\'s occupancy', style: textTheme.titleMedium),
              ),
              Icon(Icons.schedule_rounded, size: 16, color: colors.muted),
              const SizedBox(width: 5),
              Text('8 AM – 6 PM', style: textTheme.labelMedium),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 142,
            width: double.infinity,
            child: CustomPaint(
              painter: _PeakHoursPainter(
                hours,
                colors: colors,
                lineColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Expanded(child: _TimeLabel('8 AM')),
              Expanded(child: _TimeLabel('10 AM')),
              Expanded(child: _TimeLabel('12 PM')),
              Expanded(child: _TimeLabel('2 PM')),
              Expanded(child: _TimeLabel('4 PM')),
              Expanded(child: _TimeLabel('6 PM')),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _ChartLegend(color: colors.success, label: 'Normal'),
              _ChartLegend(color: colors.warning, label: 'High'),
              _ChartLegend(color: colors.danger, label: 'Peak'),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeLabel extends StatelessWidget {
  const _TimeLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Text(
    label,
    textAlign: TextAlign.center,
    maxLines: 1,
    style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 9),
  );
}

class _ChartLegend extends StatelessWidget {
  const _ChartLegend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}

class _PeakHoursPainter extends CustomPainter {
  _PeakHoursPainter(
    this.hours, {
    required this.colors,
    required this.lineColor,
  });

  final List<PeakHour> hours;
  final AppColors colors;
  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (hours.isEmpty) return;

    const left = 8.0;
    const right = 8.0;
    const top = 20.0;
    const bottom = 9.0;
    final chartWidth = size.width - left - right;
    final chartHeight = size.height - top - bottom;

    final gridPaint = Paint()
      ..color = colors.chartGrid
      ..strokeWidth = 1;
    for (final level in [25.0, 50.0, 75.0]) {
      final y = top + chartHeight * (1 - level / 100);
      canvas.drawLine(
        Offset(left, y),
        Offset(size.width - right, y),
        gridPaint,
      );
    }

    final points = List<Offset>.generate(hours.length, (index) {
      final x = left + chartWidth * index / (hours.length - 1);
      final y = top + chartHeight * (1 - hours[index].occupancy / 100);
      return Offset(x, y);
    });

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      linePath.lineTo(point.dx, point.dy);
    }
    final fillPath = Path.from(linePath)
      ..lineTo(points.last.dx, size.height - bottom)
      ..lineTo(points.first.dx, size.height - bottom)
      ..close();
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [colors.chartFill, colors.chartFill.withValues(alpha: 0)],
      ).createShader(Rect.fromLTWH(0, top, size.width, chartHeight));
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(linePath, linePaint);

    final peakIndex = hours.indexed
        .reduce(
          (current, next) =>
              next.$2.occupancy > current.$2.occupancy ? next : current,
        )
        .$1;
    final peak = points[peakIndex];
    canvas.drawCircle(
      peak,
      7,
      Paint()..color = colors.danger.withValues(alpha: 0.2),
    );
    canvas.drawCircle(peak, 4, Paint()..color = colors.danger);

    final label = TextPainter(
      text: TextSpan(
        text: '90%',
        style: TextStyle(
          color: colors.danger,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    label.paint(canvas, Offset(peak.dx - label.width / 2, peak.dy - 19));
  }

  @override
  bool shouldRepaint(covariant _PeakHoursPainter oldDelegate) =>
      oldDelegate.hours != hours ||
      oldDelegate.colors != colors ||
      oldDelegate.lineColor != lineColor;
}
