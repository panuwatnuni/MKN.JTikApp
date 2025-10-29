import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/ticket.dart';
import '../theme/app_theme.dart';

class StatusPieChart extends StatelessWidget {
  const StatusPieChart({
    required this.summary,
    super.key,
  });

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final total = summary.total;
    final data = [
      _Slice('รอดำเนินการ', summary.pending, AppColors.primaryBlue),
      _Slice('กำลังดำเนินการ', summary.inProgress, AppColors.accentBlue),
      _Slice('รออะไหล่', summary.waitingParts, AppColors.mediumGrey),
      _Slice('เสร็จสิ้น', summary.completed, Colors.grey.shade300),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'สถานะงานรวม',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final size = math.min(constraints.maxWidth, 220.0);
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size,
                      width: size,
                      child: CustomPaint(
                        painter: _PiePainter(data, total),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$total',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              Text(
                                'ทั้งหมด',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: data
                            .map(
                              (slice) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 12,
                                      width: 12,
                                      decoration: BoxDecoration(
                                        color: slice.color,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        '${slice.label} (${slice.value})',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: AppColors.darkGrey),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Slice {
  const _Slice(this.label, this.value, this.color);

  final String label;
  final int value;
  final Color color;
}

class _PiePainter extends CustomPainter {
  _PiePainter(this.data, this.total);

  final List<_Slice> data;
  final int total;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()..style = PaintingStyle.stroke;
    const strokeWidth = 24.0;
    paint.strokeWidth = strokeWidth;
    double startAngle = -math.pi / 2;

    if (total == 0) {
      paint.color = AppColors.lightBlue;
      canvas.drawArc(
        rect.deflate(strokeWidth / 2),
        startAngle,
        math.pi * 2,
        false,
        paint,
      );
      return;
    }

    for (final slice in data) {
      if (slice.value <= 0) {
        continue;
      }
      paint.color = slice.color;
      final sweep = (slice.value / total) * math.pi * 2;
      canvas.drawArc(
        rect.deflate(strokeWidth / 2),
        startAngle,
        sweep,
        false,
        paint,
      );
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _PiePainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.total != total;
  }
}
