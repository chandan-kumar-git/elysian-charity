import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';
import '../services/wallet_service.dart';
import '../services/contract_service.dart';
import '../services/sound_service.dart';

class DonationModal extends StatefulWidget {
  const DonationModal({super.key});

  @override
  State<DonationModal> createState() => _DonationModalState();
}

class _DonationModalState extends State<DonationModal> {
  final _amountController = TextEditingController();
  final SoundService _soundService = SoundService();
  bool _isProcessing = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _handleDonate() async {
    if (_amountController.text.isEmpty) return;

    // Play click sound
    _soundService.playButtonClick();
    
    // Haptic feedback on button press
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 100);
    }

    setState(() => _isProcessing = true);

    try {
      final walletService = context.read<WalletService>();
      final contractService = context.read<ContractService>();
      
      await contractService.donate(
        _amountController.text,
        walletService.currentAddress!,
      );

      // Success haptic feedback
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 200);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Donation sent successfully!'),
            backgroundColor: Color(0xFF22c55e),
          ),
        );
      }
    } catch (e) {
      // Error haptic feedback
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(pattern: [0, 100, 100, 100]);
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: const Color(0xFFf43f5e),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0f172a),
              Color(0xFF1e293b),
            ],
          ),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFf43f5e), Color(0xFFfbbf24)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Make a Donation',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Amount (ETH)',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                hintText: '0.0',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF7c3aed),
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: ['0.1', '0.5', '1.0', '5.0'].map((amount) {
                return GestureDetector(
                  onTap: () async {
                    // Haptic feedback
                    if (await Vibration.hasVibrator() ?? false) {
                      Vibration.vibrate(duration: 50);
                    }
                    _amountController.text = amount;
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      '$amount ETH',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ).animate()
                      .scale(duration: 200.ms, curve: Curves.easeOut),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _handleDonate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7c3aed),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Send Donation',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ).animate()
          .scale(duration: 300.ms, curve: Curves.easeOut)
          .fadeIn(duration: 300.ms),
    );
  }
}