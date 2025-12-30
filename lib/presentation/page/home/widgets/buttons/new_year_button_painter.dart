import 'package:flutter/material.dart';
import 'dart:math' as math;

class NewYearButtonPainter extends CustomPainter {
  final bool isDarkMode;
  final Animation<double>? animation;

  NewYearButtonPainter({required this.isDarkMode, this.animation})
    : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    if (animation != null) {
      _drawFireworks(canvas, size);
    }
  }

  // Animated fireworks - Multiple bursts
  void _drawFireworks(Canvas canvas, Size size) {
    final progress = animation?.value ?? 0.0;

    // 5 firework positions for better coverage
    final positions = [
      Offset(size.width * 0.2, size.height * 0.25), // Top left
      Offset(size.width * 0.5, size.height * 0.2), // Top center
      Offset(size.width * 0.8, size.height * 0.3), // Top right
      Offset(size.width * 0.35, size.height * 0.7), // Bottom left
      Offset(size.width * 0.7, size.height * 0.75), // Bottom right
    ];

    for (int i = 0; i < positions.length; i++) {
      final burstProgress = ((progress + i * 0.2) % 1.0);

      if (burstProgress < 0.7) {
        _drawFireworkBurst(canvas, positions[i], burstProgress, i);
      }
    }
  }

  void _drawFireworkBurst(
    Canvas canvas,
    Offset center,
    double progress,
    int index,
  ) {
    final colorSets = [
      [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)], // Red-Orange
      [const Color(0xFF4ECDC4), const Color(0xFF95E1D3)], // Cyan-Mint
      [const Color(0xFFFFE66D), const Color(0xFFFFD93D)], // Yellow-Gold
      [const Color(0xFFF38181), const Color(0xFFAA96DA)], // Pink-Purple
      [const Color(0xFF6C5CE7), const Color(0xFFA29BFE)], // Purple-Lavender
    ];

    final colors = colorSets[index % colorSets.length];
    final particleCount = 16;
    final maxRadius = 30.0;
    final radius = maxRadius * progress;
    final opacity = (1.0 - progress).clamp(0.0, 1.0);

    for (int i = 0; i < particleCount; i++) {
      final angle = (i / particleCount) * math.pi * 2;
      final color = colors[i % colors.length];

      final x = center.dx + math.cos(angle) * radius;
      final y = center.dy + math.sin(angle) * radius;

      // Main particle
      final particleSize = 2.5 * (1.0 - progress * 0.5);
      final particlePaint =
          Paint()
            ..color = color.withValues(alpha: opacity * 0.9)
            ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), particleSize, particlePaint);

      // Glow effect
      final glowPaint =
          Paint()
            ..color = color.withValues(alpha: opacity * 0.4)
            ..style = PaintingStyle.fill
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawCircle(Offset(x, y), particleSize * 1.5, glowPaint);

      // Trail
      final trailLength = 10.0 * progress;
      final trailPaint =
          Paint()
            ..shader = LinearGradient(
              colors: [
                color.withValues(alpha: opacity * 0.6),
                color.withValues(alpha: 0.0),
              ],
            ).createShader(
              Rect.fromPoints(
                Offset(x, y),
                Offset(
                  center.dx + math.cos(angle) * (radius - trailLength),
                  center.dy + math.sin(angle) * (radius - trailLength),
                ),
              ),
            )
            ..strokeWidth = 2.0
            ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(x, y),
        Offset(
          center.dx + math.cos(angle) * (radius - trailLength),
          center.dy + math.sin(angle) * (radius - trailLength),
        ),
        trailPaint,
      );

      // Secondary sparkles at particle tip
      if (progress > 0.3 && i % 2 == 0) {
        final sparkleSize = 1.5 * opacity;
        final sparklePaint =
            Paint()
              ..color = const Color(0xFFFFFFFF).withValues(alpha: opacity * 0.8)
              ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset(x, y), sparkleSize, sparklePaint);
      }
    }

    // Center flash at the beginning
    if (progress < 0.15) {
      final flashProgress = progress / 0.15;
      final flashSize = 8.0 * (1.0 - flashProgress);
      final flashPaint =
          Paint()
            ..color = const Color(
              0xFFFFFFFF,
            ).withValues(alpha: (1.0 - flashProgress) * 0.8)
            ..style = PaintingStyle.fill
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

      canvas.drawCircle(center, flashSize, flashPaint);
    }
  }

  @override
  bool shouldRepaint(NewYearButtonPainter oldDelegate) {
    return oldDelegate.isDarkMode != isDarkMode ||
        oldDelegate.animation != animation;
  }
}
