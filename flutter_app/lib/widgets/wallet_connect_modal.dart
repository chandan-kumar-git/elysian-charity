import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math' as math;

class WalletConnectModal extends StatefulWidget {
  final VoidCallback onConnected;
  
  const WalletConnectModal({Key? key, required this.onConnected}) : super(key: key);

  @override
  State<WalletConnectModal> createState() => _WalletConnectModalState();
}

class _WalletConnectModalState extends State<WalletConnectModal> 
    with TickerProviderStateMixin {
  bool _isConnecting = false;
  bool _isConnected = false;
  String _status = 'Connect your wallet to continue';
  late AnimationController _pulseController;
  late AnimationController _scanController;
  
  final String _mockWalletAddress = '0x742d35Cc6634C0532925a3b844Bc9e7595f5e89';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  Future<void> _connectWallet(String walletType) async {
    setState(() {
      _isConnecting = true;
      _status = 'Connecting to $walletType...';
    });
    
    _scanController.forward();
    
    // Simulate connection process
    await Future.delayed(const Duration(milliseconds: 1500));
    
    setState(() {
      _status = 'Verifying signature...';
    });
    
    await Future.delayed(const Duration(milliseconds: 1000));
    
    setState(() {
      _status = 'Fetching account details...';
    });
    
    await Future.delayed(const Duration(milliseconds: 800));
    
    setState(() {
      _isConnected = true;
      _isConnecting = false;
      _status = 'Connected successfully!';
    });
    
    // Play success haptic
    HapticFeedback.mediumImpact();
    
    // Wait a bit to show success state
    await Future.delayed(const Duration(milliseconds: 1500));
    
    widget.onConnected();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1a1a2e),
              const Color(0xFF16213e),
              const Color(0xFF0f3460),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: const Color(0xFF00F5FF).withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00F5FF).withOpacity(0.2),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            if (!_isConnecting && !_isConnected)
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            
            const SizedBox(height: 10),
            
            // Title
            Text(
              _isConnected ? 'Wallet Connected!' : 'Connect Wallet',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Status text
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _status,
                key: ValueKey(_status),
                style: TextStyle(
                  color: _isConnected 
                      ? const Color(0xFF10b981)
                      : Colors.white.withOpacity(0.7),
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 30),
            
            if (_isConnected)
              _buildConnectedState()
            else if (_isConnecting)
              _buildConnectingState()
            else
              _buildWalletOptions(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildWalletOptions() {
    return Column(
      children: [
        _buildWalletOption(
          'MetaMask',
          Icons.account_balance_wallet,
          const Color(0xFFFF6B35),
        ),
        const SizedBox(height: 15),
        _buildWalletOption(
          'WalletConnect',
          Icons.qr_code_scanner,
          const Color(0xFF3B82F6),
        ),
        const SizedBox(height: 15),
        _buildWalletOption(
          'Coinbase Wallet',
          Icons.account_balance,
          const Color(0xFF0052FF),
        ),
      ],
    );
  }
  
  Widget _buildWalletOption(String name, IconData icon, Color color) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _connectWallet(name),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.05),
                Colors.white.withOpacity(0.02),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 20),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withOpacity(0.5),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildConnectingState() {
    return Column(
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer pulse ring
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF00F5FF).withOpacity(
                          0.3 * (1 - _pulseController.value)
                        ),
                        width: 3,
                      ),
                    ),
                  );
                },
              ),
              // Inner scanning circle
              AnimatedBuilder(
                animation: _scanController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _scanController.value * 2 * math.pi,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: [
                            Colors.transparent,
                            const Color(0xFF00F5FF).withOpacity(0.5),
                            const Color(0xFF00F5FF),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  );
                },
              ),
              // Center icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF00F5FF).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: Color(0xFF00F5FF),
                  size: 32,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00F5FF)),
        ),
      ],
    );
  }
  
  Widget _buildConnectedState() {
    return Column(
      children: [
        // Success checkmark
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFF10b981).withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF10b981),
              width: 3,
            ),
          ),
          child: const Icon(
            Icons.check,
            color: Color(0xFF10b981),
            size: 60,
          ),
        ),
        
        const SizedBox(height: 25),
        
        // Wallet address
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF00F5FF).withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.account_circle,
                color: Color(0xFF00F5FF),
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                '${_mockWalletAddress.substring(0, 6)}...${_mockWalletAddress.substring(_mockWalletAddress.length - 4)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(width: 12),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: _mockWalletAddress));
                    HapticFeedback.lightImpact();
                  },
                  child: Icon(
                    Icons.copy,
                    color: Colors.white.withOpacity(0.7),
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 25),
        
        // Balance info
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildInfoChip('Network', 'Ethereum'),
            const SizedBox(width: 15),
            _buildInfoChip('Balance', '12.5 ETH'),
          ],
        ),
      ],
    );
  }
  
  Widget _buildInfoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF7c3aed).withOpacity(0.3),
            const Color(0xFF6366f1).withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
