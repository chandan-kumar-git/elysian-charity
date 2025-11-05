import 'package:flutter/material.dart';
import '../widgets/landing/cyberpunk_roadmap_section.dart';
import '../widgets/landing/navbar.dart';
import '../widgets/landing/footer_section.dart';
import '../theme/cyberpunk_theme.dart';

class RoadmapPage extends StatelessWidget {
  const RoadmapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberpunkTheme.darkBg,
      body: CustomScrollView(
        slivers: [
          // Navbar
          const SliverToBoxAdapter(child: CryptoNavbar()),

          // Page Header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 60),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    CyberpunkTheme.neonPurple.withOpacity(0.1),
                    CyberpunkTheme.neonPink.withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '🗺️ ROADMAP',
                    style: CyberpunkTheme.neonText(
                      CyberpunkTheme.neonPurple,
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'OUR JOURNEY TO REVOLUTIONIZE BLOCKCHAIN',
                    style: TextStyle(
                      color: CyberpunkTheme.neonCyan.withOpacity(0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Roadmap Section
          const SliverToBoxAdapter(child: CyberpunkRoadmapSection()),

          // Footer
          const SliverToBoxAdapter(child: FooterSection()),
        ],
      ),
    );
  }
}
