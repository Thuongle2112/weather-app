import 'package:flutter/material.dart';
import 'dart:math' as math;

class SnowButtonPainter extends CustomPainter {
  final bool isDarkMode;
  final Animation<double>? animation;

  SnowButtonPainter({required this.isDarkMode, this.animation})
    : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    // Vẽ tuyết phủ góc top-right (dày, nhũn)
    _drawTopRightSnowLayer(canvas, size);

    // Vẽ tuyết phủ border dưới với icicles rủ xuống ra ngoài
    _drawBottomSnowLayer(canvas, size);

    // Vẽ bông tuyết rơi nhẹ
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

    // Bắt đầu từ khoảng 60% width (phía bên phải)
    final startX = size.width * 0.6;
    path.moveTo(startX, 0);

    // Vẽ đường tuyết dày, uốn lượn tự nhiên sang phải
    double currentX = startX;
    final endX = size.width - 30;

    while (currentX < endX) {
      final progress = (currentX - startX) / (endX - startX);

      // Tạo độ dày không đều, dày hơn ở giữa (12-20px)
      final baseThickness = 12.0 + math.sin(progress * math.pi) * 8;

      // Thêm sóng nhỏ trên bề mặt
      final surfaceWave = math.sin(progress * math.pi * 6) * 2;

      // Thêm độ ngẫu nhiên
      final randomness = random.nextDouble() * 2 - 1;

      final y = baseThickness + surfaceWave + randomness;

      path.lineTo(currentX, y);
      currentX += 6; // Bước nhỏ để mượt
    }

    // Kết thúc tại góc phải trên
    path.lineTo(size.width - 30, 0);

    // Đóng path về điểm bắt đầu
    path.lineTo(startX, 0);
    path.close();

    // Vẽ shadow trước
    canvas.drawPath(path, shadowPaint);

    // Vẽ tuyết chính
    canvas.drawPath(path, paint);

    // Thêm highlight (phần sáng trên tuyết)
    _drawTopRightSnowHighlight(canvas, size, startX);

    // Thêm sparkles
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

    // Bắt đầu từ góc trái dưới
    path.moveTo(30, size.height);

    // Vẽ đường tuyết với icicles RỦ XUỐNG RA NGOÀI
    double currentX = 30;
    final endX = size.width - 30;

    while (currentX < endX) {
      final progress = currentX / size.width;

      // Độ dày cơ bản (nhỏ hơn border trên)
      final baseThickness = 6.0 + math.sin(progress * math.pi * 2.5) * 2;

      // Sóng nhỏ trên bề mặt
      final surfaceWave = math.sin(progress * math.pi * 10) * 1.5;

      // Tạo icicles RỦ XUỐNG (y tăng = xuống dưới)
      double icicleLength = 0;
      if (random.nextDouble() > 0.65) {
        // 35% cơ hội có icicle
        icicleLength = -(6 + random.nextDouble() * 12); // Âm = rủ xuống
      }

      // Y position: size.height - thickness + icicle (rủ xuống)
      final y = size.height - baseThickness - surfaceWave + icicleLength;

      path.lineTo(currentX, y);
      currentX += 5;
    }

    // Kết thúc tại góc phải dưới
    path.lineTo(size.width - 30, size.height);
    path.lineTo(30, size.height);
    path.close();

    // Vẽ shadow
    canvas.drawPath(path, shadowPaint);

    // Vẽ tuyết
    canvas.drawPath(path, paint);

    // Vẽ các icicles riêng lẻ để rõ hơn
    _drawIcicles(canvas, size);

    // Thêm sparkles
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

    // Vẽ 5-7 icicles rõ ràng
    for (int i = 0; i < 6; i++) {
      final x = 50 + random.nextDouble() * (size.width - 100);
      final baseY = size.height - 6;
      final length = 8 + random.nextDouble() * 15;
      final width = 2.5 + random.nextDouble() * 2;

      // Tạo path cho icicle (hình tam giác dài)
      final iciclePath = Path();
      iciclePath.moveTo(x - width / 2, baseY);
      iciclePath.lineTo(x, baseY + length); // Đỉnh nhọn ở dưới
      iciclePath.lineTo(x + width / 2, baseY);
      iciclePath.close();

      // Vẽ shadow
      canvas.drawPath(iciclePath, shadowPaint);

      // Vẽ icicle
      canvas.drawPath(iciclePath, iciclePaint);

      // Thêm highlight cho icicle
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

    // Vẽ đường highlight song song phía trên
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

    // Vẽ sparkles lấp lánh chỉ ở vùng top-right
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
    // Vẽ ngôi sao 4 cánh
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

    // Điểm giữa
    canvas.drawCircle(center, size * 0.5, paint);
  }

  void _drawFallingSnowflakes(Canvas canvas, Size size) {
    final random = math.Random(789);
    final progress = animation?.value ?? 0.0;

    // Tuyết rơi ở 2 bên
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

      // Vẽ bông tuyết với độ mờ dần
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
