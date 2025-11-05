import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';
import '../services/wallet_service.dart';
import '../services/contract_service.dart';
import '../services/sound_service.dart';
import '../theme/cyberpunk_theme.dart';
import 'holographic_card.dart';
import 'particles_background.dart';
import 'confetti_animation.dart';

class CyberpunkDonationModal extends StatefulWidget {
  const CyberpunkDonationModal({super.key});

  @override
  State<CyberpunkDonationModal> createState() => _CyberpunkDonationModalState();
}

class _CyberpunkDonationModalState extends State<CyberpunkDonationModal>
    with TickerProviderStateMixin {
  final _amountController = TextEditingController();
  final SoundService _soundService = SoundService();
  bool _isProcessing = false;
  bool _showConfetti = false;
  late AnimationController _pulseController;
  late AnimationController _scanlineController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scanlineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _pulseController.dispose();
    _scanlineController.dispose();
    super.dispose();
  }

  Future<void> _handleDonate() async {
    if (_amountController.text.isEmpty) return;

    _soundService.playButtonClick();

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

      // Success effects
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 200);
      }

      setState(() => _showConfetti = true);

      // Wait for confetti animation
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.rocket_launch, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '🎉 Donation sent! You\'re making a difference!',
                    style: CyberpunkTheme.neonText(Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
            backgroundColor: CyberpunkTheme.neonGreen.withOpacity(0.9),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(pattern: [0, 100, 100, 100]);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('⚠️ Error: ${e.toString()}'),
            backgroundColor: CyberpunkTheme.neonPink.withOpacity(0.9),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Widget _buildImpactPreview() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: amount > 0 ? 100 : 0,
      child: amount > 0
          ? Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    CyberpunkTheme.neonCyan.withOpacity(0.1),
                    CyberpunkTheme.neonPurple.withOpacity(0.1),
                  ],
                ),
                border: Border.all(
                  color: CyberpunkTheme.neonCyan.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💫 Your Impact',
                    style: CyberpunkTheme.neonText(
                      CyberpunkTheme.neonCyan,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Can provide ${(amount * 50).toStringAsFixed(0)} meals to children\n'
                    '• Supports ${(amount * 10).toStringAsFixed(0)} families for a day\n'
                    '• Helps ${(amount * 5).toStringAsFixed(0)} students with education',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: -0.2)
          : const SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // Particle background
          ParticleBackground(
            child: HolographicCard(
              width: 420,
              height: 680,
              child: Stack(
                children: [
                  // Scanline effect
                  AnimatedBuilder(
                    animation: _scanlineController,
                    builder: (context, child) {
                      return Positioned(
                        top: _scanlineController.value * 680,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                CyberpunkTheme.neonCyan.withOpacity(0.5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Main content
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                AnimatedBuilder(
                                  animation: _pulseController,
                                  builder: (context, child) {
                                    return Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        gradient: CyberpunkTheme.cyberpunkGradient,
                                        borderRadius: BorderRadius.circular(14),
                                        boxShadow: CyberpunkTheme.multiColorGlow(),
                                      ),
                                      child: Icon(
                                        Icons.auto_awesome,
                                        color: Colors.white,
                                        size: 24,
                                        shadows: [
                                          Shadow(
                                            color: Colors.white.withOpacity(0.8),
                                            blurRadius: 10 + _pulseController.value * 10,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'CYBER DONATE',
                                      style: CyberpunkTheme.neonText(
                                        CyberpunkTheme.neonPink,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Text(
                                      'Blockchain Secured',
                                      style: TextStyle(
                                        color: CyberpunkTheme.neonCyan.withOpacity(0.7),
                                        fontSize: 11,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: CyberpunkTheme.neonPink.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: CyberpunkTheme.neonPink.withOpacity(0.5),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: CyberpunkTheme.neonPink,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ).animate().fadeIn().slideX(begin: -0.2),

                        const SizedBox(height: 32),

                        // Amount input
                        Text(
                          '⚡ AMOUNT (ETH)',
                          style: CyberpunkTheme.neonText(
                            CyberpunkTheme.neonYellow,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: CyberpunkTheme.neonGlow(CyberpunkTheme.neonCyan, intensity: 0.3),
                          ),
                          child: TextField(
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            style: CyberpunkTheme.neonText(Colors.white, fontSize: 24),
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: '0.0',
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.2),
                                fontSize: 24,
                              ),
                              filled: true,
                              fillColor: CyberpunkTheme.darkBg2,
                              prefixIcon: Icon(
                                Icons.currency_bitcoin,
                                color: CyberpunkTheme.neonYellow,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: CyberpunkTheme.neonCyan.withOpacity(0.5),
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: CyberpunkTheme.neonCyan.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: CyberpunkTheme.neonCyan,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, delay: 100.ms),

                        const SizedBox(height: 20),

                        // Quick amounts
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: ['0.1', '0.5', '1.0', '5.0'].map((amount) {
                            return MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () async {
                                  if (await Vibration.hasVibrator() ?? false) {
                                    Vibration.vibrate(duration: 30);
                                  }
                                  _soundService.playButtonClick();
                                  setState(() {
                                    _amountController.text = amount;
                                  });
                                },
                                child: AnimatedBuilder(
                                  animation: _pulseController,
                                  builder: (context, child) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            CyberpunkTheme.neonPurple.withOpacity(0.2),
                                            CyberpunkTheme.neonPink.withOpacity(0.2),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: CyberpunkTheme.neonPurple.withOpacity(0.5),
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: CyberpunkTheme.neonPurple.withOpacity(0.3),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        '$amount ETH',
                                        style: CyberpunkTheme.neonText(
                                          CyberpunkTheme.neonPurple,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        ).animate().fadeIn(delay: 200.ms),

                        // Impact preview
                        _buildImpactPreview(),

                        const Spacer(),

                        // Donate button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isProcessing ? null : _handleDonate,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: CyberpunkTheme.cyberpunkGradient,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: CyberpunkTheme.multiColorGlow(),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                child: _isProcessing
                                    ? SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.rocket_launch, color: Colors.white),
                                          const SizedBox(width: 12),
                                          Text(
                                            'SEND DONATION',
                                            style: CyberpunkTheme.neonText(
                                              Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3, delay: 300.ms),

                        const SizedBox(height: 16),

                        // Trust indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildTrustBadge(Icons.verified_user, 'Secure'),
                            const SizedBox(width: 16),
                            _buildTrustBadge(Icons.public, 'Transparent'),
                            const SizedBox(width: 16),
                            _buildTrustBadge(Icons.flash_on, 'Instant'),
                          ],
                        ).animate().fadeIn(delay: 400.ms),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Confetti overlay
          if (_showConfetti)
            Positioned.fill(
              child: ConfettiAnimation(
                onComplete: () {
                  setState(() => _showConfetti = false);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTrustBadge(IconData icon, String label) {
    return Column(
      children: [
        Icon(
          icon,
          color: CyberpunkTheme.neonGreen,
          size: 16,
          shadows: CyberpunkTheme.neonGlow(CyberpunkTheme.neonGreen),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
