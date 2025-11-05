import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/cyberpunk_theme.dart';
import '../3d_text_header.dart';
import '../revolving_diamond.dart';
import 'dart:math' as math;

class CyberpunkFeaturesSection extends StatefulWidget {
  const CyberpunkFeaturesSection({Key? key}) : super(key: key);

  @override
  State<CyberpunkFeaturesSection> createState() => _CyberpunkFeaturesSectionState();
}

class _CyberpunkFeaturesSectionState extends State<CyberpunkFeaturesSection>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 64,
        vertical: 120,
      ),
      child: Column(
        children: [
          // 3D Text Header
          ThreeDTextHeader(
            emoji: '⚡',
            title: 'QUANTUM FEATURES',
            primaryColor: CyberpunkTheme.neonCyan,
            secondaryColor: CyberpunkTheme.neonPink,
            subtitle: 'NEXT-GENERATION BLOCKCHAIN TECHNOLOGY',
          ),

          const SizedBox(height: 40),

          // Revolving Diamond
          const RevolvingDiamond(size: 150),

          const SizedBox(height: 60),

          // Features Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth < 768
                  ? 1
                  : constraints.maxWidth < 1200
                      ? 2
                      : 3;

              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 32,
                crossAxisSpacing: 32,
                childAspectRatio: 1.0,
                children: [
                  _CyberpunkFeatureCard(
                    icon: Icons.flash_on,
                    title: 'LIGHTNING SPEED',
                    description:
                        'Process 100K+ TPS with quantum-level optimization and zero-latency confirmation',
                    primaryColor: CyberpunkTheme.neonYellow,
                    secondaryColor: const Color(0xFF7D7D00),
                    delay: 0,
                  ),
                  _CyberpunkFeatureCard(
                    icon: Icons.shield,
                    title: 'MILITARY SECURITY',
                    description:
                        'Multi-signature encryption with AI-powered threat detection and instant response',
                    primaryColor: CyberpunkTheme.neonCyan,
                    secondaryColor: const Color(0xFF006B7D),
                    delay: 100,
                  ),
                  _CyberpunkFeatureCard(
                    icon: Icons.hub,
                    title: 'DEFI ECOSYSTEM',
                    description:
                        'Complete DeFi suite with yield farming, liquidity pools, and automated strategies',
                    primaryColor: CyberpunkTheme.neonGreen,
                    secondaryColor: const Color(0xFF027D50),
                    delay: 200,
                  ),
                  _CyberpunkFeatureCard(
                    icon: Icons.public,
                    title: 'CROSS-CHAIN BRIDGE',
                    description:
                        'Seamless asset transfer across 50+ blockchains with instant settlement',
                    primaryColor: CyberpunkTheme.neonPurple,
                    secondaryColor: const Color(0xFF5B0DAE),
                    delay: 300,
                  ),
                  _CyberpunkFeatureCard(
                    icon: Icons.smart_toy,
                    title: 'AI-POWERED ANALYTICS',
                    description:
                        'Advanced machine learning for market prediction and portfolio optimization',
                    primaryColor: CyberpunkTheme.neonPink,
                    secondaryColor: const Color(0xFF8B0042),
                    delay: 400,
                  ),
                  _CyberpunkFeatureCard(
                    icon: Icons.volunteer_activism,
                    title: 'SOCIAL IMPACT',
                    description:
                        'Every transaction creates real-world impact with transparent donation tracking',
                    primaryColor: const Color(0xFFFF4081),
                    secondaryColor: const Color(0xFF7D0020),
                    delay: 500,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CyberpunkFeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color primaryColor;
  final Color secondaryColor;
  final int delay;

  const _CyberpunkFeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.primaryColor,
    required this.secondaryColor,
    required this.delay,
  });

  @override
  State<_CyberpunkFeatureCard> createState() => _CyberpunkFeatureCardState();
}

class _CyberpunkFeatureCardState extends State<_CyberpunkFeatureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  bool _isHovered = false;
  double _rotationX = 0.0;
  double _rotationY = 0.0;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _updateRotation(Offset localPosition, Size size) {
    setState(() {
      _rotationY = (localPosition.dx - size.width / 2) / (size.width / 2) * 0.1;
      _rotationX = (localPosition.dy - size.height / 2) / (size.height / 2) * -0.1;
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
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
        _resetRotation();
      },
      onHover: (event) {
        if (_isHovered) {
          _updateRotation(
            event.localPosition,
            Size(300, 300),
          );
        }
      },
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(_rotationX)
              ..rotateY(_rotationY)
              ..scale(1.0 + _hoverController.value * 0.05),
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    CyberpunkTheme.darkBg,
                    CyberpunkTheme.darkBg2,
                    widget.secondaryColor.withOpacity(0.1),
                  ],
                ),
                border: Border.all(
                  color: widget.primaryColor.withOpacity(0.3 + _hoverController.value * 0.5),
                  width: 2 + _hoverController.value * 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.primaryColor.withOpacity(0.2 + _hoverController.value * 0.3),
                    blurRadius: 20 + _hoverController.value * 30,
                    spreadRadius: 2 + _hoverController.value * 4,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon with glow
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          widget.primaryColor.withOpacity(0.3),
                          widget.primaryColor.withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Icon(
                      widget.icon,
                      size: 48,
                      color: widget.primaryColor,
                      shadows: [
                        Shadow(
                          color: widget.primaryColor.withOpacity(0.8),
                          blurRadius: 20 + _hoverController.value * 20,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Title
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: widget.primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          color: widget.primaryColor.withOpacity(0.5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // Description
                  Text(
                    widget.description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  // Learn More button (appears on hover)
                  AnimatedOpacity(
                    opacity: _hoverController.value,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [widget.primaryColor, widget.secondaryColor],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: CyberpunkTheme.neonGlow(widget.primaryColor),
                      ),
                      child: Text(
                        'LEARN MORE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
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
    ).animate(delay: Duration(milliseconds: widget.delay))
        .fadeIn()
        .slideY(begin: 0.3);
  }
}
