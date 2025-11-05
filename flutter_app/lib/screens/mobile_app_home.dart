import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../services/wallet_service.dart';
import '../services/auth_service.dart';
import '../services/advanced_animation_service.dart';
import '../services/realtime_service.dart';
import 'wallet_screen.dart';
import 'social_feed_screen.dart';
import 'marketplace_screen.dart';
import 'messaging_screen.dart';
import 'camera_screen.dart';
import 'maps_screen.dart';
import 'music_player_screen.dart';
import 'games_screen.dart';
import 'settings_screen.dart';

/// Complete mobile app home screen with all features
/// Mimics real smartphone interface with status bar, widgets, and app grid
class MobileAppHome extends StatefulWidget {
  const MobileAppHome({super.key});

  @override
  State<MobileAppHome> createState() => _MobileAppHomeState();
}

class _MobileAppHomeState extends State<MobileAppHome>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _selectedIndex = 0;
  String _searchQuery = '';
  bool _showNotifications = false;
  final RealTimeService _realTimeService = RealTimeService();
  final ScrollController _scrollController = ScrollController();

  final List<AppFeature> _apps = [
    AppFeature(
      name: 'Wallet',
      icon: Icons.account_balance_wallet,
      color: const Color(0xFF7c3aed),
      screen: const WalletScreen(),
      badge: 3,
    ),
    AppFeature(
      name: 'Social',
      icon: Icons.people,
      color: const Color(0xFFe11d48),
      screen: const SocialFeedScreen(),
      badge: 12,
    ),
    AppFeature(
      name: 'Market',
      icon: Icons.shopping_bag,
      color: const Color(0xFF0ea5e9),
      screen: const MarketplaceScreen(),
    ),
    AppFeature(
      name: 'Messages',
      icon: Icons.chat_bubble,
      color: const Color(0xFF10b981),
      screen: const MessagingScreen(),
      badge: 5,
    ),
    AppFeature(
      name: 'Camera',
      icon: Icons.camera_alt,
      color: const Color(0xFFf59e0b),
      screen: const CameraScreen(),
    ),
    AppFeature(
      name: 'Maps',
      icon: Icons.map,
      color: const Color(0xFF8b5cf6),
      screen: const MapsScreen(),
    ),
    AppFeature(
      name: 'Music',
      icon: Icons.music_note,
      color: const Color(0xFFec4899),
      screen: const MusicPlayerScreen(),
    ),
    AppFeature(
      name: 'Games',
      icon: Icons.games,
      color: const Color(0xFF06b6d4),
      screen: const GamesScreen(),
    ),
    AppFeature(
      name: 'Settings',
      icon: Icons.settings,
      color: const Color(0xFF64748b),
      screen: const SettingsScreen(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _controller.forward();
    _realTimeService.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _openApp(AppFeature app) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => app.screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Animated Gradient Background
            _buildAnimatedBackground(),
            
            // Floating Particles
            AdvancedAnimationService.floatingParticles(
              child: Container(),
              particleCount: 30,
              particleColor: Colors.purple.withOpacity(0.3),
            ),
            
            // Main Content
            Column(
              children: [
                // Status Bar
                _buildStatusBar(),

                // Search Bar
                _buildSearchBar(),

                // Quick Widgets
                _buildQuickWidgets(),

                // App Grid with parallax
                Expanded(
                  child: _buildAppGrid(),
                ),

                // Bottom Navigation
                _buildBottomNav(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Time
          Text(
            '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          // Status Icons
          Row(
            children: [
              const Icon(Icons.signal_cellular_4_bar,
                  color: Colors.white, size: 18),
              const SizedBox(width: 8),
              const Icon(Icons.wifi, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Stack(
                children: [
                  const Icon(Icons.battery_full, color: Colors.white, size: 18),
                  Positioned(
                    right: 3,
                    top: 5,
                    child: Container(
                      width: 8,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: TextField(
          onChanged: (value) => setState(() => _searchQuery = value),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search apps, contacts, web...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
            prefixIcon: Icon(Icons.search,
                color: Colors.white.withOpacity(0.6), size: 20),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white, size: 20),
                    onPressed: () => setState(() => _searchQuery = ''),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2, end: 0);
  }

  Widget _buildQuickWidgets() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          _buildWidgetCard(
            'Total Balance',
            '\$12,458',
            Icons.account_balance,
            const Color(0xFF7c3aed),
          ).animate().fadeIn(delay: 200.ms).scale(delay: 200.ms),
          const SizedBox(width: 12),
          _buildWidgetCard(
            'Donations',
            '24 Today',
            Icons.favorite,
            const Color(0xFFe11d48),
          ).animate().fadeIn(delay: 300.ms).scale(delay: 300.ms),
          const SizedBox(width: 12),
          _buildWidgetCard(
            'NFTs',
            '47 Items',
            Icons.photo_library,
            const Color(0xFF0ea5e9),
          ).animate().fadeIn(delay: 400.ms).scale(delay: 400.ms),
          const SizedBox(width: 12),
          _buildWidgetCard(
            'Messages',
            '5 Unread',
            Icons.mail,
            const Color(0xFF10b981),
          ).animate().fadeIn(delay: 500.ms).scale(delay: 500.ms),
        ],
      ),
    );
  }

  Widget _buildWidgetCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.3),
            color.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppGrid() {
    final filteredApps = _searchQuery.isEmpty
        ? _apps
        : _apps
            .where((app) =>
                app.name.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.8,
      ),
      itemCount: filteredApps.length,
      itemBuilder: (context, index) {
        final app = filteredApps[index];
        return _buildAppIcon(app, index);
      },
    );
  }

  Widget _buildAppIcon(AppFeature app, int index) {
    return AdvancedAnimationService.bounce(
      child: GestureDetector(
        onTap: () => _openApp(app),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                // Glow effect behind icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: app.color.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                )
                    .animate(onPlay: (controller) => controller.repeat(reverse: true))
                    .shimmer(duration: 2000.ms, color: app.color.withOpacity(0.3)),
                    
                AdvancedAnimationService.pulse(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          app.color,
                          app.color.withOpacity(0.6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: app.color.withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: app.color.withOpacity(0.2),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      app.icon,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                if (app.badge != null && app.badge! > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: AdvancedAnimationService.pulse(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          app.badge! > 99 ? '99+' : app.badge.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              app.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: (100 * index).ms)
        .scale(delay: (100 * index).ms, begin: const Offset(0.8, 0.8));
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', 0),
          _buildNavItem(Icons.explore, 'Explore', 1),
          _buildNavItem(Icons.add_circle, 'Create', 2, isSpecial: true),
          _buildNavItem(Icons.notifications, 'Alerts', 3, badge: 8),
          _buildNavItem(Icons.person, 'Profile', 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index,
      {bool isSpecial = false, int? badge}) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? const Color(0xFF7c3aed)
                    : Colors.white.withOpacity(0.5),
                size: isSpecial ? 32 : 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xFF7c3aed)
                      : Colors.white.withOpacity(0.5),
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
          if (badge != null && badge > 0)
            Positioned(
              right: -4,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  badge > 9 ? '9+' : badge.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Animated Gradient Background
  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF0a0a0a),
                Color.lerp(
                  const Color(0xFF1a0a2e),
                  const Color(0xFF0f1419),
                  _controller.value,
                )!,
                const Color(0xFF0a0a0a),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Glowing Orbs
              Positioned(
                top: 100,
                right: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF7c3aed).withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                )
                    .animate(onPlay: (controller) => controller.repeat(reverse: true))
                    .scale(duration: 3000.ms, begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2)),
              ),
              Positioned(
                bottom: 150,
                left: -50,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFe11d48).withOpacity(0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                )
                    .animate(onPlay: (controller) => controller.repeat(reverse: true))
                    .scale(duration: 4000.ms, begin: const Offset(0.9, 0.9), end: const Offset(1.3, 1.3)),
              ),
              Positioned(
                top: 300,
                left: 50,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF0ea5e9).withOpacity(0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                )
                    .animate(onPlay: (controller) => controller.repeat(reverse: true))
                    .scale(duration: 3500.ms, begin: const Offset(0.85, 0.85), end: const Offset(1.15, 1.15)),
              ),
              // Grid Pattern
              Positioned.fill(
                child: CustomPaint(
                  painter: GridPatternPainter(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Grid Pattern Painter for Cyberpunk Effect
class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan.withOpacity(0.03)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 50.0;
    
    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
    
    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AppFeature {
  final String name;
  final IconData icon;
  final Color color;
  final Widget screen;
  final int? badge;

  AppFeature({
    required this.name,
    required this.icon,
    required this.color,
    required this.screen,
    this.badge,
  });
}
