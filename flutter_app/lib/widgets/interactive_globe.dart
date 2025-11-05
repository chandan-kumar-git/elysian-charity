import 'package:flutter/material.dart';
import 'dart:math' as math;

class InteractiveGlobe extends StatefulWidget {
  const InteractiveGlobe({Key? key}) : super(key: key);

  @override
  State<InteractiveGlobe> createState() => _InteractiveGlobeState();
}

class _InteractiveGlobeState extends State<InteractiveGlobe>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<DonationMarker> _markers = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Add some random markers
    final random = math.Random();
    for (int i = 0; i < 20; i++) {
      _markers.add(DonationMarker(
        lat: random.nextDouble() * 180 - 90,
        lng: random.nextDouble() * 360 - 180,
        amount: random.nextInt(1000) + 100,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: GlobePainter(
              rotation: _controller.value * 2 * math.pi,
              markers: _markers,
            ),
            size: const Size(400, 400),
          );
        },
      ),
    );
  }
}

class DonationMarker {
  final double lat;
  final double lng;
  final int amount;

  DonationMarker({required this.lat, required this.lng, required this.amount});
}

class GlobePainter extends CustomPainter {
  final double rotation;
  final List<DonationMarker> markers;

  GlobePainter({required this.rotation, required this.markers});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // Draw globe
    final globePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF4A90E2),
          const Color(0xFF2E5C8A),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, globePaint);

    // Draw latitude lines
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = -2; i <= 2; i++) {
      final y = center.dy + (i * radius / 3);
      final width = math.sqrt(radius * radius - (i * radius / 3) * (i * radius / 3));
      canvas.drawOval(
        Rect.fromCenter(center: Offset(center.dx, y), width: width * 2, height: 20),
        linePaint,
      );
    }

    // Draw markers
    for (var marker in markers) {
      final markerAngle = (marker.lng * math.pi / 180) + rotation;
      final x = center.dx + radius * 0.8 * math.cos(markerAngle);
      final y = center.dy + radius * 0.8 * math.sin(markerAngle) * 0.5;

      // Only draw markers on visible side
      if (math.cos(markerAngle) > 0) {
        final markerPaint = Paint()
          ..color = Colors.red
          ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset(x, y), 5, markerPaint);

        // Pulsing effect
        final pulseRadius = 5 + math.sin(rotation * 10) * 3;
        final pulsePaint = Paint()
          ..color = Colors.red.withOpacity(0.3)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(x, y), pulseRadius, pulsePaint);
      }
    }

    // Add glow
    final glowPaint = Paint()
      ..color = Colors.cyan.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(center, radius, glowPaint);
  }

  @override
  bool shouldRepaint(GlobePainter oldDelegate) => true;
}
