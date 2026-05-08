import 'dart:math' as math;
import 'package:flutter/material.dart';

/// An animated gradient background with a subtle shifting effect.
class AnimatedBackground extends StatefulWidget {
  final Widget? child;
  final List<Color> colors;

  const AnimatedBackground({
    super.key,
    this.child,
    this.colors = const [
      Color(0xFF0A0A0A),
      Color(0xFF111B14),
      Color(0xFF0A0A0A),
    ],
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(
                -1.0 + t * 0.5,
                -1.0 + t * 0.3,
              ),
              end: Alignment(
                1.0 - t * 0.3,
                1.0 - t * 0.5,
              ),
              colors: widget.colors,
              stops: [
                0.0,
                0.3 + 0.2 * math.sin(t * math.pi),
                1.0,
              ],
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
