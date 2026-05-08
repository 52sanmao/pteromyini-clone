import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A circular loading animation with rotating dots.
class LoadingAnimation extends StatefulWidget {
  final double size;
  final Color color;

  const LoadingAnimation({
    super.key,
    this.size = 48.0,
    this.color = const Color(0xFF1EC878),
  });

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _DotRingPainter(
              progress: _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _DotRingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _DotRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const dotCount = 8;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    for (int i = 0; i < dotCount; i++) {
      final angle = (2 * math.pi * i) / dotCount;
      final normalizedIndex = ((i + (progress * dotCount).round()) % dotCount);
      final opacity = (1.0 - (normalizedIndex / dotCount)).clamp(0.15, 1.0);
      final dotRadius = size.width * 0.06 * (0.5 + 0.5 * opacity);

      final dotCenter = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(dotCenter, dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DotRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
