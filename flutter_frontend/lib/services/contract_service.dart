import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ContractService extends ChangeNotifier {
  // Contract data
  String _contractBalance = '25.567';
  String _lifetimeDonations = '142.340';
  String _usdEstimate = '63,918';
  
  List<Transaction> _transactions = [
    Transaction(
      id: '1',
      type: TransactionType.donation,
      address: '0x742d35Cc6634C0532925a3b8D093b3F2bFC2c5b9',
      amount: '5.20',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      txHash: '0xabcd...1234',
    ),
    Transaction(
      id: '2',
      type: TransactionType.donation,
      address: '0x8ba1f109551bD432803012645Hac136c39C40',
      amount: '2.25',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      txHash: '0xefgh...5678',
    ),
    Transaction(
      id: '3',
      type: TransactionType.withdrawal,
      address: '0x123d35Cc6634C0532925a3b8D093b3F2bFC2987',
      amount: '1.40',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      txHash: '0xijkl...9012',
    ),
    Transaction(
      id: '4',
      type: TransactionType.donation,
      address: '0x9f8b64dd61d0396f79e54c9a2de68132b1f4f671',
      amount: '3.80',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      txHash: '0xmnop...3456',
    ),
  ];

  // Getters
  String get contractBalance => _contractBalance;
  String get lifetimeDonations => _lifetimeDonations;
  String get usdEstimate => _usdEstimate;
  List<Transaction> get transactions => List.unmodifiable(_transactions);
  List<Transaction> get transactionPreview => _transactions.take(3).toList();

  // Contract constants
  static const String contractAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3';
  static const String ownerAddress = '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266';

  Future<bool> donate(String amount) async {
    try {
      // Simulate donation transaction
      await Future.delayed(const Duration(seconds: 2));
      
      final double donationAmount = double.tryParse(amount) ?? 0.0;
      final double currentBalance = double.tryParse(_contractBalance) ?? 0.0;
      final double currentLifetime = double.tryParse(_lifetimeDonations) ?? 0.0;
      
      // Update balances
      _contractBalance = (currentBalance + donationAmount).toStringAsFixed(3);
      _lifetimeDonations = (currentLifetime + donationAmount).toStringAsFixed(3);
      _usdEstimate = ((currentBalance + donationAmount) * 2500).toStringAsFixed(0);
      
      // Add new transaction
      final newTransaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: TransactionType.donation,
        address: '0x742d35Cc6634C0532925a3b8D093b3F2bFC2c5b9', // Mock user address
        amount: donationAmount.toStringAsFixed(2),
        timestamp: DateTime.now(),
        txHash: '0x${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}',
      );
      
      _transactions.insert(0, newTransaction);
      
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> withdraw(String amount, String recipient) async {
    try {
      // Simulate withdrawal transaction
      await Future.delayed(const Duration(seconds: 2));
      
      final double withdrawalAmount = double.tryParse(amount) ?? 0.0;
      final double currentBalance = double.tryParse(_contractBalance) ?? 0.0;
      
      if (withdrawalAmount > currentBalance) {
        return false; // Insufficient funds
      }
      
      // Update balance
      _contractBalance = (currentBalance - withdrawalAmount).toStringAsFixed(3);
      _usdEstimate = ((currentBalance - withdrawalAmount) * 2500).toStringAsFixed(0);
      
      // Add new transaction
      final newTransaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: TransactionType.withdrawal,
        address: recipient,
        amount: withdrawalAmount.toStringAsFixed(2),
        timestamp: DateTime.now(),
        txHash: '0x${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}',
      );
      
      _transactions.insert(0, newTransaction);
      
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> refreshData() async {
    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
  }

  String formatFiatEstimate(String ethAmount) {
    final double parsed = double.tryParse(ethAmount) ?? 0.0;
    final double usdValue = parsed * 2500;
    return '\$${usdValue.toStringAsFixed(2)}';
  }
}

enum TransactionType { donation, withdrawal }

class Transaction {
  final String id;
  final TransactionType type;
  final String address;
  final String amount;
  final DateTime timestamp;
  final String txHash;

  Transaction({
    required this.id,
    required this.type,
    required this.address,
    required this.amount,
    required this.timestamp,
    required this.txHash,
  });

  String get typeLabel {
    switch (type) {
      case TransactionType.donation:
        return 'Donation';
      case TransactionType.withdrawal:
        return 'Disbursement';
    }
  }

  String get amountPrefix {
    switch (type) {
      case TransactionType.donation:
        return '+';
      case TransactionType.withdrawal:
        return '-';
    }
  }

  Color get amountColor {
    switch (type) {
      case TransactionType.donation:
        return const Color(0xFF4ade80); // green-400
      case TransactionType.withdrawal:
        return const Color(0xFFfb923c); // orange-400
    }
  }
}