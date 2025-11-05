import 'package:flutter/material.dart';
import '../widgets/landing/cyberpunk_features_section.dart';
import '../widgets/landing/navbar.dart';
import '../widgets/landing/footer_section.dart';
import '../theme/cyberpunk_theme.dart';

class FeaturesPage extends StatelessWidget {
  const FeaturesPage({Key? key}) : super(key: key);

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
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 80),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    CyberpunkTheme.neonCyan.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '✨ Platform Features',
                    style: CyberpunkTheme.neonText(
                      CyberpunkTheme.neonCyan,
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Experience the future of blockchain with cutting-edge technology',
                    style: TextStyle(
                      color: CyberpunkTheme.neonPurple.withOpacity(0.8),
                      fontSize: 20,
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Features Section
          const SliverToBoxAdapter(child: CyberpunkFeaturesSection()),

          // Footer
          const SliverToBoxAdapter(child: FooterSection()),
        ],
      ),
    );
  }
}
