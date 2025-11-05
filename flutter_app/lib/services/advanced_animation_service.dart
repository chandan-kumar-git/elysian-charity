import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_animate/flutter_animate.dart';

/// Advanced animation service with real-time effects
class AdvancedAnimationService {
  // Parallax effect
  static Widget parallaxScroll({
    required Widget child,
    required ScrollController scrollController,
    double speed = 0.5,
  }) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, scrollController.offset * speed),
          child: child,
        );
      },
      child: child,
    );
  }

  // 3D card flip animation
  static Widget flip3D({
    required Widget front,
    required Widget back,
    required bool showFront,
    Duration duration = const Duration(milliseconds: 800),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: showFront ? 0.0 : math.pi),
      duration: duration,
      builder: (context, value, child) {
        final isFrontVisible = value <= math.pi / 2;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(value),
          child: isFrontVisible ? front : Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..rotateY(math.pi),
            child: back,
          ),
        );
      },
    );
  }

  // Shimmer loading effect
  static Widget shimmer({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return child
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: duration, color: Colors.white.withOpacity(0.3));
  }

  // Floating particles background
  static Widget floatingParticles({
    required Widget child,
    int particleCount = 20,
    Color particleColor = Colors.white,
  }) {
    return Stack(
      children: [
        ...List.generate(particleCount, (index) {
          return Positioned(
            left: (index * 50.0) % 400,
            top: (index * 37.0) % 800,
            child: _FloatingParticle(
              color: particleColor,
              delay: index * 100,
            ),
          );
        }),
        child,
      ],
    );
  }

  // Pulse animation
  static Widget pulse({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1000),
    double minScale = 0.95,
    double maxScale = 1.05,
  }) {
    return child
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scale(
          duration: duration,
          begin: Offset(minScale, minScale),
          end: Offset(maxScale, maxScale),
        );
  }

  // Bounce animation
  static Widget bounce({
    required Widget child,
    Duration duration = const Duration(milliseconds: 600),
  }) {
    return child
        .animate()
        .scale(
          duration: duration,
          curve: Curves.elasticOut,
        );
  }

  // Confetti explosion
  static void showConfetti(BuildContext context) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => _ConfettiOverlay(),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 3), () => entry.remove());
  }

  // Ripple effect
  static Widget ripple({
    required Widget child,
    Color color = Colors.white,
  }) {
    return child
        .animate(onPlay: (controller) => controller.repeat())
        .custom(
          duration: 1500.ms,
          begin: 0,
          end: 1,
          builder: (context, value, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100 * value,
                  height: 100 * value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color.withOpacity(1 - value),
                      width: 2,
                    ),
                  ),
                ),
                child!,
              ],
            );
          },
        );
  }

  // Typing indicator animation
  static Widget typingIndicator({
    Color color = Colors.grey,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TypingDot(color: color, delay: 0),
        const SizedBox(width: 4),
        _TypingDot(color: color, delay: 200),
        const SizedBox(width: 4),
        _TypingDot(color: color, delay: 400),
      ],
    );
  }

  // Number count-up animation
  static Widget countUp({
    required double endValue,
    Duration duration = const Duration(milliseconds: 1500),
    TextStyle? style,
    String prefix = '',
    String suffix = '',
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: endValue),
      duration: duration,
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Text(
          '$prefix${value.toStringAsFixed(2)}$suffix',
          style: style,
        );
      },
    );
  }

  // Skeleton loader
  static Widget skeleton({
    required double width,
    required double height,
    BorderRadius? borderRadius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    ).animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 1000.ms, color: Colors.white.withOpacity(0.5));
  }

  // Wave animation
  static Widget wave({
    required Widget child,
    Duration duration = const Duration(milliseconds: 2000),
  }) {
    return child
        .animate(onPlay: (controller) => controller.repeat())
        .custom(
          duration: duration,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, math.sin(value * 2 * math.pi) * 5),
              child: child,
            );
          },
        );
  }
}

// Floating particle widget
class _FloatingParticle extends StatelessWidget {
  final Color color;
  final int delay;

  const _FloatingParticle({required this.color, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: color.withOpacity(0.6),
        shape: BoxShape.circle,
      ),
    )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .moveY(
          begin: 0,
          end: -100,
          duration: (3000 + delay).ms,
          curve: Curves.easeInOut,
        )
        .fadeIn(duration: 500.ms)
        .fadeOut(duration: 500.ms);
  }
}

// Typing dot widget
class _TypingDot extends StatelessWidget {
  final Color color;
  final int delay;

  const _TypingDot({required this.color, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .moveY(begin: 0, end: -8, duration: 600.ms, delay: delay.ms)
        .then()
        .moveY(begin: -8, end: 0, duration: 600.ms);
  }
}

// Confetti overlay
class _ConfettiOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: List.generate(50, (index) {
          return Positioned(
            left: (index * 20.0) % MediaQuery.of(context).size.width,
            top: -20,
            child: _ConfettiPiece(
              color: [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.purple][index % 5],
              delay: index * 50,
            ),
          );
        }),
      ),
    );
  }
}

// Confetti piece
class _ConfettiPiece extends StatelessWidget {
  final Color color;
  final int delay;

  const _ConfettiPiece({required this.color, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    )
        .animate()
        .moveY(
          begin: 0,
          end: MediaQuery.of(context).size.height,
          duration: (2000 + delay).ms,
          curve: Curves.easeIn,
        )
        .rotate(begin: 0, end: 4, duration: (2000 + delay).ms)
        .fadeOut(begin: 0.5, duration: 1000.ms);
  }
}
