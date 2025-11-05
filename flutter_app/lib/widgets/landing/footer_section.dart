import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({Key? key}) : super(key: key);

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 64,
        vertical: 80,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Main Footer Content
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 900) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBrandSection(),
                    const SizedBox(height: 48),
                    _buildLinksSection(),
                    const SizedBox(height: 48),
                    _buildNewsletterSection(),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _buildBrandSection()),
                  const SizedBox(width: 64),
                  Expanded(flex: 3, child: _buildLinksSection()),
                  const SizedBox(width: 64),
                  Expanded(flex: 2, child: _buildNewsletterSection()),
                ],
              );
            },
          ),

          const SizedBox(height: 64),

          // Divider
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.1),
          ),

          const SizedBox(height: 32),

          // Bottom Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© 2025 Elysian Chain. All rights reserved.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 14,
                ),
              ),
              Row(
                children: [
                  _SocialIcon(
                    Icons.link,
                    () => _launchURL('https://www.instagram.com/miyamoto_mushashi75'),
                    tooltip: 'Instagram',
                  ),
                  const SizedBox(width: 16),
                  _SocialIcon(
                    Icons.business,
                    () => _launchURL('https://www.linkedin.com/in/chandan-kumar-80b21928a'),
                    tooltip: 'LinkedIn',
                  ),
                  const SizedBox(width: 16),
                  _SocialIcon(
                    Icons.telegram,
                    () => _launchURL('https://t.me/elysianchain'),
                    tooltip: 'Telegram',
                  ),
                  const SizedBox(width: 16),
                  _SocialIcon(
                    Icons.alternate_email,
                    () => _launchURL('https://twitter.com/elysianchain'),
                    tooltip: 'Twitter/X',
                  ),
                ],
              ),
            ],
          ).animate().fadeIn(delay: 800.ms),
        ],
      ),
    );
  }

  Widget _buildBrandSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
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
              child: const Icon(Icons.bolt, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            const Text(
              'ELYSIAN',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Building the future of decentralized finance with cutting-edge blockchain technology.',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 15,
            height: 1.6,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, delay: 200.ms);
  }

  Widget _buildLinksSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LinkColumn(
          title: 'Product',
          links: ['Features', 'Security', 'Roadmap', 'Token'],
          delay: 300,
        ),
        _LinkColumn(
          title: 'Developers',
          links: ['Documentation', 'API', 'GitHub', 'Support'],
          delay: 400,
        ),
        _LinkColumn(
          title: 'Company',
          links: ['About', 'Blog', 'Careers', 'Contact'],
          delay: 500,
        ),
      ],
    );
  }

  Widget _buildNewsletterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Stay Updated',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Subscribe to our newsletter for the latest updates',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 14,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7B3FF2), Color(0xFFB65FFF)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, delay: 600.ms);
  }
}

class _LinkColumn extends StatelessWidget {
  final String title;
  final List<String> links;
  final int delay;

  const _LinkColumn({
    required this.title,
    required this.links,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        ...links.map((link) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _FooterLink(link),
            )),
      ],
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delay))
        .slideY(begin: 0.2, delay: Duration(milliseconds: delay));
  }
}

class _FooterLink extends StatefulWidget {
  final String text;

  const _FooterLink(this.text);

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: TextStyle(
          color: _isHovered ? Colors.white : Colors.white.withOpacity(0.6),
          fontSize: 14,
        ),
        child: Text(widget.text),
      ),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  const _SocialIcon(this.icon, this.onTap, {this.tooltip});

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip ?? '',
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _isHovered
                  ? const Color(0xFF7B3FF2)
                  : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _isHovered
                    ? const Color(0xFF7B3FF2)
                    : Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(
              widget.icon,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
