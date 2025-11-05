import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

/// Premium Glassmorphism Card with blur effects
class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final List<Color>? gradientColors;
  final double? width;
  final double? height;
  final Border? border;

  const GlassCard({
    Key? key,
    required this.child,
    this.blur = 10,
    this.opacity = 0.1,
    this.padding,
    this.margin,
    this.borderRadius,
    this.gradientColors,
    this.width,
    this.height,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        border: border ?? Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors ?? [
                  Colors.white.withOpacity(opacity),
                  Colors.white.withOpacity(opacity * 0.5),
                ],
              ),
            ),
            padding: padding ?? const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Animated Gradient Background
class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final Duration duration;

  const AnimatedGradientBackground({
    Key? key,
    required this.child,
    this.colors = const [
      Color(0xFF0A0E27),
      Color(0xFF1A1F3A),
      Color(0xFF2A2F4A),
    ],
    this.duration = const Duration(seconds: 5),
  }) : super(key: key);

  @override
  State<AnimatedGradientBackground> createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
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
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.colors,
              stops: [
                0.0,
                _controller.value,
                1.0,
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// Hover Scale Card with smooth animations
class HoverScaleCard extends StatefulWidget {
  final Widget child;
  final double scale;
  final Duration duration;
  final VoidCallback? onTap;

  const HoverScaleCard({
    Key? key,
    required this.child,
    this.scale = 1.05,
    this.duration = const Duration(milliseconds: 200),
    this.onTap,
  }) : super(key: key);

  @override
  State<HoverScaleCard> createState() => _HoverScaleCardState();
}

class _HoverScaleCardState extends State<HoverScaleCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? widget.scale : 1.0,
          duration: widget.duration,
          curve: Curves.easeOutCubic,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Shimmer Loading Effect
class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;

  const ShimmerLoading({
    Key? key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
  }) : super(key: key);

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
      duration: widget.duration,
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
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.baseColor ?? Colors.grey[300]!,
                widget.highlightColor ?? Colors.grey[100]!,
                widget.baseColor ?? Colors.grey[300]!,
              ],
              stops: [
                0.0,
                _controller.value,
                1.0,
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// Neon Glow Button
class NeonButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color glowColor;
  final IconData? icon;

  const NeonButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.glowColor = const Color(0xFF00F5FF),
    this.icon,
  }) : super(key: key);

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              widget.glowColor,
              widget.glowColor.withOpacity(0.6),
            ],
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: widget.glowColor.withOpacity(0.6),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: widget.glowColor.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: Colors.black, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.text,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Animated Counter
class AnimatedCounter extends StatefulWidget {
  final int value;
  final TextStyle? style;
  final Duration duration;
  final String? prefix;
  final String? suffix;

  const AnimatedCounter({
    Key? key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 1000),
    this.prefix,
    this.suffix,
  }) : super(key: key);

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  int _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _updateAnimation(widget.value);
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
      _updateAnimation(widget.value);
    }
  }

  void _updateAnimation(int newValue) {
    _animation = IntTween(
      begin: _previousValue,
      end: newValue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          '${widget.prefix ?? ''}${_animation.value}${widget.suffix ?? ''}',
          style: widget.style,
        );
      },
    );
  }
}

/// Floating Particles Background
class FloatingParticles extends StatefulWidget {
  final int particleCount;
  final Color particleColor;
  final Widget child;

  const FloatingParticles({
    Key? key,
    this.particleCount = 30,
    this.particleColor = const Color(0xFF00F5FF),
    required this.child,
  }) : super(key: key);

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(Particle());
    }
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
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: ParticlePainter(
                particles: _particles,
                animation: _controller.value,
                color: widget.particleColor,
              ),
              size: Size.infinite,
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

class Particle {
  double x = math.Random().nextDouble();
  double y = math.Random().nextDouble();
  double size = math.Random().nextDouble() * 3 + 1;
  double speedX = (math.Random().nextDouble() - 0.5) * 0.01;
  double speedY = (math.Random().nextDouble() - 0.5) * 0.01;
  double opacity = math.Random().nextDouble() * 0.5 + 0.2;
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
    final paint = Paint()..color = color;

    for (var particle in particles) {
      particle.x += particle.speedX;
      particle.y += particle.speedY;

      if (particle.x < 0 || particle.x > 1) particle.speedX *= -1;
      if (particle.y < 0 || particle.y > 1) particle.speedY *= -1;

      paint.color = color.withOpacity(particle.opacity);
      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

/// Premium Skeleton Loader
class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      baseColor: const Color(0xFF2A2F4A),
      highlightColor: const Color(0xFF3A3F5A),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2F4A),
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// Gradient Border Card
class GradientBorderCard extends StatelessWidget {
  final Widget child;
  final List<Color> gradientColors;
  final double borderWidth;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;

  const GradientBorderCard({
    Key? key,
    required this.child,
    this.gradientColors = const [
      Color(0xFF00F5FF),
      Color(0xFFB967FF),
      Color(0xFFFF006E),
    ],
    this.borderWidth = 2,
    this.borderRadius,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        margin: EdgeInsets.all(borderWidth),
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F3A),
          borderRadius: borderRadius ?? BorderRadius.circular(14),
        ),
        child: child,
      ),
    );
  }
}

/// Pulsing Dot Indicator
class PulsingDot extends StatefulWidget {
  final Color color;
  final double size;

  const PulsingDot({
    Key? key,
    this.color = const Color(0xFF00FF00),
    this.size = 12,
  }) : super(key: key);

  @override
  State<PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
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
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color,
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(_controller.value),
                blurRadius: 10 * _controller.value,
                spreadRadius: 5 * _controller.value,
              ),
            ],
          ),
        );
      },
    );
  }
}
