import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

/// 🎨 ANIMATED BALANCE WIDGET
/// Shows a rolling counter for balance with shimmer effect
class AnimatedBalanceWidget extends StatelessWidget {
  final double balance;
  final String label;
  final String currency;
  
  const AnimatedBalanceWidget({
    super.key,
    required this.balance,
    required this.label,
    this.currency = 'ETH',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9ca3af),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            AnimatedFlipCounter(
              value: balance,
              duration: const Duration(milliseconds: 800),
              suffix: ' $currency',
              fractionDigits: 4,
              textStyle: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    )
    .animate()
    .fadeIn(duration: 600.ms)
    .shimmer(duration: 2000.ms, color: const Color(0xFF7c3aed).withOpacity(0.3));
  }
}

/// 💳 GLOWING TRANSACTION CARD
/// Shows transaction with glowing border effect
class GlowingTransactionCard extends StatelessWidget {
  final String type;
  final String amount;
  final String time;
  final String hash;
  
  const GlowingTransactionCard({
    super.key,
    required this.type,
    required this.amount,
    required this.time,
    required this.hash,
  });

  @override
  Widget build(BuildContext context) {
    final isDonation = type.toLowerCase().contains('donation');
    final color = isDonation ? const Color(0xFF4ade80) : const Color(0xFFfb923c);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0c0c0c),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon with glow
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              isDonation ? Icons.arrow_downward : Icons.arrow_upward,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hash.length > 15 ? '${hash.substring(0, 15)}...' : hash,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
          
          // Amount & Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    )
    .animate()
    .slideX(begin: 1, duration: 400.ms, curve: Curves.easeOutQuart)
    .fadeIn()
    .shimmer(delay: 800.ms, duration: 2000.ms);
  }
}

/// 🔄 SHIMMER LOADING PLACEHOLDER
/// Shows loading skeleton with shimmer effect
class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  
  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF1a1a1a),
      highlightColor: const Color(0xFF2a2a2a),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// 📊 LOADING BALANCE CARD
/// Full card skeleton while data loads
class LoadingBalanceCard extends StatelessWidget {
  const LoadingBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0c0c0c),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF262626)),
      ),
      child: Column(
        children: [
          const ShimmerLoading(width: 200, height: 40),
          const SizedBox(height: 16),
          const ShimmerLoading(width: double.infinity, height: 120),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              ShimmerLoading(width: 80, height: 20),
              ShimmerLoading(width: 80, height: 20),
            ],
          ),
        ],
      ),
    );
  }
}

/// 🎭 TRANSACTION PROGRESS ANIMATION
/// Shows transaction status with animated feedback
class TransactionProgressAnimation extends StatefulWidget {
  final bool isProcessing;
  final bool isSuccess;
  final String? message;
  
  const TransactionProgressAnimation({
    super.key,
    required this.isProcessing,
    this.isSuccess = false,
    this.message,
  });

  @override
  State<TransactionProgressAnimation> createState() => _TransactionProgressAnimationState();
}

class _TransactionProgressAnimationState extends State<TransactionProgressAnimation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated status indicator
          if (widget.isProcessing)
            const SizedBox(
              width: 150,
              height: 150,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7c3aed)),
              ),
            )
            .animate(onPlay: (controller) => controller.repeat())
            .rotate(duration: 2000.ms)
          else if (widget.isSuccess)
            const Icon(
              Icons.check_circle,
              color: Color(0xFF4ade80),
              size: 150,
            )
            .animate()
            .scale(begin: const Offset(0, 0), duration: 600.ms, curve: Curves.elasticOut)
          else
            const Icon(
              Icons.error,
              color: Color(0xFFef4444),
              size: 150,
            )
            .animate()
            .shake(duration: 600.ms),
          
          const SizedBox(height: 24),
          
          // Message
          Text(
            widget.message ?? 
              (widget.isProcessing 
                ? 'Processing transaction...' 
                : widget.isSuccess 
                  ? 'Transaction successful!' 
                  : 'Transaction failed'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          )
          .animate()
          .fadeIn(duration: 400.ms)
          .slideY(begin: 0.3, duration: 400.ms),
          
          if (widget.isProcessing) ...[
            const SizedBox(height: 16),
            Text(
              'Please confirm in MetaMask',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            )
            .animate(onPlay: (controller) => controller.repeat())
            .fadeIn(duration: 800.ms)
            .then()
            .fadeOut(duration: 800.ms),
          ],
        ],
      ),
    );
  }
}

/// 📈 STAGGERED TRANSACTION LIST
/// Animates list items with stagger effect
class StaggeredTransactionList extends StatelessWidget {
  final List<Map<String, String>> transactions;
  
  const StaggeredTransactionList({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final tx = transactions[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: GlowingTransactionCard(
                  type: tx['type'] ?? 'Transaction',
                  amount: tx['amount'] ?? '0 ETH',
                  time: tx['time'] ?? 'Now',
                  hash: tx['hash'] ?? '0x0000...',
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 🎨 GLASSMORPHIC CARD
/// Card with frosted glass effect
class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  
  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: child,
    )
    .animate()
    .fadeIn(duration: 600.ms)
    .slideY(begin: 0.2, duration: 400.ms);
  }
}

/// 💫 USAGE EXAMPLE IN DASHBOARD
/// 
/// ```dart
/// // In your dashboard_screen.dart:
/// 
/// // 1. Replace balance display
/// AnimatedBalanceWidget(
///   balance: contractService.balance,
///   label: 'Contract Balance',
///   currency: 'ETH',
/// )
/// 
/// // 2. Show loading state
/// if (isLoading)
///   LoadingBalanceCard()
/// else
///   EnhancedBalanceCard()
/// 
/// // 3. Use glowing transaction cards
/// StaggeredTransactionList(
///   transactions: [
///     {'type': 'Donation', 'amount': '+0.5 ETH', 'time': '2m ago', 'hash': '0x1234...'},
///     {'type': 'Withdrawal', 'amount': '-1.2 ETH', 'time': '1h ago', 'hash': '0x5678...'},
///   ],
/// )
/// 
/// // 4. Show transaction progress in modal
/// showDialog(
///   context: context,
///   builder: (context) => Dialog(
///     child: TransactionProgressAnimation(
///       isProcessing: _isProcessing,
///       isSuccess: _isSuccess,
///       message: 'Sending 0.5 ETH...',
///     ),
///   ),
/// )
/// 
/// // 5. Wrap cards in glass effect
/// GlassCard(
///   child: Column(
///     children: [
///       Text('Balance'),
///       AnimatedBalanceWidget(...),
///     ],
///   ),
/// )
/// ```
