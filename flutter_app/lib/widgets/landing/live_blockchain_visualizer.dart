import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import 'dart:async';

class LiveBlockchainVisualizer extends StatefulWidget {
  const LiveBlockchainVisualizer({Key? key}) : super(key: key);

  @override
  State<LiveBlockchainVisualizer> createState() => _LiveBlockchainVisualizerState();
}

class _LiveBlockchainVisualizerState extends State<LiveBlockchainVisualizer>
    with TickerProviderStateMixin {
  final List<Transaction> _transactions = [];
  Timer? _transactionTimer;
  late AnimationController _pulseController;
  int _blockCount = 18456234;
  int _tps = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _startTransactionSimulation();
  }

  @override
  void dispose() {
    _transactionTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startTransactionSimulation() {
    // Add initial transactions
    for (int i = 0; i < 5; i++) {
      _addTransaction();
    }

    // Add new transaction every 1-3 seconds
    _transactionTimer = Timer.periodic(
      const Duration(milliseconds: 1500),
      (timer) {
        if (mounted) {
          setState(() {
            _addTransaction();
            if (_transactions.length > 8) {
              _transactions.removeAt(0);
            }
            _blockCount++;
            _tps = 50 + math.Random().nextInt(150);
          });
        }
      },
    );
  }

  void _addTransaction() {
    final random = math.Random();
    final types = ['Donation', 'Transfer', 'Swap', 'Stake'];
    final amounts = [0.1, 0.5, 1.0, 2.5, 5.0, 10.0];

    _transactions.add(Transaction(
      hash: _generateHash(),
      type: types[random.nextInt(types.length)],
      amount: amounts[random.nextInt(amounts.length)],
      from: _generateAddress(),
      to: _generateAddress(),
      timestamp: DateTime.now(),
    ));
  }

  String _generateHash() {
    final random = math.Random();
    return '0x${List.generate(8, (_) => random.nextInt(16).toRadixString(16)).join()}...';
  }

  String _generateAddress() {
    final random = math.Random();
    return '0x${List.generate(4, (_) => random.nextInt(16).toRadixString(16)).join()}...${List.generate(4, (_) => random.nextInt(16).toRadixString(16)).join()}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.8),
            const Color(0xFF0A0E27).withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF7B3FF2).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B3FF2).withOpacity(0.2),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF00FF88),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00FF88).withOpacity(
                                    0.5 + _pulseController.value * 0.5,
                                  ),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'LIVE BLOCKCHAIN',
                        style: TextStyle(
                          color: Color(0xFF00FF88),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ethereum Network',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              
              // Network Stats
              Row(
                children: [
                  _buildStatBadge('Block', '#$_blockCount'),
                  const SizedBox(width: 16),
                  _buildStatBadge('TPS', '$_tps'),
                ],
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Transaction Feed Title
          const Text(
            'Recent Transactions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Transaction List
          Expanded(
            child: ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final tx = _transactions[_transactions.length - 1 - index];
                return _TransactionCard(
                  transaction: tx,
                  delay: index * 50,
                ).animate().fadeIn().slideX(begin: 0.3);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
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
}

class Transaction {
  final String hash;
  final String type;
  final double amount;
  final String from;
  final String to;
  final DateTime timestamp;

  Transaction({
    required this.hash,
    required this.type,
    required this.amount,
    required this.from,
    required this.to,
    required this.timestamp,
  });
}

class _TransactionCard extends StatefulWidget {
  final Transaction transaction;
  final int delay;

  const _TransactionCard({
    required this.transaction,
    required this.delay,
  });

  @override
  State<_TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<_TransactionCard> {
  bool _isHovered = false;

  Color _getTypeColor() {
    switch (widget.transaction.type) {
      case 'Donation':
        return const Color(0xFF00FF88);
      case 'Transfer':
        return const Color(0xFF00D9FF);
      case 'Swap':
        return const Color(0xFFFF6B9D);
      case 'Stake':
        return const Color(0xFFFFA500);
      default:
        return Colors.white;
    }
  }

  IconData _getTypeIcon() {
    switch (widget.transaction.type) {
      case 'Donation':
        return Icons.favorite;
      case 'Transfer':
        return Icons.send;
      case 'Swap':
        return Icons.swap_horiz;
      case 'Stake':
        return Icons.lock;
      default:
        return Icons.receipt;
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _getTypeColor();
    final now = DateTime.now();
    final diff = now.difference(widget.transaction.timestamp);
    final timeAgo = diff.inSeconds < 60
        ? '${diff.inSeconds}s ago'
        : '${diff.inMinutes}m ago';

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isHovered
              ? Colors.white.withOpacity(0.1)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? typeColor.withOpacity(0.5)
                : Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Type Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: typeColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: typeColor.withOpacity(0.5),
                ),
              ),
              child: Icon(
                _getTypeIcon(),
                color: typeColor,
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            // Transaction Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.transaction.type,
                        style: TextStyle(
                          color: typeColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.transaction.from} → ${widget.transaction.to}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.transaction.hash,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),

            // Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${widget.transaction.amount} ETH',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00FF88).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Confirmed',
                    style: TextStyle(
                      color: Color(0xFF00FF88),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
