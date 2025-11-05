import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_animate/flutter_animate.dart';

class RotatingEarthGlobe extends StatefulWidget {
  final double size;
  
  const RotatingEarthGlobe({
    Key? key,
    this.size = 200,
  }) : super(key: key);

  @override
  State<RotatingEarthGlobe> createState() => _RotatingEarthGlobeState();
}

class _RotatingEarthGlobeState extends State<RotatingEarthGlobe>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  
  final List<DonationPoint> _donationPoints = [
    DonationPoint(lat: 40.7128, lng: -74.0060, label: 'NYC', amount: '\$5.2K'),
    DonationPoint(lat: 51.5074, lng: -0.1278, label: 'London', amount: '\$8.1K'),
    DonationPoint(lat: 35.6762, lng: 139.6503, label: 'Tokyo', amount: '\$12.3K'),
    DonationPoint(lat: -33.8688, lng: 151.2093, label: 'Sydney', amount: '\$3.7K'),
    DonationPoint(lat: 19.4326, lng: -99.1332, label: 'Mexico', amount: '\$2.9K'),
    DonationPoint(lat: 55.7558, lng: 37.6173, label: 'Moscow', amount: '\$6.5K'),
  ];

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow effect
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: widget.size + 40,
                height: widget.size + 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00F5FF).withOpacity(0.3 * _pulseController.value),
                      blurRadius: 50,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              );
            },
          ),
          
          // Main globe
          AnimatedBuilder(
            animation: Listenable.merge([_rotationController, _pulseController]),
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(0.3)
                  ..rotateY(_rotationController.value * 2 * math.pi),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF1E3A8A),
                        const Color(0xFF0EA5E9),
                        const Color(0xFF0C4A6E),
                      ],
                      stops: const [0.3, 0.6, 1.0],
                    ),
                  ),
                  child: CustomPaint(
                    painter: _GlobePainter(
                      rotation: _rotationController.value,
                      donationPoints: _donationPoints,
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Donation points overlay
          AnimatedBuilder(
            animation: Listenable.merge([_rotationController, _pulseController]),
            builder: (context, child) {
              return SizedBox(
                width: widget.size,
                height: widget.size,
                child: Stack(
                  children: _donationPoints.map((point) {
                    final angle = (point.lng / 180 * math.pi) + 
                        (_rotationController.value * 2 * math.pi);
                    final visible = math.cos(angle) > 0;
                    
                    if (!visible) return const SizedBox.shrink();
                    
                    final x = math.cos(angle) * widget.size * 0.35;
                    final y = math.sin(point.lat / 180 * math.pi) * widget.size * 0.35;
                    
                    return Positioned(
                      left: widget.size / 2 + x - 15,
                      top: widget.size / 2 - y - 15,
                      child: _DonationMarker(
                        point: point,
                        pulse: _pulseController.value,
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          
          // Center label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF00F5FF).withOpacity(0.5),
                width: 2,
              ),
            ),
            child: const Text(
              '🌍 LIVE DONATIONS',
              style: TextStyle(
                color: Color(0xFF00F5FF),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DonationPoint {
  final double lat;
  final double lng;
  final String label;
  final String amount;

  DonationPoint({
    required this.lat,
    required this.lng,
    required this.label,
    required this.amount,
  });
}

class _DonationMarker extends StatelessWidget {
  final DonationPoint point;
  final double pulse;

  const _DonationMarker({
    required this.point,
    required this.pulse,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF00F5FF).withOpacity(0.3),
            border: Border.all(
              color: const Color(0xFF00F5FF),
              width: 2,
            ),
          ),
          child: Center(
            child: Container(
              width: 10 + pulse * 5,
              height: 10 + pulse * 5,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF00F5FF),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF00F5FF),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GlobePainter extends CustomPainter {
  final double rotation;
  final List<DonationPoint> donationPoints;

  _GlobePainter({
    required this.rotation,
    required this.donationPoints,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw latitude lines
    for (int i = -2; i <= 2; i++) {
      final y = center.dy + (i * radius / 3);
      canvas.drawArc(
        Rect.fromCircle(center: Offset(center.dx, y), radius: radius * 0.8),
        0,
        math.pi * 2,
        false,
        paint,
      );
    }

    // Draw longitude lines
    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * math.pi * 2 + (rotation * 2 * math.pi);
      final x = math.cos(angle) * radius * 0.8;
      
      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(center.dx + x * 0.3, center.dy),
          radius: radius * 0.8,
        ),
        -math.pi / 2,
        math.pi,
        false,
        paint,
      );
    }

    // Draw continents (simplified)
    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xFF10B981).withOpacity(0.3);
    
    // Simple continent shapes
    final path = Path();
    path.addOval(Rect.fromCircle(
      center: Offset(center.dx - 20, center.dy - 30),
      radius: 25,
    ));
    path.addOval(Rect.fromCircle(
      center: Offset(center.dx + 30, center.dy + 10),
      radius: 20,
    ));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_GlobePainter oldDelegate) => true;
}
