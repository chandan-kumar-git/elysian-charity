import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/contract_service.dart';
import '../services/wallet_service.dart';

class DonationModal extends StatefulWidget {
  const DonationModal({super.key});

  @override
  State<DonationModal> createState() => _DonationModalState();
}

class _DonationModalState extends State<DonationModal> {
  final _amountController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  
  final List<String> _quickAmounts = ['0.1', '0.5', '1.0', '2.5'];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: 340,
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
                          colors: [Color(0xFF4ade80), Color(0xFF16a34a)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.favorite,
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
                            'Make a Donation',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Support our cause with ETH',
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
              
              // Amount Input Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Amount (ETH)',
                      style: TextStyle(
                        color: Color(0xFF9ca3af),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Amount Input
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
              
              const SizedBox(height: 20),
              
              // Quick Amount Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick amounts',
                      style: TextStyle(
                        color: Color(0xFF9ca3af),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _quickAmounts.map((amount) {
                        final isSelected = _amountController.text == amount;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _amountController.text = amount;
                              _errorMessage = null;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? const Color(0xFF4ade80).withOpacity(0.1)
                                  : const Color(0xFF171717),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isSelected 
                                    ? const Color(0xFF4ade80)
                                    : const Color(0xFF262626),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '$amount ETH',
                              style: TextStyle(
                                color: isSelected 
                                    ? const Color(0xFF4ade80)
                                    : const Color(0xFF9ca3af),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
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
                        onPressed: _isLoading ? null : _handleDonation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4ade80),
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
                                'Donate Now',
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

  Future<void> _handleDonation() async {
    final amount = _amountController.text.trim();
    
    // Validation
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
    
    if (parsedAmount > 100) {
      setState(() {
        _errorMessage = 'Amount too large';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final contractService = context.read<ContractService>();
      final walletService = context.read<WalletService>();
      
      // Check wallet connection
      if (!walletService.isConnected) {
        throw Exception('Wallet not connected');
      }
      
      // Process donation
      final success = await contractService.donate(amount);
      
      if (success) {
        if (mounted) {
          Navigator.of(context).pop(); // Close modal
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Successfully donated $amount ETH!'),
              backgroundColor: const Color(0xFF4ade80),
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