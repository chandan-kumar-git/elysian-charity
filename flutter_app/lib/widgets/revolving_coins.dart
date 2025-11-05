import 'package:flutter/material.dart';
import 'dart:math' as math;

class RevolvingCoins extends StatefulWidget {
  final double radius;
  final int coinCount;
  
  const RevolvingCoins({
    Key? key,
    this.radius = 150,
    this.coinCount = 8,
  }) : super(key: key);

  @override
  State<RevolvingCoins> createState() => _RevolvingCoinsState();
}

class _RevolvingCoinsState extends State<RevolvingCoins>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late AnimationController _sparkleController;
  final List<List<Offset>> _trails = [];

  @override
  void initState() {
    super.initState();
    
    // Initialize trails
    for (int i = 0; i < widget.coinCount; i++) {
      _trails.add([]);
    }
    
    // Main rotation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    // Pulse/size animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    // Sparkle animation
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.radius * 2.5,
      height: widget.radius * 2.5,
      child: AnimatedBuilder(
        animation: Listenable.merge([_controller, _pulseController, _sparkleController]),
        builder: (context, child) {
          return CustomPaint(
            painter: _TrailPainter(_trails),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Sparkle particles
                ..._buildSparkles(),
                // Main coins
                ...List.generate(widget.coinCount, (index) {
                  final baseAngle = (index / widget.coinCount) * 2 * math.pi;
                  final angle = baseAngle + (_controller.value * 2 * math.pi);
                  
                  // Multiple orbit rings for depth
                  final ringRadius = widget.radius * (1 + (index % 2) * 0.2);
                  final x = math.cos(angle) * ringRadius;
                  final y = math.sin(angle) * ringRadius;
                  
                  // Update trail
                  if (_trails[index].length > 8) {
                    _trails[index].removeAt(0);
                  }
                  _trails[index].add(Offset(x, y));
                  
                  // 3D flip animation
                  final flipAngle = _controller.value * 4 * math.pi + baseAngle;
                  
                  // Pulsing size
                  final pulseScale = 1.0 + (_pulseController.value * 0.2);
                  
                  // Color shift based on position
                  final colorShift = (math.sin(angle + _controller.value * math.pi) + 1) / 2;
                  
                  return Transform.translate(
                    offset: Offset(x, y),
                    child: Transform.scale(
                      scale: pulseScale,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(flipAngle)
                          ..rotateX(math.sin(flipAngle) * 0.3),
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              center: Alignment(-0.3, -0.3),
                              radius: 0.8,
                              colors: [
                                Color.lerp(
                                  const Color(0xFFFFED4E),
                                  const Color(0xFFFFA500),
                                  colorShift,
                                )!,
                                const Color(0xFFFFD700),
                                const Color(0xFFB8860B),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFD700).withOpacity(0.8),
                                blurRadius: 20,
                                spreadRadius: 3,
                              ),
                              BoxShadow(
                                color: const Color(0xFFFFA500).withOpacity(0.4),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                            border: Border.all(
                              color: const Color(0xFFFFED4E).withOpacity(0.6),
                              width: 2,
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Shimmer effect
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white.withOpacity(
                                          (math.sin(_controller.value * 4 * math.pi + baseAngle) + 1) / 4,
                                        ),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Bitcoin symbol with rotation
                              Center(
                                child: Transform.rotate(
                                  angle: _controller.value * 2 * math.pi,
                                  child: Text(
                                    '₿',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.7),
                                          blurRadius: 3,
                                        ),
                                        Shadow(
                                          color: const Color(0xFFFFD700).withOpacity(0.5),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
  
  List<Widget> _buildSparkles() {
    final sparkles = <Widget>[];
    final sparkleCount = 12;
    
    for (int i = 0; i < sparkleCount; i++) {
      final angle = (i / sparkleCount) * 2 * math.pi + (_sparkleController.value * 2 * math.pi);
      final distance = widget.radius * (0.8 + (_sparkleController.value * 0.4));
      final x = math.cos(angle) * distance;
      final y = math.sin(angle) * distance;
      
      final opacity = (math.sin(_sparkleController.value * math.pi * 2 + i) + 1) / 2;
      
      sparkles.add(
        Transform.translate(
          offset: Offset(x, y),
          child: Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFED4E).withOpacity(opacity * 0.6),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD700).withOpacity(opacity * 0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return sparkles;
  }
}

// Custom painter for glowing trails
class _TrailPainter extends CustomPainter {
  final List<List<Offset>> trails;
  
  _TrailPainter(this.trails);
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    for (var trail in trails) {
      for (int i = 0; i < trail.length - 1; i++) {
        final opacity = (i / trail.length) * 0.3;
        final paint = Paint()
          ..color = const Color(0xFFFFD700).withOpacity(opacity)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;
        
        canvas.drawLine(
          center + trail[i],
          center + trail[i + 1],
          paint,
        );
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
