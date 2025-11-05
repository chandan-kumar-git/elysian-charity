import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedBitcoinCoin extends StatefulWidget {
  final double size;
  
  const AnimatedBitcoinCoin({Key? key, this.size = 300}) : super(key: key);

  @override
  State<AnimatedBitcoinCoin> createState() => _AnimatedBitcoinCoinState();
}

class _AnimatedBitcoinCoinState extends State<AnimatedBitcoinCoin>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _floatController;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _floatController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _rotationController,
        _floatController,
        _glowController,
      ]),
      builder: (context, child) {
        final rotation = _rotationController.value * 2 * math.pi;
        final floatOffset = math.sin(_floatController.value * 2 * math.pi) * 20;
        final glowIntensity = 0.3 + (_glowController.value * 0.4);

        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer Glow
              Container(
                width: widget.size * 1.5,
                height: widget.size * 1.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFFFFA500).withOpacity(glowIntensity),
                      Color(0xFFFF8C00).withOpacity(glowIntensity * 0.5),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),

              // Rotating Particles
              ...List.generate(12, (index) {
                final angle = (rotation + (index * math.pi / 6));
                final radius = widget.size * 0.7;
                final x = math.cos(angle) * radius;
                final y = math.sin(angle) * radius;
                
                return Transform.translate(
                  offset: Offset(x, y),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFFD700),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFFD700),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              }),

              // Main Coin with 3D effect
              Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(rotation)
                  ..rotateX(math.sin(rotation) * 0.1),
                alignment: Alignment.center,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: Alignment(-0.3, -0.3),
                      colors: [
                        Color(0xFFFFD700), // Gold
                        Color(0xFFFFA500), // Orange
                        Color(0xFFFF8C00), // Dark Orange
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFFFA500).withOpacity(0.6),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Shine effect
                      Positioned(
                        top: widget.size * 0.15,
                        left: widget.size * 0.15,
                        child: Container(
                          width: widget.size * 0.3,
                          height: widget.size * 0.3,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withOpacity(0.4),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      // Bitcoin Symbol
                      Center(
                        child: Text(
                          '₿',
                          style: TextStyle(
                            fontSize: widget.size * 0.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF8C00),
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 10,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Edge highlight
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFFFFD700).withOpacity(0.5),
                            width: 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Energy Rings
              ...List.generate(3, (index) {
                final scale = 1.0 + (index * 0.15) + (_glowController.value * 0.1);
                final opacity = 0.3 - (index * 0.1);
                
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xFFFFD700).withOpacity(opacity),
                        width: 2,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
