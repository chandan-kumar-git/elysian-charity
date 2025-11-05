import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/contract_service.dart';

class TransactionLedgerModal extends StatelessWidget {
  const TransactionLedgerModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: 400,
          height: 500,
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF0c0c0c),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF262626),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3b82f6), Color(0xFF1d4ed8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.receipt_long,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Transaction History',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'All contract transactions',
                            style: TextStyle(
                              color: Color(0xFF9ca3af),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFF9ca3af),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Transaction List
              Expanded(
                child: Consumer<ContractService>(
                  builder: (context, contractService, child) {
                    final transactions = contractService.transactions;
                    
                    if (transactions.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              color: Color(0xFF4b5563),
                              size: 48,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No transactions yet',
                              style: TextStyle(
                                color: Color(0xFF6b7280),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: transactions.length,
                      separatorBuilder: (context, index) => const Divider(
                        color: Color(0xFF262626),
                        height: 1,
                      ),
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return TransactionTile(transaction: transaction);
                      },
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ).animate().fadeIn(duration: 300.ms).scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
          duration: 300.ms,
          curve: Curves.easeOutBack,
        ),
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  
  const TransactionTile({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Transaction Type Icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: transaction.amountColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              transaction.type == TransactionType.donation
                  ? Icons.favorite
                  : Icons.arrow_upward,
              color: transaction.amountColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          
          // Transaction Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      transaction.typeLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${transaction.amountPrefix}${transaction.amount} ETH',
                      style: TextStyle(
                        color: transaction.amountColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _copyToClipboard(context, transaction.address),
                        child: Text(
                          _formatAddress(transaction.address),
                          style: const TextStyle(
                            color: Color(0xFF9ca3af),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      _formatTime(transaction.timestamp),
                      style: const TextStyle(
                        color: Color(0xFF6b7280),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => _copyToClipboard(context, transaction.txHash),
                  child: Text(
                    'Tx: ${_formatHash(transaction.txHash)}',
                    style: const TextStyle(
                      color: Color(0xFF6b7280),
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatAddress(String address) {
    if (address.length <= 10) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }

  String _formatHash(String hash) {
    if (hash.length <= 10) return hash;
    return '${hash.substring(0, 6)}...${hash.substring(hash.length - 4)}';
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        backgroundColor: Color(0xFF3b82f6),
        duration: Duration(seconds: 1),
      ),
    );
  }
}