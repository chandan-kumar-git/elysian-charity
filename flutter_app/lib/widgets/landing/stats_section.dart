import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../cyberpunk_glitch_text.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 64,
        vertical: 60,
      ),
      padding: EdgeInsets.all(isMobile ? 32 : 64),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF7B3FF2),
            Color(0xFFB65FFF),
          ],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B3FF2).withOpacity(0.4),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          CyberpunkGlitchText(
            text: 'Network Statistics',
            fontSize: isMobile ? 32 : 42,
            isMobile: isMobile,
          ).animate().fadeIn().slideY(begin: 0.2),

          const SizedBox(height: 16),

          Text(
            'Real-time metrics from the Elysian blockchain',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: isMobile ? 14 : 16,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, delay: 200.ms),

          const SizedBox(height: 64),

          LayoutBuilder(
            builder: (context, constraints) {
              final isSmall = constraints.maxWidth < 600;
              return Wrap(
                alignment: WrapAlignment.spaceEvenly,
                spacing: 48,
                runSpacing: 48,
                children: [
                  _StatItem(
                    value: '\$1.2B',
                    label: 'Total Value Locked',
                    icon: Icons.account_balance,
                    delay: 0,
                  ),
                  _StatItem(
                    value: '250K+',
                    label: 'Active Wallets',
                    icon: Icons.people,
                    delay: 100,
                  ),
                  _StatItem(
                    value: '5.2M',
                    label: 'Transactions',
                    icon: Icons.swap_horiz,
                    delay: 200,
                  ),
                  _StatItem(
                    value: '0.001s',
                    label: 'Avg Block Time',
                    icon: Icons.speed,
                    delay: 300,
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 48),

          // Live Transactions Counter
          _LiveCounter()
              .animate()
              .fadeIn(delay: 400.ms)
              .scale(delay: 400.ms),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final int delay;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: Colors.white, size: 40),
        ),
        const SizedBox(height: 16),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delay))
        .slideY(begin: 0.3, delay: Duration(milliseconds: delay));
  }
}

class _LiveCounter extends StatefulWidget {
  const _LiveCounter();

  @override
  State<_LiveCounter> createState() => _LiveCounterState();
}

class _LiveCounterState extends State<_LiveCounter> {
  int _txCount = 5234567;

  @override
  void initState() {
    super.initState();
    // Simulate live transactions
    Future.delayed(const Duration(milliseconds: 500), _incrementCounter);
  }

  void _incrementCounter() {
    if (!mounted) return;
    setState(() => _txCount++);
    Future.delayed(
      Duration(milliseconds: 1000 + (_txCount % 500)),
      _incrementCounter,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: const Color(0xFF00FF88),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00FF88).withOpacity(0.8),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .fadeOut(duration: 1000.ms)
              .then()
              .fadeIn(duration: 1000.ms),
          const SizedBox(width: 12),
          const Text(
            'Live Transactions: ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            NumberFormat('#,###').format(_txCount),
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
}
