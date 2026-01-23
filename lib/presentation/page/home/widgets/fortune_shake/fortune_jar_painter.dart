import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class FortuneJarPainter extends CustomPainter {
  final double animationValue;
  final BuildContext context;

  FortuneJarPainter({required this.animationValue, required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Jar dimensions
    final jarWidth = size.width * 0.6;
    final jarHeight = size.height * 0.7;
    // final topRadius = jarWidth / 2;
    final bottomRadius = jarWidth / 2.2;

    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, centerY + jarHeight / 2 + 15),
        width: jarWidth * 1.1,
        height: 30,
      ),
      shadowPaint,
    );

    // Jar body gradient
    final jarBodyRect = Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: jarWidth,
      height: jarHeight,
    );

    final jarGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color(0xFFD32F2F),
        const Color(0xFFB71C1C),
        const Color(0xFF8B0000),
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final jarPaint = Paint()
      ..shader = jarGradient.createShader(jarBodyRect)
      ..style = PaintingStyle.fill;

    // Draw jar body (rounded rectangle)
    final jarPath = Path();
    jarPath.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, centerY + 10),
          width: jarWidth - 20,
          height: jarHeight - 40,
        ),
        const Radius.circular(20),
      ),
    );
    canvas.drawPath(jarPath, jarPaint);

    // Bottom base
    final bottomPaint = Paint()
      ..color = const Color(0xFF8B0000)
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, centerY + jarHeight / 2 - 20),
        width: bottomRadius * 1.85,
        height: 25,
      ),
      bottomPaint,
    );

    // Decorative gold band
    final goldBandPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFFFD700),
          const Color(0xFFFFA500),
          const Color(0xFFFFD700),
        ],
      ).createShader(
        Rect.fromCenter(
          center: Offset(centerX, centerY - jarHeight),
          width: jarWidth,
          height: 10,
        ),
      )
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, centerY - jarHeight / 3),
          width: jarWidth,
          height: 15,
        ),
        Radius.circular(10.r)
      ),
      goldBandPaint,
    );

    // Chinese character (福 - Fortune)
    final textPainter = TextPainter(
      text: TextSpan(
        text: '🧧\n\n2026',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color(0xFFFFD700),
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        centerX - textPainter.width / 2,
        centerY - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant FortuneJarPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
