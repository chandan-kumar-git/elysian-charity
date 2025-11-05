import 'package:flutter/material.dart';
import 'dart:math' as math;

class RevolvingDiamond extends StatefulWidget {
  final double size;
  
  const RevolvingDiamond({
    Key? key,
    this.size = 150,
  }) : super(key: key);

  @override
  State<RevolvingDiamond> createState() => _RevolvingDiamondState();
}

class _RevolvingDiamondState extends State<RevolvingDiamond>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _shineController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    
    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _shineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([_rotationController, _shineController]),
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow
              Container(
                width: widget.size + 60,
                height: widget.size + 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00F5FF).withOpacity(0.3),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                    BoxShadow(
                      color: const Color(0xFFFF006E).withOpacity(0.2),
                      blurRadius: 60,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
              
              // Main diamond
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(_rotationController.value * 2 * math.pi)
                  ..rotateX(math.sin(_rotationController.value * 2 * math.pi) * 0.3)
                  ..rotateZ(_rotationController.value * math.pi),
                child: CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _DiamondPainter(
                    shineProgress: _shineController.value,
                  ),
                ),
              ),
              
              // Sparkles
              ..._buildSparkles(),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildSparkles() {
    return List.generate(6, (index) {
      final angle = (index / 6) * 2 * math.pi + (_shineController.value * 2 * math.pi);
      final distance = widget.size * 0.6;
      final x = math.cos(angle) * distance;
      final y = math.sin(angle) * distance;
      final opacity = (math.sin(_shineController.value * 2 * math.pi + index) + 1) / 2;
      
      return Transform.translate(
        offset: Offset(x, y),
        child: Icon(
          Icons.auto_awesome,
          color: Colors.white.withOpacity(opacity * 0.8),
          size: 20,
          shadows: [
            Shadow(
              color: const Color(0xFF00F5FF).withOpacity(opacity),
              blurRadius: 10,
            ),
          ],
        ),
      );
    });
  }
}

class _DiamondPainter extends CustomPainter {
  final double shineProgress;

  _DiamondPainter({required this.shineProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;

    // Diamond shape points
    final topPoint = Offset(center.dx, center.dy - size.height * 0.35);
    final bottomPoint = Offset(center.dx, center.dy + size.height * 0.35);
    final leftPoint = Offset(center.dx - size.width * 0.25, center.dy);
    final rightPoint = Offset(center.dx + size.width * 0.25, center.dy);
    final topLeftPoint = Offset(center.dx - size.width * 0.15, center.dy - size.height * 0.15);
    final topRightPoint = Offset(center.dx + size.width * 0.15, center.dy - size.height * 0.15);
    final bottomLeftPoint = Offset(center.dx - size.width * 0.15, center.dy + size.height * 0.15);
    final bottomRightPoint = Offset(center.dx + size.width * 0.15, center.dy + size.height * 0.15);

    // Draw facets with gradients
    final facets = [
      // Top facets
      [topPoint, topRightPoint, rightPoint, const Color(0xFF00F5FF), const Color(0xFF0EA5E9)],
      [topPoint, rightPoint, topLeftPoint, const Color(0xFF06B6D4), const Color(0xFF00F5FF)],
      [topPoint, topLeftPoint, leftPoint, const Color(0xFF0EA5E9), const Color(0xFF06B6D4)],
      [topPoint, leftPoint, topRightPoint, const Color(0xFF00F5FF), const Color(0xFF0EA5E9)],
      
      // Bottom facets
      [bottomPoint, rightPoint, bottomRightPoint, const Color(0xFFFF006E), const Color(0xFFB967FF)],
      [bottomPoint, bottomRightPoint, bottomLeftPoint, const Color(0xFFB967FF), const Color(0xFFFF006E)],
      [bottomPoint, bottomLeftPoint, leftPoint, const Color(0xFF9333EA), const Color(0xFFB967FF)],
      [bottomPoint, leftPoint, rightPoint, const Color(0xFFFF006E), const Color(0xFF9333EA)],
      
      // Middle band
      [leftPoint, topLeftPoint, bottomLeftPoint, const Color(0xFF8B5CF6), const Color(0xFF06B6D4)],
      [rightPoint, bottomRightPoint, topRightPoint, const Color(0xFF06B6D4), const Color(0xFF8B5CF6)],
    ];

    for (var facet in facets) {
      final path = Path()
        ..moveTo((facet[0] as Offset).dx, (facet[0] as Offset).dy)
        ..lineTo((facet[1] as Offset).dx, (facet[1] as Offset).dy)
        ..lineTo((facet[2] as Offset).dx, (facet[2] as Offset).dy)
        ..close();

      paint.shader = LinearGradient(
        colors: [facet[3] as Color, facet[4] as Color],
      ).createShader(path.getBounds());

      canvas.drawPath(path, paint);

      // Draw facet edges
      paint.shader = null;
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 1.5;
      paint.color = Colors.white.withOpacity(0.6);
      canvas.drawPath(path, paint);
      paint.style = PaintingStyle.fill;
    }

    // Shine effect
    if (shineProgress > 0.3 && shineProgress < 0.7) {
      final shinePaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0),
            Colors.white.withOpacity(0.8),
            Colors.white.withOpacity(0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..blendMode = BlendMode.plus;

      final shinePath = Path()
        ..moveTo(size.width * shineProgress, 0)
        ..lineTo(size.width * shineProgress + 20, 0)
        ..lineTo(size.width * shineProgress - 30, size.height)
        ..lineTo(size.width * shineProgress - 50, size.height)
        ..close();

      canvas.drawPath(shinePath, shinePaint);
    }

    // Center highlight
    final highlightPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.9),
          Colors.white.withOpacity(0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: 15));

    canvas.drawCircle(center, 15, highlightPaint);
  }

  @override
  bool shouldRepaint(_DiamondPainter oldDelegate) => true;
}
