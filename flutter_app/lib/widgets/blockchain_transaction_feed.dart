import 'package:flutter/material.dart';
import 'dart:math' as math;

class BlockchainTransactionFeed extends StatefulWidget {
  const BlockchainTransactionFeed({Key? key}) : super(key: key);

  @override
  State<BlockchainTransactionFeed> createState() => _BlockchainTransactionFeedState();
}

class _BlockchainTransactionFeedState extends State<BlockchainTransactionFeed> {
  final List<BlockchainTransaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    _addTransaction();
  }

  void _addTransaction() {
    if (mounted) {
      final random = math.Random();
      setState(() {
        _transactions.insert(
          0,
          BlockchainTransaction(
            hash: _generateHash(),
            amount: random.nextInt(900) + 100,
            confirmations: random.nextInt(6) + 1,
          ),
        );
        if (_transactions.length > 4) {
          _transactions.removeLast();
        }
      });
      Future.delayed(Duration(seconds: random.nextInt(4) + 3), _addTransaction);
    }
  }

  String _generateHash() {
    const chars = '0123456789abcdef';
    final random = math.Random();
    return '0x' + List.generate(40, (index) => chars[random.nextInt(chars.length)]).join();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.cyan.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.link, color: Colors.cyan, size: 24),
              const SizedBox(width: 12),
              const Text(
                'Live Blockchain Transactions',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ..._transactions.map((tx) => _buildTransactionItem(tx)).toList(),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(BlockchainTransaction tx) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset((1 - value) * 50, 0),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.cyan.withOpacity(0.2),
                    Colors.blue.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.cyan.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Text(
                          '${tx.confirmations} confirmations',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '\$${tx.amount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tx.hash,
                    style: TextStyle(
                      color: Colors.cyan.withOpacity(0.8),
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class BlockchainTransaction {
  final String hash;
  final int amount;
  final int confirmations;

  BlockchainTransaction({
    required this.hash,
    required this.amount,
    required this.confirmations,
  });
}
