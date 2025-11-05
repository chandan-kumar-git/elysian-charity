import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:elysian_flutter/services/auth_service.dart';

class CryptoNavbar extends StatefulWidget {
  const CryptoNavbar({Key? key}) : super(key: key);

  @override
  State<CryptoNavbar> createState() => _CryptoNavbarState();
}

class _CryptoNavbarState extends State<CryptoNavbar> {
  bool _isScrolled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: _isScrolled
            ? const Color(0xFF0A0E27).withOpacity(0.95)
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        boxShadow: _isScrolled
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
        child: Row(
          children: [
            // Logo
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7B3FF2), Color(0xFFB65FFF)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7B3FF2).withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.bolt, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                const Text(
                  'ELYSIAN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ).animate().fadeIn().slideX(begin: -0.2, duration: 600.ms),

            const Spacer(),

            // Nav Links
            ...[
              'Home',
              'Features',
              'Tokenomics',
              'Roadmap',
              'Docs',
            ].asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _NavLink(entry.value),
              ).animate().fadeIn(delay: (100 * entry.key).ms);
            }),

            const SizedBox(width: 24),

            // CTA Buttons
            _buildGradientButton(
              'Launch App',
              icon: Icons.rocket_launch,
              onTap: () {
                Navigator.pushNamed(context, '/dashboard');
              },
            ).animate().fadeIn(delay: 400.ms).scale(delay: 400.ms),

            const SizedBox(width: 16),

            // Login/User Button
            Consumer<AuthService>(
              builder: (context, authService, _) {
                if (authService.isAuthenticated) {
                  return _buildUserAvatar(authService);
                }
                return _buildOutlineButton(
                  'Login',
                  icon: Icons.person,
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                );
              },
            ).animate().fadeIn(delay: 500.ms).scale(delay: 500.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientButton(String text,
      {IconData? icon, VoidCallback? onTap}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7B3FF2), Color(0xFFB65FFF)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7B3FF2).withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOutlineButton(String text,
      {IconData? icon, VoidCallback? onTap}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar(AuthService authService) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Show user menu  
          showMenu(
            context: context,
            position: const RelativeRect.fromLTRB(100, 80, 0, 0),
            items: [
              PopupMenuItem(
                child: const Text('Profile'),
                onTap: () {},
              ),
              PopupMenuItem(
                child: const Text('Settings'),
                onTap: () {},
              ),
              PopupMenuItem(
                child: const Text('Logout'),
                onTap: () => authService.signOut(),
              ),
            ],
          );
        },
        child: Row(
          children: [
            Text(
              authService.user?.displayName?.split(' ').first ?? 'User',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 20,
              backgroundImage: authService.user?.photoURL != null
                  ? NetworkImage(authService.user!.photoURL!)
                  : null,
              backgroundColor: const Color(0xFF7B3FF2),
              child: authService.user?.photoURL == null
                  ? const Icon(Icons.person, color: Colors.white, size: 20)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String text;

  const _NavLink(this.text);

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _isHovered = false;

  void _handleNavigation() {
    switch (widget.text) {
      case 'Home':
        Navigator.pushNamed(context, '/');
        break;
      case 'Features':
        Navigator.pushNamed(context, '/features');
        break;
      case 'Tokenomics':
        Navigator.pushNamed(context, '/tokenomics');
        break;
      case 'Roadmap':
        Navigator.pushNamed(context, '/roadmap');
        break;
      case 'Docs':
        // TODO: Add docs page or external link
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _handleNavigation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.text,
              style: TextStyle(
                color: _isHovered ? Colors.white : Colors.white.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              width: _isHovered ? 40 : 0,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7B3FF2), Color(0xFFB65FFF)],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
