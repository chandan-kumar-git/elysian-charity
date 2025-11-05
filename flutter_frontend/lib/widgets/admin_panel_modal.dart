import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/contract_service.dart';
import '../services/wallet_service.dart';

class AdminPanelModal extends StatefulWidget {
  const AdminPanelModal({super.key});

  @override
  State<AdminPanelModal> createState() => _AdminPanelModalState();
}

class _AdminPanelModalState extends State<AdminPanelModal> {
  final _amountController = TextEditingController();
  final _recipientController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _amountController.dispose();
    _recipientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: 360,
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                          colors: [Color(0xFFfb923c), Color(0xFFea580c)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings,
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
                            'Admin Panel',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Withdraw funds from contract',
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
              
              // Contract Balance Display
              Consumer<ContractService>(
                builder: (context, contractService, child) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF171717),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF262626),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4ade80).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.account_balance,
                            color: Color(0xFF4ade80),
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Available Balance',
                              style: TextStyle(
                                color: Color(0xFF9ca3af),
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${contractService.contractBalance} ETH',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          contractService.formatFiatEstimate(contractService.contractBalance),
                          style: const TextStyle(
                            color: Color(0xFF6b7280),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 20),
              
              // Recipient Address Input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recipient Address',
                      style: TextStyle(
                        color: Color(0xFF9ca3af),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF171717),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _errorMessage != null 
                              ? const Color(0xFFef4444) 
                              : const Color(0xFF262626),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _recipientController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          hintText: '0x...',
                          hintStyle: TextStyle(
                            color: Color(0xFF4b5563),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                        onChanged: (_) {
                          if (_errorMessage != null) {
                            setState(() {
                              _errorMessage = null;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Amount Input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Amount (ETH)',
                          style: TextStyle(
                            color: Color(0xFF9ca3af),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Consumer<ContractService>(
                          builder: (context, contractService, child) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _amountController.text = contractService.contractBalance;
                                  _errorMessage = null;
                                });
                              },
                              child: const Text(
                                'Max',
                                style: TextStyle(
                                  color: Color(0xFFfb923c),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF171717),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _errorMessage != null 
                              ? const Color(0xFFef4444) 
                              : const Color(0xFF262626),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _amountController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: const InputDecoration(
                          hintText: '0.00',
                          hintStyle: TextStyle(
                            color: Color(0xFF4b5563),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                          suffixText: 'ETH',
                          suffixStyle: TextStyle(
                            color: Color(0xFF9ca3af),
                            fontSize: 14,
                          ),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                        ],
                        onChanged: (_) {
                          if (_errorMessage != null) {
                            setState(() {
                              _errorMessage = null;
                            });
                          }
                        },
                      ),
                    ),
                    
                    // USD Estimate
                    if (_amountController.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Consumer<ContractService>(
                          builder: (context, contractService, child) {
                            final usdEstimate = contractService.formatFiatEstimate(_amountController.text);
                            return Text(
                              '≈ $usdEstimate USD',
                              style: const TextStyle(
                                color: Color(0xFF6b7280),
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                    
                    // Error Message
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Color(0xFFef4444),
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Action Buttons
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF9ca3af),
                          side: const BorderSide(
                            color: Color(0xFF262626),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleWithdrawal,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFfb923c),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Withdraw',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
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

  Future<void> _handleWithdrawal() async {
    final amount = _amountController.text.trim();
    final recipient = _recipientController.text.trim();
    
    // Validation
    if (recipient.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter recipient address';
      });
      return;
    }
    
    if (!recipient.startsWith('0x') || recipient.length != 42) {
      setState(() {
        _errorMessage = 'Invalid Ethereum address';
      });
      return;
    }
    
    if (amount.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter an amount';
      });
      return;
    }
    
    final parsedAmount = double.tryParse(amount);
    if (parsedAmount == null || parsedAmount <= 0) {
      setState(() {
        _errorMessage = 'Please enter a valid amount';
      });
      return;
    }
    
    final contractService = context.read<ContractService>();
    final availableBalance = double.tryParse(contractService.contractBalance) ?? 0.0;
    
    if (parsedAmount > availableBalance) {
      setState(() {
        _errorMessage = 'Insufficient contract balance';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final walletService = context.read<WalletService>();
      
      // Check wallet connection and admin access
      if (!walletService.isConnected) {
        throw Exception('Wallet not connected');
      }
      
      if (!walletService.isAdmin) {
        throw Exception('Admin access required');
      }
      
      // Process withdrawal
      final success = await contractService.withdraw(amount, recipient);
      
      if (success) {
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Successfully withdrew $amount ETH!'),
              backgroundColor: const Color(0xFFfb923c),
            ),
          );
        }
      } else {
        throw Exception('Transaction failed');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}