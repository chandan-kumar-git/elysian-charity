import 'package:flutter/material.dart';
import 'dart:math' as math;

class FloatingParticle {
  Offset position;
  double size;
  Color color;
  double speed;
  double angle;
  double opacity;

  FloatingParticle({
    required this.position,
    required this.size,
    required this.color,
    required this.speed,
    required this.angle,
    required this.opacity,
  });
}

class ParticlesPainter extends CustomPainter {
  final List<FloatingParticle> particles;
  final double animationValue;

  ParticlesPainter({
    required this.particles,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      // Update particle position
      particle.position = Offset(
        particle.position.dx + math.cos(particle.angle) * particle.speed,
        particle.position.dy + math.sin(particle.angle) * particle.speed,
      );

      // Wrap around edges
      if (particle.position.dx < 0) particle.position = Offset(size.width, particle.position.dy);
      if (particle.position.dx > size.width) particle.position = Offset(0, particle.position.dy);
      if (particle.position.dy < 0) particle.position = Offset(particle.position.dx, size.height);
      if (particle.position.dy > size.height) particle.position = Offset(particle.position.dx, 0);

      // Draw particle with glow effect
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(particle.position, particle.size, paint);

      // Draw inner bright core
      final corePaint = Paint()
        ..color = Colors.white.withOpacity(particle.opacity * 0.8);
      canvas.drawCircle(particle.position, particle.size * 0.4, corePaint);
    }
  }

  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) => true;
}

class ParticleBackground extends StatefulWidget {
  final Widget child;

  const ParticleBackground({Key? key, required this.child}) : super(key: key);

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<FloatingParticle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    _particles = List.generate(30, (index) {
      final random = math.Random(index);
      return FloatingParticle(
        position: Offset(
          random.nextDouble() * 400,
          random.nextDouble() * 600,
        ),
        size: random.nextDouble() * 3 + 1,
        color: _getRandomColor(random),
        speed: random.nextDouble() * 0.5 + 0.2,
        angle: random.nextDouble() * math.pi * 2,
        opacity: random.nextDouble() * 0.6 + 0.2,
      );
    });
  }

  Color _getRandomColor(math.Random random) {
    final colors = [
      const Color(0xFFFF006E), // Pink
      const Color(0xFF00F5FF), // Cyan
      const Color(0xFFB967FF), // Purple
      const Color(0xFF05FFA1), // Green
    ];
    return colors[random.nextInt(colors.length)];
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
          builder: (context, _) {
            return CustomPaint(
              size: const Size(400, 600),
              painter: ParticlesPainter(
                particles: _particles,
                animationValue: _controller.value,
              ),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}
