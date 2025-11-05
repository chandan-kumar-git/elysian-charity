import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/phone_container.dart';
import '../widgets/contract_balance_card.dart';
import '../widgets/transaction_preview.dart';
import '../widgets/metamask_prompt.dart';
import '../widgets/donation_modal.dart';
import '../widgets/admin_panel_modal.dart';
import '../widgets/transaction_ledger_modal.dart';
import '../services/wallet_service.dart';
import '../services/contract_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkMetaMaskAvailability();
    });
  }

  void _checkMetaMaskAvailability() {
    final walletService = Provider.of<WalletService>(context, listen: false);
    if (!walletService.isMetaMaskAvailable) {
      // Show inline prompt in the UI
    }
  }

  void _promptDonation() {
    final walletService = Provider.of<WalletService>(context, listen: false);
    if (!walletService.isMetaMaskAvailable) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => const MetaMaskPrompt(),
      );
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const DonationModal(),
    );
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
              ),
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
              ),
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
                        _buildStatusBar(),
                        
                        const SizedBox(height: 20),
                        
                        // Header with wallet connector and admin button
                        _buildHeader(),
                        
                        const SizedBox(height: 24),
                        
                        // MetaMask prompt (inline)
                        Consumer<WalletService>(
                          builder: (context, walletService, child) {
                            if (!walletService.isMetaMaskAvailable) {
                              return Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 20),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0c0c0c),
                                      borderRadius: BorderRadius.circular(12),
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
                                            gradient: const LinearGradient(
                                              colors: [Color(0xFFf59e0b), Color(0xFFd97706)],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.account_balance_wallet,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const Expanded(
                                          child: Text(
                                            'MetaMask required for Web3 interaction',
                                            style: TextStyle(
                                              color: Color(0xFF9ca3af),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (context) => const MetaMaskPrompt(),
                                            );
                                          },
                                          child: const Text(
                                            'Install',
                                            style: TextStyle(
                                              color: Color(0xFFf59e0b),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1),
                                  const SizedBox(height: 20),
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        
                        // Contract balance card
                        ContractBalanceCard(
                          onDonate: _promptDonation,
                        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
                        
                        const SizedBox(height: 20),
                        
                        // Transaction preview
                        const TransactionPreview()
                            .animate()
                            .fadeIn(delay: 400.ms)
                            .slideY(begin: 0.1),
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
              // Wallet connector would go here
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              
              // Admin button
              Consumer<WalletService>(
                builder: (context, walletService, child) {
                  final isAdmin = walletService.isConnected && walletService.isAdmin;
                  return GestureDetector(
                    onTap: isAdmin ? () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => const AdminPanelModal(),
                      );
                    } : null,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Icon(
                        Icons.settings,
                        color: isAdmin ? Colors.white : Colors.white.withOpacity(0.3),
                        size: 20,
                      ),
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