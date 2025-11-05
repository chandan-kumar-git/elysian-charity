import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/contract_service.dart';
import 'transaction_ledger_modal.dart';

class TransactionPreview extends StatelessWidget {
  const TransactionPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0c0c0c),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF262626),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
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
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Recent Activity',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _showFullLedger(context),
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: Color(0xFF3b82f6),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Transaction List
          Consumer<ContractService>(
            builder: (context, contractService, child) {
              final transactions = contractService.transactionPreview;
              
              if (transactions.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          color: const Color(0xFF4b5563),
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'No transactions yet',
                          style: TextStyle(
                            color: Color(0xFF6b7280),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              return Column(
                children: transactions.map((transaction) {
                  return TransactionPreviewTile(transaction: transaction);
                }).toList(),
              );
            },
          ),
          
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _showFullLedger(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const TransactionLedgerModal(),
    );
  }
}

class TransactionPreviewTile extends StatelessWidget {
  final Transaction transaction;
  
  const TransactionPreviewTile({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Transaction Type Icon
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: transaction.amountColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              transaction.type == TransactionType.donation
                  ? Icons.favorite
                  : Icons.arrow_upward,
              color: transaction.amountColor,
              size: 12,
            ),
          ),
          const SizedBox(width: 8),
          
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
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${transaction.amountPrefix}${transaction.amount} ETH',
                      style: TextStyle(
                        color: transaction.amountColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _copyToClipboard(context, transaction.address),
                        child: Text(
                          _formatAddress(transaction.address),
                          style: const TextStyle(
                            color: Color(0xFF9ca3af),
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      _formatTime(transaction.timestamp),
                      style: const TextStyle(
                        color: Color(0xFF6b7280),
                        fontSize: 10,
                      ),
                    ),
                  ],
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

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
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