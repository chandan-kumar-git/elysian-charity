import 'package:flutter/material.dart';
import 'dart:math' as math;

class HolographicCard extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;

  const HolographicCard({
    Key? key,
    required this.child,
    this.width = 400,
    this.height = 600,
  }) : super(key: key);

  @override
  State<HolographicCard> createState() => _HolographicCardState();
}

class _HolographicCardState extends State<HolographicCard>
    with SingleTickerProviderStateMixin {
  double _rotationX = 0.0;
  double _rotationY = 0.0;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  void _updateRotation(Offset localPosition) {
    setState(() {
      // Calculate rotation based on mouse position
      _rotationY = (localPosition.dx - widget.width / 2) / (widget.width / 2) * 0.1;
      _rotationX = (localPosition.dy - widget.height / 2) / (widget.height / 2) * -0.1;
    });
  }

  void _resetRotation() {
    setState(() {
      _rotationX = 0.0;
      _rotationY = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) => _updateRotation(event.localPosition),
      onExit: (_) => _resetRotation(),
      child: AnimatedBuilder(
        animation: _glowController,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // perspective
              ..rotateX(_rotationX)
              ..rotateY(_rotationY),
            alignment: Alignment.center,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF0A0118).withOpacity(0.9),
                    const Color(0xFF120229).withOpacity(0.9),
                    const Color(0xFF1A0933).withOpacity(0.9),
                  ],
                ),
                border: Border.all(
                  width: 2,
                  color: Colors.transparent,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF006E).withOpacity(0.3 + _glowController.value * 0.3),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: const Color(0xFF00F5FF).withOpacity(0.3 + _glowController.value * 0.3),
                    blurRadius: 40,
                    spreadRadius: 3,
                  ),
                  BoxShadow(
                    color: const Color(0xFFB967FF).withOpacity(0.2 + _glowController.value * 0.2),
                    blurRadius: 50,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Animated border gradient
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          width: 2,
                          color: Colors.transparent,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.lerp(
                              const Color(0xFFFF006E),
                              const Color(0xFF00F5FF),
                              _glowController.value,
                            )!,
                            Color.lerp(
                              const Color(0xFF00F5FF),
                              const Color(0xFFB967FF),
                              _glowController.value,
                            )!,
                            Color.lerp(
                              const Color(0xFFB967FF),
                              const Color(0xFF05FFA1),
                              _glowController.value,
                            )!,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                  // Content
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: widget.child,
                  ),
                  // Holographic shimmer overlay
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: AnimatedOpacity(
                        opacity: 0.1,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(-1 + _glowController.value * 2, -1),
                              end: Alignment(1, 1),
                              colors: [
                                Colors.transparent,
                                Colors.white.withOpacity(0.3),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
