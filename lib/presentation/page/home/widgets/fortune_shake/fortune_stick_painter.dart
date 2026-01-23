import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FortuneStickPainter extends CustomPainter {
  final double slideProgress;
  final bool isRevealed;

  FortuneStickPainter({required this.slideProgress, this.isRevealed = false});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final stickWidth = 15.w;
    final stickHeight = size.height * 0.8;

    // Stick body (bamboo color)
    final stickGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFFD4A574),
        const Color(0xFFC19A6B),
        const Color(0xFFB8936D),
      ],
    );

    final stickPaint =
        Paint()
          ..shader = stickGradient.createShader(
            Rect.fromCenter(
              center: Offset(centerX, size.height / 2),
              width: stickWidth,
              height: stickHeight,
            ),
          )
          ..style = PaintingStyle.fill;

    final stickRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(centerX, size.height / 2),
        width: stickWidth,
        height: stickHeight,
      ),
      Radius.circular(8.r),
    );

    canvas.drawRRect(stickRect, stickPaint);

    // Bamboo segments
    // final segmentPaint = Paint()
    //   ..color = const Color(0xFFFFA500)
    //   ..strokeWidth = 1.5
    //   ..style = PaintingStyle.stroke;

    // for (int i = 1; i < 5; i++) {
    //   final y = size.height * 0.1 + (stickHeight / 5) * i;
    //   canvas.drawLine(
    //     Offset(centerX - stickWidth / 2, y),
    //     Offset(centerX + stickWidth / 2, y),
    //     segmentPaint,
    //   );
    // }

    // Red band at top
    final redBandPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [const Color(0xFFD32F2F), const Color(0xFFB71C1C)],
          ).createShader(
            Rect.fromCenter(
              center: Offset(centerX, size.height * 0.12),
              width: stickWidth,
              height: 20,
            ),
          )
          ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromCenter(
          center: Offset(centerX, size.height * 0.12),
          width: stickWidth,
          height: 20,
        ),
        topLeft: Radius.circular(8.r),
        topRight: Radius.circular(8.r),
        bottomLeft: Radius.zero,
        bottomRight: Radius.zero,
      ),
      redBandPaint,
    );

    // Gold text on red band (if revealed)
    if (isRevealed) {
      final textPainter = TextPainter(
        text: const TextSpan(
          text: '籤',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFD700),
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          centerX - textPainter.width / 2,
          size.height * 0.12 - textPainter.height / 2,
        ),
      );
    }

    // Stick shadow
    final shadowPaint =
        Paint()
          ..color = Colors.black.withOpacity(0.15)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX + 2, size.height / 2 + 2),
          width: stickWidth,
          height: stickHeight,
        ),
        const Radius.circular(6),
      ),
      shadowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant FortuneStickPainter oldDelegate) {
    return oldDelegate.slideProgress != slideProgress ||
        oldDelegate.isRevealed != isRevealed;
  }
}
