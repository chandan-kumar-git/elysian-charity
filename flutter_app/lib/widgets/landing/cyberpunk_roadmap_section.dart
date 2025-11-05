import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/cyberpunk_theme.dart';
import '../3d_text_header.dart';
import '../drifting_car.dart';

class CyberpunkRoadmapSection extends StatefulWidget {
  const CyberpunkRoadmapSection({Key? key}) : super(key: key);

  @override
  State<CyberpunkRoadmapSection> createState() => _CyberpunkRoadmapSectionState();
}

class _CyberpunkRoadmapSectionState extends State<CyberpunkRoadmapSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  final List<RoadmapPhase> phases = [
    RoadmapPhase(
      phase: 'PHASE 1',
      title: 'GENESIS',
      period: 'Q4 2024',
      status: 'COMPLETED',
      color: CyberpunkTheme.neonGreen,
      items: [
        '✓ Smart Contract Development',
        '✓ Security Audits',
        '✓ Testnet Launch',
        '✓ Community Building',
      ],
    ),
    RoadmapPhase(
      phase: 'PHASE 2',
      title: 'IGNITION',
      period: 'Q1 2025',
      status: 'IN PROGRESS',
      color: CyberpunkTheme.neonCyan,
      items: [
        '⚡ Mainnet Launch',
        '⚡ Token Distribution',
        '⚡ Exchange Listings',
        '○ Mobile App Beta',
      ],
    ),
    RoadmapPhase(
      phase: 'PHASE 3',
      title: 'EXPANSION',
      period: 'Q2-Q3 2025',
      status: 'UPCOMING',
      color: CyberpunkTheme.neonPurple,
      items: [
        '○ DeFi Integration',
        '○ Cross-Chain Bridge',
        '○ DAO Governance',
        '○ NFT Marketplace',
      ],
    ),
    RoadmapPhase(
      phase: 'PHASE 4',
      title: 'DOMINATION',
      period: 'Q4 2025+',
      status: 'PLANNED',
      color: CyberpunkTheme.neonPink,
      items: [
        '○ Layer 2 Scaling',
        '○ Enterprise Partnerships',
        '○ Global Expansion',
        '○ Quantum Security',
      ],
    ),
  ];

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
            emoji: '🗺️',
            title: 'MISSION ROADMAP',
            primaryColor: CyberpunkTheme.neonPurple,
            secondaryColor: CyberpunkTheme.neonCyan,
            subtitle: 'OUR JOURNEY TO REVOLUTIONIZE BLOCKCHAIN',
          ),

          const SizedBox(height: 40),

          // Drifting Car
          const DriftingCar(size: 150),

          const SizedBox(height: 80),

          // Roadmap Timeline
          if (isMobile)
            Column(
              children: phases
                  .asMap()
                  .entries
                  .map((entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: _buildPhaseCard(entry.value, entry.key, isMobile),
                      ))
                  .toList(),
            )
          else
            _buildDesktopTimeline(),
        ],
      ),
    );
  }

  Widget _buildDesktopTimeline() {
    return Column(
      children: [
        // Timeline connector
        SizedBox(
          height: 200 * phases.length.toDouble(),
          child: CustomPaint(
            size: Size(double.infinity, 200 * phases.length.toDouble()),
            painter: _TimelinePainter(phases),
          ),
        ),

        // Phase cards
        ...phases.asMap().entries.map((entry) {
          final index = entry.key;
          final phase = entry.value;
          final isLeft = index % 2 == 0;

          return Transform.translate(
            offset: Offset(0, -200 * phases.length.toDouble() + index * 200 + 100),
            child: Row(
              children: [
                if (isLeft) ...[
                  Expanded(child: _buildPhaseCard(phase, index, false)),
                  const SizedBox(width: 100),
                  const Expanded(child: SizedBox()),
                ] else ...[
                  const Expanded(child: SizedBox()),
                  const SizedBox(width: 100),
                  Expanded(child: _buildPhaseCard(phase, index, false)),
                ],
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildPhaseCard(RoadmapPhase phase, int index, bool isMobile) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: _AnimatedPhaseCard(
        phase: phase,
        index: index,
        isMobile: isMobile,
      ),
    );
  }
}

class RoadmapPhase {
  final String phase;
  final String title;
  final String period;
  final String status;
  final Color color;
  final List<String> items;

  RoadmapPhase({
    required this.phase,
    required this.title,
    required this.period,
    required this.status,
    required this.color,
    required this.items,
  });
}

class _AnimatedPhaseCard extends StatefulWidget {
  final RoadmapPhase phase;
  final int index;
  final bool isMobile;

  const _AnimatedPhaseCard({
    required this.phase,
    required this.index,
    required this.isMobile,
  });

  @override
  State<_AnimatedPhaseCard> createState() => _AnimatedPhaseCardState();
}

class _AnimatedPhaseCardState extends State<_AnimatedPhaseCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  bool _isHovered = false;

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
      },
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + _hoverController.value * 0.05,
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
                    widget.phase.color.withOpacity(0.1),
                  ],
                ),
                border: Border.all(
                  color: widget.phase.color.withOpacity(0.3 + _hoverController.value * 0.5),
                  width: 2 + _hoverController.value * 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.phase.color.withOpacity(0.2 + _hoverController.value * 0.3),
                    blurRadius: 20 + _hoverController.value * 30,
                    spreadRadius: 2 + _hoverController.value * 4,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Phase badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [widget.phase.color, widget.phase.color.withOpacity(0.5)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: CyberpunkTheme.neonGlow(widget.phase.color),
                        ),
                        child: Text(
                          widget.phase.phase,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: widget.phase.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: widget.phase.color.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          widget.phase.status,
                          style: TextStyle(
                            color: widget.phase.color,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Title
                  Text(
                    widget.phase.title,
                    style: CyberpunkTheme.neonText(
                      widget.phase.color,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Period
                  Text(
                    widget.phase.period,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Items
                  ...widget.phase.items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Icon(
                              item.startsWith('✓')
                                  ? Icons.check_circle
                                  : item.startsWith('⚡')
                                      ? Icons.bolt
                                      : Icons.radio_button_unchecked,
                              color: item.startsWith('✓')
                                  ? CyberpunkTheme.neonGreen
                                  : item.startsWith('⚡')
                                      ? CyberpunkTheme.neonYellow
                                      : Colors.white.withOpacity(0.3),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item.substring(2),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(
                                    item.startsWith('○') ? 0.5 : 0.8,
                                  ),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          );
        },
      ),
    ).animate(delay: Duration(milliseconds: 400 + widget.index * 200))
        .fadeIn()
        .slideX(begin: widget.index % 2 == 0 ? -0.3 : 0.3);
  }
}

class _TimelinePainter extends CustomPainter {
  final List<RoadmapPhase> phases;

  _TimelinePainter(this.phases);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;

    // Draw vertical line
    paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        CyberpunkTheme.neonGreen,
        CyberpunkTheme.neonCyan,
        CyberpunkTheme.neonPurple,
        CyberpunkTheme.neonPink,
      ],
    ).createShader(Rect.fromLTWH(centerX - 2, 0, 4, size.height));

    canvas.drawLine(
      Offset(centerX, 0),
      Offset(centerX, size.height),
      paint,
    );

    // Draw nodes
    for (int i = 0; i < phases.length; i++) {
      final y = i * 200.0 + 100;
      final phase = phases[i];

      // Outer glow
      paint.shader = null;
      paint.color = phase.color.withOpacity(0.3);
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(Offset(centerX, y), 20, paint);

      // Inner circle
      paint.color = phase.color;
      canvas.drawCircle(Offset(centerX, y), 12, paint);

      // Core
      paint.color = Colors.white;
      canvas.drawCircle(Offset(centerX, y), 6, paint);
    }
  }

  @override
  bool shouldRepaint(_TimelinePainter oldDelegate) => false;
}
