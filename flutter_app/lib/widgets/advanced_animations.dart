import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Advanced animated background with particle effects
class AnimatedParticleBackground extends StatefulWidget {
  final Widget child;
  final int particleCount;
  final Color particleColor;

  const AnimatedParticleBackground({
    Key? key,
    required this.child,
    this.particleCount = 100,
    this.particleColor = const Color(0xFF00F5FF),
  }) : super(key: key);

  @override
  State<AnimatedParticleBackground> createState() => _AnimatedParticleBackgroundState();
}

class _AnimatedParticleBackgroundState extends State<AnimatedParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _particles = List.generate(
      widget.particleCount,
      (index) => Particle(
        x: math.Random().nextDouble(),
        y: math.Random().nextDouble(),
        size: math.Random().nextDouble() * 3 + 1,
        speed: math.Random().nextDouble() * 0.5 + 0.1,
        opacity: math.Random().nextDouble() * 0.5 + 0.2,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Animated particle layer
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: ParticlePainter(
                particles: _particles,
                animation: _controller.value,
                color: widget.particleColor,
              ),
              child: Container(),
            );
          },
        ),
        // Content on top
        widget.child,
      ],
    );
  }
}

class Particle {
  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animation;
  final Color color;

  ParticlePainter({
    required this.particles,
    required this.animation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      // Update particle position
      particle.y = (particle.y + particle.speed * 0.001) % 1.0;

      final paint = Paint()
        ..color = color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;

      // Draw particle
      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        paint,
      );

      // Draw connecting lines
      for (var other in particles) {
        final distance = math.sqrt(
          math.pow((particle.x - other.x) * size.width, 2) +
              math.pow((particle.y - other.y) * size.height, 2),
        );

        if (distance < 100) {
          final linePaint = Paint()
            ..color = color.withOpacity(0.1 * (1 - distance / 100))
            ..strokeWidth = 0.5;

          canvas.drawLine(
            Offset(particle.x * size.width, particle.y * size.height),
            Offset(other.x * size.width, other.y * size.height),
            linePaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

/// Floating action button with pulse animation
class PulsingFloatingButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color color;

  const PulsingFloatingButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.color = const Color(0xFF00F5FF),
  }) : super(key: key);

  @override
  State<PulsingFloatingButton> createState() => _PulsingFloatingButtonState();
}

class _PulsingFloatingButtonState extends State<PulsingFloatingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.5, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
        return Stack(
          alignment: Alignment.center,
          children: [
            // Pulsing ring
            Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.color.withOpacity(_opacityAnimation.value),
                    width: 3,
                  ),
                ),
              ),
            ),
            // Button
            FloatingActionButton.extended(
              onPressed: widget.onPressed,
              backgroundColor: widget.color,
              icon: Icon(widget.icon, color: Colors.black),
              label: Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              elevation: 8,
            ),
          ],
        );
      },
    );
  }
}

/// Animated gradient text
class GradientAnimatedText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final List<Color> colors;

  const GradientAnimatedText({
    Key? key,
    required this.text,
    this.style,
    this.colors = const [
      Color(0xFF00F5FF),
      Color(0xFFB967FF),
      Color(0xFF00FF00),
    ],
  }) : super(key: key);

  @override
  State<GradientAnimatedText> createState() => _GradientAnimatedTextState();
}

class _GradientAnimatedTextState extends State<GradientAnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
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
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: widget.colors,
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            style: widget.style?.copyWith(color: Colors.white) ??
                const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
          ),
        );
      },
    );
  }
}

/// Animated stat card with count-up animation
class AnimatedStatCard extends StatefulWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final String prefix;
  final String suffix;

  const AnimatedStatCard({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.prefix = '',
    this.suffix = '',
  }) : super(key: key);

  @override
  State<AnimatedStatCard> createState() => _AnimatedStatCardState();
}

class _AnimatedStatCardState extends State<AnimatedStatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _countAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _countAnimation = IntTween(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.color.withOpacity(0.2),
            widget.color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.color.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.color.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, color: widget.color, size: 40),
          const SizedBox(height: 12),
          AnimatedBuilder(
            animation: _countAnimation,
            builder: (context, child) {
              return Text(
                '${widget.prefix}${_formatNumber(_countAnimation.value)}${widget.suffix}',
                style: TextStyle(
                  color: widget.color,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            widget.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

/// Shimmer loading effect
class ShimmerLoading extends StatefulWidget {
  final Widget child;

  const ShimmerLoading({Key? key, required this.child}) : super(key: key);

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
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
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: const [
                Color(0xFF1a1a2e),
                Color(0xFF00F5FF),
                Color(0xFF1a1a2e),
              ],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// 3D Card flip animation
class FlipCard extends StatefulWidget {
  final Widget front;
  final Widget back;

  const FlipCard({
    Key? key,
    required this.front,
    required this.back,
  }) : super(key: key);

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_showFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _showFront = !_showFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * math.pi;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle);

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: angle < math.pi / 2 ? widget.front : Transform(
              transform: Matrix4.identity()..rotateY(math.pi),
              alignment: Alignment.center,
              child: widget.back,
            ),
          );
        },
      ),
    );
  }
}
