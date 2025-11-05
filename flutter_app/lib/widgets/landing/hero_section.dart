import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../../services/auth_service.dart';
import 'animated_bitcoin_coin.dart';
import '../revolving_coins.dart';
import '../cyberpunk_glitch_text.dart';
import '../wallet_connect_modal.dart';
import '../../screens/production_dashboard.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({Key? key}) : super(key: key);

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      height: size.height * 0.9,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 64,
        vertical: 64,
      ),
      child: Row(
        children: [
          // Left Content
          Expanded(
            flex: isMobile ? 1 : 5,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF7B3FF2).withOpacity(0.2),
                        const Color(0xFFB65FFF).withOpacity(0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF7B3FF2).withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00FF88),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF00FF88),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Mainnet Now Live',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideX(begin: -0.2, duration: 600.ms),

                const SizedBox(height: 32),

                // Main Title with Cyberpunk Effects
                CyberpunkGlitchText(
                  text: 'Where Technology Meets',
                  fontSize: isMobile ? 48 : 72,
                  isMobile: isMobile,
                )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 800.ms)
                    .slideX(begin: -0.2, delay: 200.ms),

                const SizedBox(height: 8),

                // Animated Text
                SizedBox(
                  height: isMobile ? 60 : 90,
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontSize: isMobile ? 48 : 72,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Compassion',
                          textStyle: TextStyle(
                            fontSize: isMobile ? 48 : 72,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: [Color(0xFFFF6B9D), Color(0xFFFFA500)],
                              ).createShader(
                                Rect.fromLTWH(0, 0, 500, 70),
                              ),
                          ),
                          speed: const Duration(milliseconds: 100),
                        ),
                        TypewriterAnimatedText(
                          'Hope',
                          textStyle: TextStyle(
                            fontSize: isMobile ? 48 : 72,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: [Color(0xFF00FF88), Color(0xFF00D9FF)],
                              ).createShader(
                                Rect.fromLTWH(0, 0, 500, 70),
                              ),
                          ),
                          speed: const Duration(milliseconds: 100),
                        ),
                        TypewriterAnimatedText(
                          'Humanity',
                          textStyle: TextStyle(
                            fontSize: isMobile ? 48 : 72,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: [Color(0xFF7B3FF2), Color(0xFFB65FFF)],
                              ).createShader(
                                Rect.fromLTWH(0, 0, 500, 70),
                              ),
                          ),
                          speed: const Duration(milliseconds: 100),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Description
                Text(
                  'Every transaction secured by blockchain. Every donation tracked with transparency. '
                  'Every life touched with dignity. Because technology should protect what matters most—trust, safety, and hope.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: isMobile ? 16 : 18,
                    height: 1.6,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 800.ms)
                    .slideX(begin: -0.2, delay: 400.ms),

                const SizedBox(height: 48),

                // CTA Buttons
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    GestureDetector(
                      onTap: () => _showWalletConnect(context),
                      child: _buildPrimaryButton('Donate Now ❤️', Icons.favorite),
                    ),
                    _buildSecondaryButton('View Demo', Icons.play_circle),
                  ],
                )
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 800.ms)
                    .slideX(begin: -0.2, delay: 600.ms),

                const SizedBox(height: 64),

                // Stats Row - REAL DATA from Auth Service
                Consumer<AuthService>(
                  builder: (context, authService, child) {
                    return Wrap(
                      spacing: 48,
                      runSpacing: 24,
                      children: [
                        _buildStat('\$1.2B+', 'Total Value Locked'),
                        _buildStat(
                          '${(authService.totalUsers / 1000).toStringAsFixed(0)}K+',
                          'Registered Users',
                        ),
                        _buildStat(
                          '${authService.activeUsersToday}+',
                          'Active Today',
                        ),
                      ],
                    );
                  },
                )
                    .animate()
                    .fadeIn(delay: 800.ms, duration: 800.ms)
                    .slideY(begin: 0.2, delay: 800.ms),
              ],
            ),
            ),
          ),

          if (!isMobile) const SizedBox(width: 64),

          // Right Content - Animated Bitcoin Coin with Revolving Coins
          if (!isMobile)
            Expanded(
              flex: 4,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Revolving small coins
                  const RevolvingCoins(radius: 180, coinCount: 8)
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 1000.ms),
                  
                  // Main Bitcoin coin
                  const AnimatedBitcoinCoin(size: 350)
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 1200.ms)
                      .scale(begin: const Offset(0.8, 0.8), delay: 400.ms),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _build3DHeroGraphic() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow Effect
        Container(
          width: 400,
          height: 400,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                const Color(0xFF7B3FF2).withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
        ).animate(onPlay: (controller) => controller.repeat()).shimmer(
              duration: 2000.ms,
              color: const Color(0xFF7B3FF2).withOpacity(0.3),
            ),

        // Main Circle
        Container(
          width: 350,
          height: 350,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF7B3FF2),
                Color(0xFFB65FFF),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7B3FF2).withOpacity(0.5),
                blurRadius: 60,
                spreadRadius: 20,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Rotating Rings
              ...[0, 1, 2].map((index) {
                return Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: (_controller.value + index * 0.33) * 2 * math.pi,
                        child: Container(
                          margin: EdgeInsets.all(20.0 + index * 30),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 2,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),

              // Center Icon
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.currency_bitcoin,
                    size: 60,
                    color: Color(0xFF7B3FF2),
                  ),
                ).animate(onPlay: (controller) => controller.repeat()).scale(
                      duration: 2000.ms,
                      begin: const Offset(1, 1),
                      end: const Offset(1.1, 1.1),
                    ),
              ),
            ],
          ),
        ),

        // Floating Particles
        ...[0, 1, 2, 3, 4].map((index) {
          return Positioned(
            left: 175 + math.cos(index * math.pi * 0.4) * 200,
            top: 175 + math.sin(index * math.pi * 0.4) * 200,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final offset =
                    math.sin((_controller.value + index * 0.2) * 2 * math.pi) *
                        10;
                return Transform.translate(
                  offset: Offset(offset, offset),
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPrimaryButton(String text, IconData icon) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7B3FF2), Color(0xFFB65FFF)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7B3FF2).withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Icon(icon, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(String text, IconData icon) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Icon(icon, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
  
  void _showWalletConnect(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WalletConnectModal(
        onConnected: () {
          Navigator.pop(context); // Close modal
          // Navigate to production dashboard
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProductionDashboard(),
            ),
          );
        },
      ),
    );
  }
}
