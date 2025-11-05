import 'package:flutter/material.dart';
import 'dart:math' as math;

class CyberpunkGlitchText extends StatefulWidget {
  final String text;
  final double fontSize;
  final bool isMobile;

  const CyberpunkGlitchText({
    Key? key,
    required this.text,
    required this.fontSize,
    this.isMobile = false,
  }) : super(key: key);

  @override
  State<CyberpunkGlitchText> createState() => _CyberpunkGlitchTextState();
}

class _CyberpunkGlitchTextState extends State<CyberpunkGlitchText>
    with TickerProviderStateMixin {
  late AnimationController _glitchController;
  late AnimationController _gradientController;
  late AnimationController _glowController;
  final math.Random _random = math.Random();
  bool _isGlitching = false;

  @override
  void initState() {
    super.initState();

    // Glitch animation - random intervals
    _glitchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    // Gradient shift animation
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Glow pulse animation
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Trigger random glitches
    _scheduleGlitch();
  }

  void _scheduleGlitch() {
    Future.delayed(Duration(milliseconds: 2000 + _random.nextInt(3000)), () {
      if (mounted) {
        setState(() => _isGlitching = true);
        _glitchController.forward().then((_) {
          _glitchController.reverse().then((_) {
            if (mounted) {
              setState(() => _isGlitching = false);
              _scheduleGlitch();
            }
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _glitchController.dispose();
    _gradientController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _glitchController,
        _gradientController,
        _glowController,
      ]),
      builder: (context, child) {
        final glitchOffset = _isGlitching ? _random.nextDouble() * 4 - 2 : 0.0;
        final gradientValue = _gradientController.value;
        final glowIntensity = _glowController.value;

        return Stack(
          children: [
            // Background glow layers
            ..._buildGlowLayers(glowIntensity),

            // 3D Shadow layers
            ..._build3DShadows(),

            // RGB split glitch effect
            if (_isGlitching) ...[
              _buildGlitchLayer(
                offset: Offset(glitchOffset, 0),
                color: const Color(0xFFFF006E).withOpacity(0.7),
              ),
              _buildGlitchLayer(
                offset: Offset(-glitchOffset, 0),
                color: const Color(0xFF00F5FF).withOpacity(0.7),
              ),
            ],

            // Main text with animated gradient
            ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _getGradientColors(gradientValue),
                  stops: const [0.0, 0.5, 1.0],
                ).createShader(bounds);
              },
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.1,
                  letterSpacing: 2,
                ),
              ),
            ),

            // Holographic shimmer overlay
            _buildShimmerOverlay(gradientValue),

            // Scan line effect
            _buildScanLine(gradientValue),
          ],
        );
      },
    );
  }

  List<Widget> _buildGlowLayers(double intensity) {
    return [
      // Outer glow
      Transform.translate(
        offset: const Offset(0, 0),
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 8
              ..color = const Color(0xFF00F5FF).withOpacity(0.3 * intensity)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
            height: 1.1,
            letterSpacing: 2,
          ),
        ),
      ),
      // Inner glow
      Transform.translate(
        offset: const Offset(0, 0),
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4
              ..color = const Color(0xFFFF006E).withOpacity(0.4 * intensity)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
            height: 1.1,
            letterSpacing: 2,
          ),
        ),
      ),
    ];
  }

  List<Widget> _build3DShadows() {
    return List.generate(5, (index) {
      final offset = (index + 1) * 2.0;
      final opacity = 0.15 - (index * 0.02);
      return Transform.translate(
        offset: Offset(offset, offset),
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF000000).withOpacity(opacity),
            height: 1.1,
            letterSpacing: 2,
          ),
        ),
      );
    });
  }

  Widget _buildGlitchLayer({required Offset offset, required Color color}) {
    return Transform.translate(
      offset: offset,
      child: Text(
        widget.text,
        style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.bold,
          color: color,
          height: 1.1,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildShimmerOverlay(double value) {
    return ClipRect(
      child: Align(
        alignment: Alignment.centerLeft,
        widthFactor: math.sin(value * math.pi * 2) * 0.3 + 0.5,
        child: ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.3),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.1,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScanLine(double value) {
    return Positioned(
      left: 0,
      right: 0,
      top: (value * widget.fontSize * 1.5) % (widget.fontSize * 1.5),
      child: Container(
        height: 2,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              const Color(0xFF00F5FF).withOpacity(0.3),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  List<Color> _getGradientColors(double value) {
    final t = value;
    return [
      Color.lerp(const Color(0xFF00F5FF), const Color(0xFFFF006E), t)!,
      Color.lerp(const Color(0xFFB967FF), const Color(0xFF00F5FF), t)!,
      Color.lerp(const Color(0xFFFF006E), const Color(0xFFB967FF), t)!,
    ];
  }
}
