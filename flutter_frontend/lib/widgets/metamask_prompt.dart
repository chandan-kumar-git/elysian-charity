import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/wallet_service.dart';

class MetaMaskPrompt extends StatelessWidget {
  const MetaMaskPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: 320,
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
            children: [
              const SizedBox(height: 24),
              
              // MetaMask Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFf59e0b), Color(0xFFd97706)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 32,
                ),
              ).animate().scale(duration: 300.ms),
              
              const SizedBox(height: 16),
              
              // Title
              const Text(
                'MetaMask Required',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Description
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Please install MetaMask browser extension to interact with this donation contract.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF9ca3af),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Install MetaMask Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _openMetaMaskInstall(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFf59e0b),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Install MetaMask',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Refresh Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _checkMetaMask(context),
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
                          'I\'ve Installed It',
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

  void _openMetaMaskInstall(BuildContext context) {
    // In a real app, this would open the MetaMask installation page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening MetaMask installation page...'),
        backgroundColor: Color(0xFFf59e0b),
      ),
    );
  }

  void _checkMetaMask(BuildContext context) {
    final walletService = context.read<WalletService>();
    walletService.checkMetaMaskAvailability();
    
    if (walletService.isMetaMaskAvailable) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('MetaMask not detected. Please try again.'),
          backgroundColor: Color(0xFFef4444),
        ),
      );
    }
  }
}