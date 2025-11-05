import 'package:flutter/material.dart';
import 'dart:math' as math;

class DriftingCar extends StatefulWidget {
  final double size;
  
  const DriftingCar({
    Key? key,
    this.size = 120,
  }) : super(key: key);

  @override
  State<DriftingCar> createState() => _DriftingCarState();
}

class _DriftingCarState extends State<DriftingCar>
    with TickerProviderStateMixin {
  late AnimationController _driftController;
  late AnimationController _wheelController;
  late AnimationController _smokeController;

  @override
  void initState() {
    super.initState();
    _driftController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    
    _wheelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat();
    
    _smokeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _driftController.dispose();
    _wheelController.dispose();
    _smokeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 3,
      height: widget.size * 2,
      child: AnimatedBuilder(
        animation: Listenable.merge([_driftController, _wheelController, _smokeController]),
        builder: (context, child) {
          // Drift animation creates a figure-8 pattern
          final t = _driftController.value;
          final x = math.sin(t * 2 * math.pi) * widget.size;
          final y = math.sin(t * 4 * math.pi) * widget.size * 0.5;
          final rotation = math.cos(t * 2 * math.pi) * 0.4;
          
          return Stack(
            children: [
              // Drift smoke trails
              ..._buildSmokeTrails(x, y),
              
              // Speed lines
              ..._buildSpeedLines(x, y, rotation),
              
              // Car
              Positioned(
                left: widget.size * 1.5 + x - widget.size / 2,
                top: widget.size + y - widget.size / 2,
                child: Transform.rotate(
                  angle: rotation,
                  child: _buildCar(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildSmokeTrails(double carX, double carY) {
    return List.generate(5, (index) {
      final delay = index * 0.2;
      final smokeProgress = (_smokeController.value - delay) % 1.0;
      if (smokeProgress < 0 || smokeProgress > 0.8) return const SizedBox.shrink();
      
      final opacity = 1.0 - smokeProgress;
      final size = 20 + smokeProgress * 40;
      
      return Positioned(
        left: widget.size * 1.5 + carX - size / 2,
        top: widget.size + carY + 20 - size / 2,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFB967FF).withOpacity(opacity * 0.3),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF006E).withOpacity(opacity * 0.2),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
      );
    });
  }

  List<Widget> _buildSpeedLines(double carX, double carY, double rotation) {
    return List.generate(4, (index) {
      final lineProgress = (_driftController.value * 4 + index * 0.25) % 1.0;
      final opacity = 1.0 - lineProgress;
      
      return Positioned(
        left: widget.size * 1.5 + carX - 40 - lineProgress * 60,
        top: widget.size + carY + index * 8,
        child: Container(
          width: 30,
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF00F5FF).withOpacity(opacity * 0.6),
                const Color(0xFF00F5FF).withOpacity(0),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildCar() {
    return SizedBox(
      width: widget.size,
      height: widget.size * 0.6,
      child: CustomPaint(
        painter: _CarPainter(
          wheelRotation: _wheelController.value * 2 * math.pi,
        ),
      ),
    );
  }
}

class _CarPainter extends CustomPainter {
  final double wheelRotation;

  _CarPainter({required this.wheelRotation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Car body shadow
    paint.color = Colors.black.withOpacity(0.3);
    final shadowPath = Path()
      ..moveTo(size.width * 0.2, size.height * 0.9)
      ..lineTo(size.width * 0.8, size.height * 0.9)
      ..lineTo(size.width * 0.85, size.height)
      ..lineTo(size.width * 0.15, size.height)
      ..close();
    canvas.drawPath(shadowPath, paint..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5));

    // Car body (main)
    paint.maskFilter = null;
    paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFFFF006E),
        const Color(0xFFB967FF),
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final bodyPath = Path()
      ..moveTo(size.width * 0.2, size.height * 0.7)
      ..lineTo(size.width * 0.3, size.height * 0.4)
      ..lineTo(size.width * 0.6, size.height * 0.4)
      ..lineTo(size.width * 0.8, size.height * 0.7)
      ..lineTo(size.width * 0.85, size.height * 0.75)
      ..lineTo(size.width * 0.15, size.height * 0.75)
      ..close();

    canvas.drawPath(bodyPath, paint);

    // Windshield
    paint.shader = null;
    paint.color = const Color(0xFF00F5FF).withOpacity(0.6);
    final windshieldPath = Path()
      ..moveTo(size.width * 0.35, size.height * 0.45)
      ..lineTo(size.width * 0.4, size.height * 0.5)
      ..lineTo(size.width * 0.5, size.height * 0.5)
      ..lineTo(size.width * 0.45, size.height * 0.45)
      ..close();
    canvas.drawPath(windshieldPath, paint);

    // Headlights
    paint.color = const Color(0xFFFFED4E);
    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.72),
      4,
      paint..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.72),
      6,
      paint
        ..style = PaintingStyle.fill
        ..color = const Color(0xFFFFED4E).withOpacity(0.4),
    );

    // Taillights
    paint.color = const Color(0xFFFF0000);
    canvas.drawCircle(
      Offset(size.width * 0.18, size.height * 0.72),
      3,
      paint..style = PaintingStyle.fill,
    );

    // Car outline/highlight
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    paint.color = Colors.white.withOpacity(0.5);
    canvas.drawPath(bodyPath, paint);

    // Wheels
    _drawWheel(canvas, Offset(size.width * 0.3, size.height * 0.75), 8);
    _drawWheel(canvas, Offset(size.width * 0.7, size.height * 0.75), 8);

    // Spoiler
    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xFF1A0933);
    final spoilerPath = Path()
      ..moveTo(size.width * 0.15, size.height * 0.55)
      ..lineTo(size.width * 0.12, size.height * 0.5)
      ..lineTo(size.width * 0.25, size.height * 0.5)
      ..lineTo(size.width * 0.22, size.height * 0.55)
      ..close();
    canvas.drawPath(spoilerPath, paint);
  }

  void _drawWheel(Canvas canvas, Offset center, double radius) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Tire
    paint.color = const Color(0xFF1A1A1A);
    canvas.drawCircle(center, radius, paint);

    // Rim
    paint.color = const Color(0xFF666666);
    canvas.drawCircle(center, radius * 0.6, paint);

    // Spokes (rotating)
    paint.color = const Color(0xFF999999);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1.5;
    
    for (int i = 0; i < 5; i++) {
      final angle = (i / 5) * 2 * math.pi + wheelRotation;
      final x1 = center.dx + math.cos(angle) * radius * 0.2;
      final y1 = center.dy + math.sin(angle) * radius * 0.2;
      final x2 = center.dx + math.cos(angle) * radius * 0.55;
      final y2 = center.dy + math.sin(angle) * radius * 0.55;
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }

    // Wheel glow (for drift effect)
    paint.style = PaintingStyle.fill;
    paint.shader = RadialGradient(
      colors: [
        const Color(0xFFFF006E).withOpacity(0.6),
        const Color(0xFFFF006E).withOpacity(0),
      ],
    ).createShader(Rect.fromCircle(center: center, radius: radius * 1.5));
    canvas.drawCircle(center, radius * 1.5, paint);
  }

  @override
  bool shouldRepaint(_CarPainter oldDelegate) => true;
}
