import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math' as math;
import '../services/contract_service.dart';
import '../services/wallet_service.dart';

class EnhancedBalanceCard extends StatelessWidget {
  final VoidCallback onDonate;
  final VoidCallback onViewExplorer;

  const EnhancedBalanceCard({
    super.key,
    required this.onDonate,
    required this.onViewExplorer,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<ContractService, WalletService>(
      builder: (context, contract, wallet, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF7c3aed),
                Color(0xFF6d28d9),
                Color(0xFF5b21b6),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7c3aed).withOpacity(0.5),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Glassmorphism overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                  ),
                ),
              ),

              // 3D Floating Coin (ProfitPilot)
              Positioned(
                top: -30,
                right: -30,
                child: _FloatingCoin(),
              ),

              // Main content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with verified badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Contract Balance',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Verified badge (FluxChain)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF22c55e).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF22c55e),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.verified,
                                  color: Color(0xFF22c55e),
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'VERIFIED',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ).animate(onPlay: (controller) => controller.repeat())
                              .shimmer(
                                duration: 3000.ms,
                                color: const Color(0xFF22c55e).withOpacity(0.3),
                              ),
                        ],
                      ),
                      
                      // Risk badge (DeFi Protocol)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[400]?.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue[400]!,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.shield_outlined,
                              color: Colors.blue[300],
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'LOW RISK',
                              style: TextStyle(
                                color: Colors.blue[200],
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Balance display
                  if (contract.isLoading)
                    _buildLoadingState()
                  else
                    _buildBalanceDisplay(contract.balance),

                  const SizedBox(height: 8),

                  // USD value estimate
                  Text(
                    '≈ \$${contract.estimatedUsdValue}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Stats row (DeFi Protocol style)
                  _buildStatsRow(contract),

                  const SizedBox(height: 20),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          label: 'Donate',
                          icon: Icons.favorite,
                          onTap: wallet.isConnected ? onDonate : null,
                          isPrimary: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          label: 'Explorer',
                          icon: Icons.open_in_new,
                          onTap: onViewExplorer,
                          isPrimary: false,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ).animate()
            .scale(duration: 400.ms, curve: Curves.easeOut)
            .fadeIn(duration: 400.ms);
      },
    );
  }

  Widget _buildLoadingState() {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.3),
      highlightColor: Colors.white.withOpacity(0.6),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 60,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceDisplay(String balance) {
    return Row(
      children: [
        // Golden glow icon (ProfitPilot)
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFfbbf24),
                Color(0xFFf59e0b),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFfbbf24).withOpacity(0.6),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.account_balance_wallet,
            color: Colors.white,
            size: 24,
          ),
        ).animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 2000.ms)
            .scale(
              duration: 2000.ms,
              begin: const Offset(1, 1),
              end: const Offset(1.1, 1.1),
            ),
        
        const SizedBox(width: 16),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedFlipCounter(
                value: double.tryParse(balance) ?? 0.0,
                duration: const Duration(milliseconds: 800),
                fractionDigits: 3,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ).animate()
                  .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.3)),
              Text(
                'ETH',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(ContractService contract) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            label: '24h Volume',
            value: '${contract.dailyVolume} ETH',
            icon: Icons.trending_up,
            color: const Color(0xFF22c55e),
          ),
          Container(
            width: 1,
            height: 30,
            color: Colors.white.withOpacity(0.2),
          ),
          _buildStatItem(
            label: 'APY',
            value: '${contract.apy}%',
            icon: Icons.show_chart,
            color: const Color(0xFFfbbf24),
          ),
          Container(
            width: 1,
            height: 30,
            color: Colors.white.withOpacity(0.2),
          ),
          _buildStatItem(
            label: 'TVL',
            value: '\$${contract.tvl}',
            icon: Icons.account_balance,
            color: Colors.blue[400]!,
          ),
        ],
      ),
    ).animate()
        .fadeIn(delay: 200.ms, duration: 400.ms)
        .slideX(begin: -0.1, end: 0);
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback? onTap,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isPrimary
              ? Colors.white
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: !isPrimary
              ? Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                )
              : null,
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isPrimary
                  ? const Color(0xFF7c3aed)
                  : Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isPrimary
                    ? const Color(0xFF7c3aed)
                    : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ).animate(onPlay: (controller) {
      if (onTap != null) {
        controller.repeat();
      }
    }).shimmer(
          duration: 3000.ms,
          color: isPrimary
              ? Colors.white.withOpacity(0.3)
              : Colors.transparent,
        );
  }
}

// 3D Floating Coin Widget (ProfitPilot)
class _FloatingCoin extends StatefulWidget {
  @override
  State<_FloatingCoin> createState() => _FloatingCoinState();
}

class _FloatingCoinState extends State<_FloatingCoin>
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final angle = _controller.value * 2 * math.pi;
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle)
            ..rotateX(math.sin(angle) * 0.3),
          alignment: Alignment.center,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFfbbf24),
                  Color(0xFFf59e0b),
                  Color(0xFFd97706),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFfbbf24).withOpacity(0.6),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Ξ',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 60,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}