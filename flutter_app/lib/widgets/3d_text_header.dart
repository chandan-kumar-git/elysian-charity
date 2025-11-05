import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/cyberpunk_theme.dart';

class ThreeDTextHeader extends StatefulWidget {
  final String emoji;
  final String title;
  final Color primaryColor;
  final Color secondaryColor;
  final String subtitle;

  const ThreeDTextHeader({
    Key? key,
    required this.emoji,
    required this.title,
    required this.primaryColor,
    required this.secondaryColor,
    required this.subtitle,
  }) : super(key: key);

  @override
  State<ThreeDTextHeader> createState() => _ThreeDTextHeaderState();
}

class _ThreeDTextHeaderState extends State<ThreeDTextHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Emoji with rotation
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(_controller.value * 2 * math.pi)
                ..rotateZ(math.sin(_controller.value * 2 * math.pi) * 0.1),
              child: Text(
                widget.emoji,
                style: TextStyle(
                  fontSize: 80,
                  shadows: [
                    Shadow(
                      color: widget.primaryColor.withOpacity(0.8),
                      blurRadius: 30,
                    ),
                    Shadow(
                      color: widget.secondaryColor.withOpacity(0.6),
                      blurRadius: 50,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 24),

        // 3D Text Title
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final progress = _controller.value;
            final color = Color.lerp(
              widget.primaryColor,
              widget.secondaryColor,
              math.sin(progress * math.pi * 2) * 0.5 + 0.5,
            )!;

            return Stack(
              children: [
                // Shadow layers for 3D depth
                ...List.generate(8, (index) {
                  final offset = (8 - index).toDouble();
                  return Transform.translate(
                    offset: Offset(offset * 0.5, offset * 0.5),
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                        foreground: Paint()
                          ..style = PaintingStyle.fill
                          ..color = Colors.black.withOpacity(0.1),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }),
                
                // Middle gradient layer
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withOpacity(0.6),
                      color,
                      widget.secondaryColor,
                    ],
                  ).createShader(bounds),
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                // Top bright layer
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 2
                      ..color = Colors.white.withOpacity(0.8),
                    shadows: [
                      Shadow(
                        color: color,
                        blurRadius: 40,
                      ),
                      Shadow(
                        color: widget.secondaryColor,
                        blurRadius: 60,
                      ),
                      Shadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 24),

        // Animated subtitle box
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final glowIntensity = math.sin(_controller.value * math.pi * 2) * 0.3 + 0.7;
            
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.primaryColor.withOpacity(glowIntensity),
                  width: 3,
                ),
                gradient: LinearGradient(
                  colors: [
                    widget.primaryColor.withOpacity(0.15),
                    widget.secondaryColor.withOpacity(0.15),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.primaryColor.withOpacity(0.4 * glowIntensity),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: widget.secondaryColor.withOpacity(0.3 * glowIntensity),
                    blurRadius: 50,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.bolt,
                    color: widget.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.subtitle.toUpperCase(),
                    style: TextStyle(
                      color: widget.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                      shadows: [
                        Shadow(
                          color: widget.primaryColor.withOpacity(0.5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.bolt,
                    color: widget.primaryColor,
                    size: 20,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8));
  }
}
