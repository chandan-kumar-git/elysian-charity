import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RoadmapSection extends StatelessWidget {
  const RoadmapSection({Key? key}) : super(key: key);

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
          Text(
            'Roadmap',
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 36 : 48,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn().slideY(begin: 0.2),

          const SizedBox(height: 16),

          Text(
            'Our journey to revolutionize blockchain technology',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: isMobile ? 16 : 18,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, delay: 200.ms),

          const SizedBox(height: 80),

          // Roadmap Items
          _RoadmapItem(
            quarter: 'Q4 2024',
            title: 'Genesis',
            items: const [
              '✅ Mainnet Launch',
              '✅ Token Distribution',
              '✅ DEX Listing',
              '✅ Staking Platform',
            ],
            status: RoadmapStatus.completed,
            gradient: const [Color(0xFF00FF88), Color(0xFF00D957)],
            delay: 0,
          ),

          _RoadmapItem(
            quarter: 'Q1 2025',
            title: 'Expansion',
            items: const [
              '🚀 Cross-Chain Bridge',
              '🚀 Mobile Wallet',
              '🚀 NFT Marketplace',
              '⏳ Governance Launch',
            ],
            status: RoadmapStatus.inProgress,
            gradient: const [Color(0xFF7B3FF2), Color(0xFFB65FFF)],
            delay: 200,
          ),

          _RoadmapItem(
            quarter: 'Q2 2025',
            title: 'Innovation',
            items: const [
              '📋 Layer 2 Solution',
              '📋 DeFi Protocol Suite',
              '📋 DAO Treasury',
              '📋 Institutional Partnerships',
            ],
            status: RoadmapStatus.upcoming,
            gradient: const [Color(0xFF00D9FF), Color(0xFF0099FF)],
            delay: 400,
          ),

          _RoadmapItem(
            quarter: 'Q3-Q4 2025',
            title: 'Mass Adoption',
            items: const [
              '📋 Enterprise Solutions',
              '📋 Global Expansion',
              '📋 Major Exchange Listings',
              '📋 Version 2.0 Launch',
            ],
            status: RoadmapStatus.upcoming,
            gradient: const [Color(0xFFFF6B9D), Color(0xFFFFA500)],
            delay: 600,
          ),
        ],
      ),
    );
  }
}

enum RoadmapStatus { completed, inProgress, upcoming }

class _RoadmapItem extends StatefulWidget {
  final String quarter;
  final String title;
  final List<String> items;
  final RoadmapStatus status;
  final List<Color> gradient;
  final int delay;

  const _RoadmapItem({
    required this.quarter,
    required this.title,
    required this.items,
    required this.status,
    required this.gradient,
    required this.delay,
  });

  @override
  State<_RoadmapItem> createState() => _RoadmapItemState();
}

class _RoadmapItemState extends State<_RoadmapItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 32),
        transform: Matrix4.identity()
          ..translate(_isHovered ? 10.0 : 0.0, 0.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline Line
            Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: widget.gradient),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.gradient[0].withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      widget.status == RoadmapStatus.completed
                          ? Icons.check
                          : widget.status == RoadmapStatus.inProgress
                              ? Icons.rocket_launch
                              : Icons.schedule,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                Container(
                  width: 3,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        widget.gradient[0],
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 32),

            // Content
            Expanded(
              child: Container(
                padding: EdgeInsets.all(isMobile ? 24 : 32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(_isHovered ? 0.15 : 0.08),
                      Colors.white.withOpacity(_isHovered ? 0.08 : 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(_isHovered ? 0.3 : 0.1),
                    width: 1,
                  ),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: widget.gradient[0].withOpacity(0.2),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quarter Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: widget.gradient),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.quarter,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Title
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 24 : 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Items
                    ...widget.items.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            item,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(delay: Duration(milliseconds: widget.delay))
          .slideX(begin: -0.2, delay: Duration(milliseconds: widget.delay)),
    );
  }
}
