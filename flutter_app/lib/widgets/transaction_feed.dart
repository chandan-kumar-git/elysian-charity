import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'dart:js' as js;
import '../config/app_config.dart';

class TransactionFeed extends StatelessWidget {
  const TransactionFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF22c55e).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF22c55e),
                        shape: BoxShape.circle,
                      ),
                    ).animate(onPlay: (controller) => controller.repeat())
                        .fadeIn(duration: 1000.ms)
                        .then()
                        .fadeOut(duration: 1000.ms),
                    const SizedBox(width: 6),
                    Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTransactionItems(),
        ],
      ),
    ).animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildTransactionItems() {
    final transactions = [
      {
        'type': 'Donation Received',
        'amount': '+0.5 ETH',
        'time': '2m ago',
        'address': '0x742d...5e89',
        'icon': Icons.favorite,
        'color': const Color(0xFFf43f5e),
      },
      {
        'type': 'Withdrawal',
        'amount': '-1.2 ETH',
        'time': '1h ago',
        'address': '0x9a3c...2d47',
        'icon': Icons.arrow_upward,
        'color': Colors.blue[400]!,
      },
      {
        'type': 'Donation Received',
        'amount': '+0.8 ETH',
        'time': '3h ago',
        'address': '0x1f5b...8c92',
        'icon': Icons.favorite,
        'color': const Color(0xFFf43f5e),
      },
    ];

    return AnimationLimiter(
      child: Column(
        children: transactions.asMap().entries.map((entry) {
          final index = entry.key;
          final tx = entry.value;
          
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildTransactionItem(tx, index),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> tx, int index) {
    final color = tx['color'] as Color;
    
    return GestureDetector(
      onTap: () {
        // Open transaction in block explorer
        try {
          final address = (tx['address'] as String).replaceAll('...', '0000000000000000000000000000');
          final explorerUrl = AppConfig.getAddressUrl(address);
          js.context.callMethod('open', [explorerUrl, '_blank']);
          debugPrint('🔗 Opening transaction: $explorerUrl');
        } catch (e) {
          debugPrint('Error opening transaction: $e');
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                tx['icon'] as IconData,
                color: color,
                size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx['type'] as String,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          tx['address'] as String,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '• ${tx['time']}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    tx['amount'] as String,
                    style: TextStyle(
                      color: (tx['amount'] as String).startsWith('+')
                          ? const Color(0xFF22c55e)
                          : Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Icon(
                    Icons.open_in_new,
                    color: Colors.white.withOpacity(0.3),
                    size: 14,
                  ),
                ],
              ),
            ],
          ),
        ).animate()
            .shimmer(delay: 800.ms, duration: 2000.ms, color: color.withOpacity(0.2)),
    );
  }
}