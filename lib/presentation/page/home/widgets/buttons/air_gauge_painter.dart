import 'dart:math';
import 'package:flutter/material.dart';

class AirGaugePainter extends CustomPainter {
  final int aqi; // 1-5

  AirGaugePainter({required this.aqi});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 8;
    final sectionCount = 5;
    final fullSweep = pi; // half circle
    final sectionSweep = fullSweep / sectionCount;
    final startAngle = pi;
    final gap = 0.06; // small gap between sections

    // Draw background (soft)
    final bgPaint =
        Paint()
          ..color = Colors.transparent
          ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius + 8, bgPaint);

    // Section colors mapped to AQI (Good -> Very Poor)
    final sectionColors = [
      Color(0xFF2ECC71), // Good - green
      Color(0xFF9AE66E), // Fair - light green
      Color(0xFFF1C40F), // Moderate - yellow
      Color(0xFFF39C12), // Poor - orange
      Color(0xFFE74C3C), // Very Poor - red
    ];

    // Draw gauge sections with small gaps
    for (int i = 0; i < sectionCount; i++) {
      final paint =
          Paint()
            ..color = sectionColors[i]
            ..style = PaintingStyle.stroke
            ..strokeWidth = max(12.0, radius * 0.16)
            ..strokeCap = StrokeCap.butt;
      final start = startAngle + i * sectionSweep + gap / 2;
      final sweep = sectionSweep - gap;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        false,
        paint,
      );
    }

    // Calculate needle angle (map aqi 1..5 to 0..pi)
    final valueNorm = (aqi.clamp(1, sectionCount)) / sectionCount;
    final needleAngle = startAngle + valueNorm * fullSweep;
    final needleLength = radius - max(10.0, radius * 0.18);

    // Draw needle as thin black pointer (filled triangle)
    max(6.0, radius * 0.06);
    final tip = Offset(
      center.dx + needleLength * cos(needleAngle),
      center.dy + needleLength * sin(needleAngle),
    );
    final leftBase = Offset(
      center.dx + 8 * cos(needleAngle + pi / 2),
      center.dy + 8 * sin(needleAngle + pi / 2),
    );
    final rightBase = Offset(
      center.dx + 8 * cos(needleAngle - pi / 2),
      center.dy + 8 * sin(needleAngle - pi / 2),
    );

    final needlePath =
        Path()
          ..moveTo(tip.dx, tip.dy)
          ..lineTo(leftBase.dx, leftBase.dy)
          ..lineTo(center.dx, center.dy)
          ..lineTo(rightBase.dx, rightBase.dy)
          ..close();

    final needlePaint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.fill
          ..isAntiAlias = true;
    canvas.drawPath(needlePath, needlePaint);

    // final knobOuter = Paint()
    //   ..color = Colors.black
    //   ..style = PaintingStyle.fill
    //   ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);

    // canvas.drawCircle(center, max(10.0, radius * 0.12), knobOuter);

    // final knobInner =
    //     Paint()
    //       ..color = Colors.white.withOpacity(0.06)
    //       ..style = PaintingStyle.fill;
    // canvas.drawCircle(center, max(6.0, radius * 0.07), knobInner);

    // final knobBorder =
    //     Paint()
    //       ..color = Colors.grey.withOpacity(0.25)
    //       ..style = PaintingStyle.stroke
    //       ..strokeWidth = 1.0;
    // canvas.drawCircle(center, max(10.0, radius * 0.12), knobBorder);

    final knobPaint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.fill
          ..isAntiAlias = true;
    canvas.drawCircle(center, max(10.0, radius * 0.12), knobPaint);
  }

  @override
  bool shouldRepaint(covariant AirGaugePainter oldDelegate) =>
      oldDelegate.aqi != aqi;
}
