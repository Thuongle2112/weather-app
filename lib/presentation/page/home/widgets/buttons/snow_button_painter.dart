import 'package:flutter/material.dart';
import 'dart:math' as math;

class SnowButtonPainter extends CustomPainter {
  final bool isDarkMode;
  final Animation<double>? animation;

  SnowButtonPainter({required this.isDarkMode, this.animation})
    : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    _drawTopRightSnowLayer(canvas, size);

    _drawBottomSnowLayer(canvas, size);

    if (animation != null) {
      _drawFallingSnowflakes(canvas, size);
    }
  }

  void _drawTopRightSnowLayer(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.92)
          ..style = PaintingStyle.fill;

    final shadowPaint =
        Paint()
          ..color = Colors.black.withOpacity(0.08)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final path = Path();
    final random = math.Random(42);

    final startX = size.width * 0.6;
    path.moveTo(startX, 0);

    double currentX = startX;
    final endX = size.width - 30;

    while (currentX < endX) {
      final progress = (currentX - startX) / (endX - startX);

      final baseThickness = 12.0 + math.sin(progress * math.pi) * 8;

      final surfaceWave = math.sin(progress * math.pi * 6) * 2;

      final randomness = random.nextDouble() * 2 - 1;

      final y = baseThickness + surfaceWave + randomness;

      path.lineTo(currentX, y);
      currentX += 6;
    }

    path.lineTo(size.width - 30, 0);

    path.lineTo(startX, 0);
    path.close();

    canvas.drawPath(path, shadowPaint);

    canvas.drawPath(path, paint);

    _drawTopRightSnowHighlight(canvas, size, startX);

    _drawTopRightSparkles(canvas, size, startX);
  }

  void _drawBottomSnowLayer(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.88)
          ..style = PaintingStyle.fill;

    final shadowPaint =
        Paint()
          ..color = Colors.black.withOpacity(0.1)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final path = Path();
    final random = math.Random(84);

    path.moveTo(30, size.height);

    double currentX = 30;
    final endX = size.width - 30;

    while (currentX < endX) {
      final progress = currentX / size.width;

      final baseThickness = 6.0 + math.sin(progress * math.pi * 2.5) * 2;

      final surfaceWave = math.sin(progress * math.pi * 10) * 1.5;

      double icicleLength = 0;
      if (random.nextDouble() > 0.65) {
        icicleLength = -(6 + random.nextDouble() * 12);
      }

      final y = size.height - baseThickness - surfaceWave + icicleLength;

      path.lineTo(currentX, y);
      currentX += 5;
    }

    path.lineTo(size.width - 30, size.height);
    path.lineTo(30, size.height);
    path.close();

    canvas.drawPath(path, shadowPaint);

    canvas.drawPath(path, paint);

    _drawIcicles(canvas, size);

    _drawBottomSparkles(canvas, size);
  }

  void _drawIcicles(Canvas canvas, Size size) {
    final iciclePaint =
        Paint()
          ..color = Colors.white.withOpacity(0.85)
          ..style = PaintingStyle.fill;

    final shadowPaint =
        Paint()
          ..color = Colors.black.withOpacity(0.08)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    final random = math.Random(200);

    for (int i = 0; i < 6; i++) {
      final x = 50 + random.nextDouble() * (size.width - 100);
      final baseY = size.height - 6;
      final length = 8 + random.nextDouble() * 15;
      final width = 2.5 + random.nextDouble() * 2;

      final iciclePath = Path();
      iciclePath.moveTo(x - width / 2, baseY);
      iciclePath.lineTo(x, baseY + length);
      iciclePath.lineTo(x + width / 2, baseY);
      iciclePath.close();

      canvas.drawPath(iciclePath, shadowPaint);

      canvas.drawPath(iciclePath, iciclePaint);

      final highlightPaint =
          Paint()
            ..color = Colors.white.withOpacity(0.6)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.8;

      canvas.drawLine(
        Offset(x - width / 4, baseY),
        Offset(x, baseY + length * 0.7),
        highlightPaint,
      );
    }
  }

  void _drawTopRightSnowHighlight(Canvas canvas, Size size, double startX) {
    final highlightPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    final highlightPath = Path();
    final random = math.Random(100);

    double currentX = startX + 10;
    final endX = size.width - 35;

    highlightPath.moveTo(currentX, 3);

    while (currentX < endX) {
      final progress = (currentX - startX) / (endX - startX);
      final wave = math.sin(progress * math.pi * 6) * 1.5;
      final y = 3 + wave + random.nextDouble() * 0.5;

      highlightPath.lineTo(currentX, y);
      currentX += 8;
    }

    canvas.drawPath(highlightPath, highlightPaint);
  }

  void _drawTopRightSparkles(Canvas canvas, Size size, double startX) {
    final sparklePaint =
        Paint()
          ..color = Colors.white.withOpacity(0.9)
          ..style = PaintingStyle.fill;

    final random = math.Random(123);

    for (int i = 0; i < 5; i++) {
      final x = startX + 20 + random.nextDouble() * (size.width - startX - 50);
      final y = 3 + random.nextDouble() * 15;
      final sparkleSize = 1.2 + random.nextDouble() * 1.8;

      _drawStar(canvas, Offset(x, y), sparkleSize, sparklePaint);
    }
  }

  void _drawBottomSparkles(Canvas canvas, Size size) {
    final sparklePaint =
        Paint()
          ..color = Colors.white.withOpacity(0.85)
          ..style = PaintingStyle.fill;

    final random = math.Random(456);

    for (int i = 0; i < 4; i++) {
      final x = 50 + random.nextDouble() * (size.width - 100);
      final y = size.height - 5 - random.nextDouble() * 8;
      final sparkleSize = 1.0 + random.nextDouble() * 1.5;

      _drawStar(canvas, Offset(x, y), sparkleSize, sparklePaint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();

    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi / 2) + math.pi / 4;
      final x = center.dx + math.cos(angle) * size;
      final y = center.dy + math.sin(angle) * size;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);

    canvas.drawCircle(center, size * 0.5, paint);
  }

  void _drawFallingSnowflakes(Canvas canvas, Size size) {
    final random = math.Random(789);
    final progress = animation?.value ?? 0.0;

    for (int i = 0; i < 8; i++) {
      double x;

      if (i % 2 == 0) {
        x = random.nextDouble() * (size.width * 0.15);
      } else {
        x = size.width - (random.nextDouble() * (size.width * 0.15));
      }

      final baseY = -30 + (progress * size.height * 1.8);
      final y = (baseY + i * 15) % (size.height + 50);
      final snowSize = 1.5 + random.nextDouble() * 2.0;

      final fadeProgress = (y / size.height).clamp(0.0, 1.0);
      final fadedPaint =
          Paint()
            ..color = Colors.white.withOpacity(0.3 + fadeProgress * 0.3)
            ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), snowSize, fadedPaint);
    }
  }

  @override
  bool shouldRepaint(SnowButtonPainter oldDelegate) {
    return oldDelegate.isDarkMode != isDarkMode ||
        oldDelegate.animation != animation;
  }
}
