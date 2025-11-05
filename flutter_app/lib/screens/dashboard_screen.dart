import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:js' as js;
import '../services/wallet_service.dart';
import '../services/contract_service.dart';
import '../services/sound_service.dart';
import '../widgets/phone_container.dart';
import '../widgets/enhanced_balance_card.dart';
import '../widgets/transaction_feed.dart';
import '../widgets/donation_modal.dart';
import '../widgets/cyberpunk_donation_modal.dart';
import '../widgets/admin_panel_modal.dart';
import '../config/app_config.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final SoundService _soundService = SoundService();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkWalletStatus();
    });
  }

  void _checkWalletStatus() {
    final walletService = context.read<WalletService>();
    walletService.checkMetaMaskAvailability();
  }

  void _showDonationModal() {
    _soundService.playButtonClick(); // Play click sound
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const CyberpunkDonationModal(),
    );
  }

  void _showAdminPanel() {
    _soundService.playButtonClick(); // Play click sound
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const AdminPanelModal(),
    );
  }

  void _openBlockExplorer() {
    try {
      final contractAddress = AppConfig.contractAddress;
      final explorerUrl = AppConfig.getAddressUrl(contractAddress);
      
      // Open in new tab using JavaScript
      js.context.callMethod('open', [explorerUrl, '_blank']);
      
      debugPrint('🔗 Opening explorer: $explorerUrl');
      
      // Show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.open_in_new, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Opening Sepolia Etherscan...',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF7c3aed),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error opening explorer: $e');
      
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Could not open block explorer'),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFf43f5e),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF050816),
              Color(0xFF0b0f2b),
              Color(0xFF101747),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Ambient lighting effects
            Positioned(
              top: -100,
              left: MediaQuery.of(context).size.width / 2 - 100,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 100,
                      spreadRadius: 50,
                    ),
                  ],
                ),
              ).animate(onPlay: (controller) => controller.repeat())
                  .fadeIn(duration: 2000.ms)
                  .then()
                  .fadeOut(duration: 2000.ms),
            ),
            Positioned(
              bottom: 0,
              right: 50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.25),
                      blurRadius: 100,
                      spreadRadius: 50,
                    ),
                  ],
                ),
              ).animate(onPlay: (controller) => controller.repeat())
                  .fadeIn(duration: 2000.ms, delay: 1000.ms)
                  .then()
                  .fadeOut(duration: 2000.ms),
            ),

            // Main content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: PhoneContainer(
                    child: Column(
                      children: [
                        // Status bar
                        _buildStatusBar()
                            .animate()
                            .fadeIn(duration: 400.ms),
                        
                        const SizedBox(height: 20),
                        
                        // Header
                        _buildHeader()
                            .animate()
                            .fadeIn(delay: 100.ms, duration: 400.ms)
                            .slideY(begin: -0.2, end: 0),
                        
                        const SizedBox(height: 24),
                        
                        // Enhanced Balance Card with all templates
                        EnhancedBalanceCard(
                          onDonate: _showDonationModal,
                          onViewExplorer: _openBlockExplorer,
                        ).animate()
                            .fadeIn(delay: 200.ms, duration: 400.ms)
                            .slideY(begin: 0.2, end: 0),
                        
                        const SizedBox(height: 20),
                        
                        // Transaction Feed
                        const TransactionFeed()
                            .animate()
                            .fadeIn(delay: 400.ms, duration: 400.ms)
                            .slideY(begin: 0.2, end: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Elysian Chain',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            'EVM',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 11,
              fontWeight: FontWeight.w400,
              letterSpacing: 2.4,
            ),
          ),
          Text(
            'UTC • Live',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ELYSIAN TRANSPARENCY',
                  style: TextStyle(
                    color: Colors.blue[200]?.withOpacity(0.6),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 2.8,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Contract Health',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              // Wallet connector
              Consumer<WalletService>(
                builder: (context, wallet, child) {
                  return GestureDetector(
                    onTap: () {
                      if (!wallet.isConnected) {
                        wallet.connectWallet();
                      }
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: wallet.isConnected
                            ? const Color(0xFF22c55e)
                            : Colors.blue[600],
                        shape: BoxShape.circle,
                        boxShadow: wallet.isConnected
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF22c55e)
                                      .withOpacity(0.5),
                                  blurRadius: 20,
                                ),
                              ]
                            : null,
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet,
                        color: Colors.white,
                        size: 20,
                      ),
                    ).animate(onPlay: (controller) {
                      if (wallet.isConnected) {
                        controller.repeat();
                      }
                    }).scale(
                          duration: 2000.ms,
                          begin: const Offset(1, 1),
                          end: const Offset(1.1, 1.1),
                        ),
                  );
                },
              ),
              const SizedBox(width: 12),
              
              // Admin button
              Consumer<WalletService>(
                builder: (context, wallet, child) {
                  final isAdmin = wallet.isConnected && wallet.isAdmin;
                  return GestureDetector(
                    onTap: isAdmin ? _showAdminPanel : null,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isAdmin
                              ? const Color(0xFFfbbf24)
                              : Colors.white.withOpacity(0.1),
                          width: isAdmin ? 2 : 1,
                        ),
                        boxShadow: isAdmin
                            ? [
                                BoxShadow(
                                  color: const Color(0xFFfbbf24)
                                      .withOpacity(0.5),
                                  blurRadius: 20,
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        Icons.settings,
                        color: isAdmin
                            ? const Color(0xFFfbbf24)
                            : Colors.white.withOpacity(0.3),
                        size: 20,
                      ),
                    ).animate(onPlay: (controller) {
                      if (isAdmin) {
                        controller.repeat();
                      }
                    }).shimmer(
                          duration: 2000.ms,
                          color: const Color(0xFFfbbf24).withOpacity(0.5),
                        ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}