import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'feature_info_modal.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({Key? key}) : super(key: key);

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
          // Section Title
          Text(
            'Why Choose Elysian?',
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 36 : 48,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn().slideY(begin: 0.2),

          const SizedBox(height: 16),

          Text(
            'Built for the future of decentralized finance',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: isMobile ? 16 : 18,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, delay: 200.ms),

          const SizedBox(height: 80),

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
                childAspectRatio: 1.1,
                children: [
                  _FeatureCard(
                    icon: Icons.bolt,
                    title: 'Lightning Fast',
                    description:
                        'Process thousands of transactions per second with near-instant finality',
                    gradient: const [Color(0xFF7B3FF2), Color(0xFFB65FFF)],
                    delay: 0,
                  ),
                  _FeatureCard(
                    icon: Icons.security,
                    title: 'Bank-Grade Security',
                    description:
                        'Multi-layered security architecture protecting billions in assets',
                    gradient: const [Color(0xFF00D9FF), Color(0xFF00FF88)],
                    delay: 100,
                  ),
                  _FeatureCard(
                    icon: Icons.account_balance,
                    title: 'DeFi Ready',
                    description:
                        'Built-in support for lending, staking, and yield farming',
                    gradient: const [Color(0xFFFF6B9D), Color(0xFFFFA500)],
                    delay: 200,
                  ),
                  _FeatureCard(
                    icon: Icons.trending_up,
                    title: 'Low Fees',
                    description:
                        'Transaction costs reduced by 99% compared to traditional networks',
                    gradient: const [Color(0xFF00FFD1), Color(0xFF0099FF)],
                    delay: 300,
                  ),
                  _FeatureCard(
                    icon: Icons.hub,
                    title: 'Cross-Chain',
                    description:
                        'Seamlessly bridge assets across multiple blockchain networks',
                    gradient: const [Color(0xFFFFA500), Color(0xFFFF6B00)],
                    delay: 400,
                  ),
                  _FeatureCard(
                    icon: Icons.eco,
                    title: 'Eco-Friendly',
                    description:
                        '99.9% lower energy consumption with Proof-of-Stake consensus',
                    gradient: const [Color(0xFF00FF88), Color(0xFF00D957)],
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

class _FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<Color> gradient;
  final int delay;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
    required this.delay,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.identity()
          ..translate(0.0, _isHovered ? -10.0 : 0.0),
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
                    color: widget.gradient[0].withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ]
              : [],
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: widget.gradient),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: widget.gradient[0].withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                widget.icon,
                color: Colors.white,
                size: 32,
              ),
            ),

            const SizedBox(height: 24),

            // Title
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              widget.description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 15,
                height: 1.6,
              ),
            ),

            const Spacer(),

            // Learn More Link
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  final featureData = FeatureInfo.features[widget.title];
                  if (featureData != null) {
                    showDialog(
                      context: context,
                      builder: (context) => FeatureInfoModal(
                        title: widget.title,
                        icon: widget.icon,
                        gradient: widget.gradient,
                        description: featureData['description'],
                        keyPoints: List<String>.from(featureData['keyPoints']),
                        technicalDetails: featureData['technicalDetails'],
                      ),
                    );
                  }
                },
                child: Row(
                  children: [
                    Text(
                      'Learn more',
                      style: TextStyle(
                        color: widget.gradient[0],
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      color: widget.gradient[0],
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(delay: Duration(milliseconds: widget.delay))
          .slideY(begin: 0.3, delay: Duration(milliseconds: widget.delay)),
    );
  }
}
