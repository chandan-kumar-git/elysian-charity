import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/landing/navbar.dart';
import '../widgets/landing/footer_section.dart';
import '../theme/cyberpunk_theme.dart';

/// How money moves through the ElysianCharity contract. There is no
/// separate platform token: donations are plain ETH held by the contract.
class TokenomicsPage extends StatelessWidget {
  const TokenomicsPage({Key? key}) : super(key: key);

  static const _steps = [
    _FlowStep(
      icon: Icons.volunteer_activism,
      color: CyberpunkTheme.neonCyan,
      title: 'Donate',
      call: 'donate()',
      body: 'Anyone sends ETH to the contract. A DonationReceived event records the donor, amount and time on-chain.',
    ),
    _FlowStep(
      icon: Icons.verified_user,
      color: CyberpunkTheme.neonPurple,
      title: 'Verify',
      call: 'registerNGO()',
      body: 'Only the contract owner can add an NGO address to the verified list. Removals emit NGORemoved.',
    ),
    _FlowStep(
      icon: Icons.account_balance_wallet,
      color: CyberpunkTheme.neonGreen,
      title: 'Disburse',
      call: 'withdrawFunds()',
      body: 'Funds can only go to a verified NGO. Each withdrawal is guarded against re-entrancy and emits FundsWithdrawn.',
    ),
    _FlowStep(
      icon: Icons.manage_search,
      color: CyberpunkTheme.neonYellow,
      title: 'Audit',
      call: 'getDonationStats()',
      body: 'Totals, per-donor contributions and per-NGO withdrawals are public views that anyone can query.',
    ),
  ];

  static const _facts = [
    ['Currency', 'ETH, no platform token'],
    ['Platform fee', 'None taken by the contract'],
    ['Who can withdraw', 'Verified NGOs only, via the owner'],
    ['Emergency', 'emergencyWithdraw() by the owner'],
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final pad = isMobile ? 24.0 : 64.0;

    return Scaffold(
      backgroundColor: CyberpunkTheme.darkBg,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: CryptoNavbar()),

          // Page header
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: pad, vertical: 60),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    CyberpunkTheme.neonCyan.withOpacity(0.1),
                    CyberpunkTheme.neonPurple.withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'FUND FLOW',
                    style: CyberpunkTheme.neonText(
                      CyberpunkTheme.neonCyan,
                      fontSize: isMobile ? 36 : 56,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'EVERY DONATION, FROM WALLET TO NGO, ON-CHAIN',
                    style: TextStyle(
                      color: CyberpunkTheme.neonPurple.withOpacity(0.8),
                      fontSize: isMobile ? 12 : 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Steps
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: pad, vertical: 24),
            sliver: SliverToBoxAdapter(
              child: Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: [
                  for (var i = 0; i < _steps.length; i++)
                    SizedBox(
                      width: isMobile ? double.infinity : 280,
                      child: _StepCard(step: _steps[i], index: i + 1),
                    ).animate().fadeIn(delay: (120 * i).ms).slideY(begin: 0.15),
                ],
              ),
            ),
          ),

          // Facts
          SliverPadding(
            padding: EdgeInsets.fromLTRB(pad, 24, pad, 60),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(isMobile ? 20 : 32),
                decoration: BoxDecoration(
                  color: CyberpunkTheme.darkBg3,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: CyberpunkTheme.neonPurple.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    for (final f in _facts)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                f[0],
                                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                f[1],
                                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: FooterSection()),
        ],
      ),
    );
  }
}

class _FlowStep {
  final IconData icon;
  final Color color;
  final String title;
  final String call;
  final String body;

  const _FlowStep({
    required this.icon,
    required this.color,
    required this.title,
    required this.call,
    required this.body,
  });
}

class _StepCard extends StatelessWidget {
  final _FlowStep step;
  final int index;

  const _StepCard({required this.step, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: CyberpunkTheme.darkBg2,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: step.color.withOpacity(0.4)),
        boxShadow: CyberpunkTheme.neonGlow(step.color, intensity: 0.15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(step.icon, color: step.color, size: 28),
              const Spacer(),
              Text(
                '0$index',
                style: TextStyle(color: step.color.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            step.title,
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            step.call,
            style: TextStyle(color: step.color, fontSize: 13, fontFamily: 'monospace'),
          ),
          const SizedBox(height: 12),
          Text(
            step.body,
            style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}
