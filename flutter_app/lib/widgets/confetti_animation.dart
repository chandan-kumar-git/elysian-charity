import 'package:flutter/material.dart';
import 'dart:math' as math;

class ConfettiParticle {
  Offset position;
  Offset velocity;
  double rotation;
  double rotationSpeed;
  Color color;
  double size;
  double gravity;

  ConfettiParticle({
    required this.position,
    required this.velocity,
    required this.rotation,
    required this.rotationSpeed,
    required this.color,
    required this.size,
    required this.gravity,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;

  ConfettiPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(particle.position.dx, particle.position.dy);
      canvas.rotate(particle.rotation);

      // Draw confetti as small rectangles
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: particle.size,
          height: particle.size * 2,
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) => true;
}

class ConfettiAnimation extends StatefulWidget {
  final VoidCallback? onComplete;

  const ConfettiAnimation({Key? key, this.onComplete}) : super(key: key);

  @override
  State<ConfettiAnimation> createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<ConfettiParticle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _initParticles();
    _controller.forward().then((_) {
      if (widget.onComplete != null) {
        widget.onComplete!();
      }
    });

    _controller.addListener(_updateParticles);
  }

  void _initParticles() {
    final random = math.Random();
    _particles = List.generate(100, (index) {
      final colors = [
        const Color(0xFFFF006E),
        const Color(0xFF00F5FF),
        const Color(0xFFB967FF),
        const Color(0xFF05FFA1),
        const Color(0xFFFDFF00),
      ];

      return ConfettiParticle(
        position: Offset(200, 300),
        velocity: Offset(
          (random.nextDouble() - 0.5) * 400,
          -random.nextDouble() * 300 - 200,
        ),
        rotation: random.nextDouble() * math.pi * 2,
        rotationSpeed: (random.nextDouble() - 0.5) * 0.2,
        color: colors[random.nextInt(colors.length)],
        size: random.nextDouble() * 8 + 4,
        gravity: random.nextDouble() * 300 + 200,
      );
    });
  }

  void _updateParticles() {
    setState(() {
      for (var particle in _particles) {
        // Update velocity (gravity)
        particle.velocity = Offset(
          particle.velocity.dx,
          particle.velocity.dy + particle.gravity * 0.016,
        );

        // Update position
        particle.position = Offset(
          particle.position.dx + particle.velocity.dx * 0.016,
          particle.position.dy + particle.velocity.dy * 0.016,
        );

        // Update rotation
        particle.rotation += particle.rotationSpeed;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        width: 400,
        height: 600,
        child: CustomPaint(
          painter: ConfettiPainter(particles: _particles),
        ),
      ),
    );
  }
}
