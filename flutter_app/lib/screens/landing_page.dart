import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:math' as math;
import '../widgets/landing/hero_section.dart';
import '../widgets/landing/features_section.dart';
import '../widgets/landing/stats_section.dart';
import '../widgets/landing/roadmap_section.dart';
import '../widgets/landing/footer_section.dart';
import '../widgets/landing/navbar.dart';
import '../widgets/landing/live_blockchain_visualizer.dart';
import '../widgets/landing/donation_ticker.dart';
import '../widgets/landing/interactive_3d_cards.dart';
import '../widgets/landing/trust_indicators.dart';
import '../widgets/landing/testimonials_carousel.dart';
import '../widgets/landing/impact_counters.dart';
import '../widgets/landing/faq_section.dart';
import '../theme/cyberpunk_theme.dart';
import '../widgets/cyberpunk_glitch_text.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _particleController;
  bool _showScrollTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _scrollController.addListener(() {
      if (_scrollController.offset > 500 && !_showScrollTop) {
        setState(() => _showScrollTop = true);
      } else if (_scrollController.offset <= 500 && _showScrollTop) {
        setState(() => _showScrollTop = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberpunkTheme.darkBg,
      body: Stack(
        children: [
          // Animated Cyberpunk Background
          _buildCyberpunkBackground(),

          // Main Content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Navbar
              const SliverToBoxAdapter(child: CryptoNavbar()),

              // Hero Section
              const SliverToBoxAdapter(child: HeroSection()),

              // NEW: Live Donation Ticker
              const SliverToBoxAdapter(child: DonationTicker()),

              // NEW: Trust Indicators Bar
              const SliverToBoxAdapter(child: TrustIndicators()),

              // Live Blockchain Visualizer (Replaces Video Demo)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 64,
                    vertical: 80,
                  ),
                  child: Column(
                    children: [
                      CyberpunkGlitchText(
                        text: 'Watch Blockchain in Action',
                        fontSize: 42,
                      ).animate().fadeIn().slideY(begin: 0.2),
                      const SizedBox(height: 16),
                      Text(
                        'Real-time transaction feed from the Ethereum network',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 200.ms).slideY(
                            begin: 0.2,
                            delay: 200.ms,
                          ),
                      const SizedBox(height: 48),
                      const LiveBlockchainVisualizer()
                          .animate()
                          .fadeIn(delay: 400.ms)
                          .slideY(begin: 0.3, delay: 400.ms),
                    ],
                  ),
                ),
              ),

              // NEW: Interactive 3D Cards
              const SliverToBoxAdapter(child: Interactive3DCards()),

              // NEW: Impact Counters
              const SliverToBoxAdapter(child: ImpactCounters()),

              // Stats Section
              const SliverToBoxAdapter(child: StatsSection()),

              // NEW: Testimonials Carousel
              const SliverToBoxAdapter(child: TestimonialsCarousel()),

              // NEW: FAQ Section
              const SliverToBoxAdapter(child: FAQSection()),

              // Footer
              const SliverToBoxAdapter(child: FooterSection()),
            ],
          ),

          // Scroll to Top Button
          if (_showScrollTop)
            Positioned(
              bottom: 32,
              right: 32,
              child: FloatingActionButton(
                onPressed: _scrollToTop,
                backgroundColor: const Color(0xFF7B3FF2),
                child: const Icon(Icons.arrow_upward),
              ).animate().scale().fadeIn(),
            ),
        ],
      ),
    );
  }

  Widget _buildCyberpunkBackground() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                CyberpunkTheme.darkBg,
                CyberpunkTheme.darkBg2,
                CyberpunkTheme.darkBg3,
              ],
              stops: [
                0.0,
                0.5 + math.sin(_particleController.value * 2 * math.pi) * 0.1,
                1.0,
              ],
            ),
          ),
          child: CustomPaint(
            painter: CyberpunkParticlesPainter(_particleController.value),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}

class CyberpunkParticlesPainter extends CustomPainter {
  final double animationValue;

  CyberpunkParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 2;

    final random = math.Random(42);
    
    // Draw neon particles
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = (random.nextDouble() * size.height +
              animationValue * size.height * 0.5) %
          size.height;
      final radius = random.nextDouble() * 3 + 1;

      // Cyberpunk colored particles
      final colors = [
        const Color(0xFFFF006E), // Pink
        const Color(0xFF00F5FF), // Cyan
        const Color(0xFFB967FF), // Purple
        const Color(0xFF05FFA1), // Green
      ];
      final color = colors[i % colors.length];

      // Glow effect
      canvas.drawCircle(
        Offset(x, y),
        radius + 2,
        paint..color = color.withOpacity(random.nextDouble() * 0.2),
      );
      
      // Core
      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint..color = color.withOpacity(random.nextDouble() * 0.5),
      );
    }

    // Draw connecting lines with neon effect
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1.5;
    for (int i = 0; i < 20; i++) {
      final x1 = random.nextDouble() * size.width;
      final y1 = random.nextDouble() * size.height;
      final x2 = x1 + random.nextDouble() * 100 - 50;
      final y2 = y1 + random.nextDouble() * 100 - 50;

      final lineColor = i % 2 == 0 
          ? const Color(0xFF00F5FF) 
          : const Color(0xFFFF006E);
      canvas.drawLine(
        Offset(x1, y1),
        Offset(x2, y2),
        paint..color = lineColor.withOpacity(0.15),
      );
    }

    // Add grid lines for cyberpunk feel
    paint.strokeWidth = 0.5;
    for (int i = 0; i < size.height; i += 100) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint..color = const Color(0xFF00F5FF).withOpacity(0.05),
      );
    }
  }

  @override
  bool shouldRepaint(CyberpunkParticlesPainter oldDelegate) => true;
}

