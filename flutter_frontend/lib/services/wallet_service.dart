import 'package:flutter/foundation.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class WalletService extends ChangeNotifier {
  // Connection state
  bool _isConnected = false;
  bool _isConnecting = false;
  EthereumAddress? _account;
  Web3Client? _client;
  
  // Network info
  int? _chainId;
  String? _networkName;
  bool _isCorrectNetwork = false;
  
  // MetaMask availability
  bool _isMetaMaskAvailable = false;
  
  // Contract owner for admin access
  static const String _contractOwner = '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266';

  // Getters
  bool get isConnected => _isConnected;
  bool get isConnecting => _isConnecting;
  EthereumAddress? get account => _account;
  Web3Client? get client => _client;
  int? get chainId => _chainId;
  String? get networkName => _networkName;
  bool get isCorrectNetwork => _isCorrectNetwork;
  bool get isMetaMaskAvailable => _isMetaMaskAvailable;
  bool get isAdmin => _isConnected && 
      _account != null && 
      _account!.hex.toLowerCase() == _contractOwner.toLowerCase();

  WalletService() {
    _initialize();
  }

  Future<void> _initialize() async {
    // Check MetaMask availability (for web)
    if (kIsWeb) {
      _checkMetaMaskAvailability();
    }
    
    // Initialize Web3 client
    _client = Web3Client(
      'http://127.0.0.1:8545', // Local Hardhat node
      Client(),
    );
    
    notifyListeners();
  }

  void _checkMetaMaskAvailability() {
    // In a real implementation, this would check for window.ethereum
    // For now, we'll assume it's available on web
    _isMetaMaskAvailable = kIsWeb;
    notifyListeners();
  }

  Future<bool> connect() async {
    if (_isConnecting) return false;
    
    _isConnecting = true;
    notifyListeners();
    
    try {
      // In a real implementation, this would interact with MetaMask
      // For demo purposes, we'll simulate a connection
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock connection with a test account
      _account = EthereumAddress.fromHex(_contractOwner);
      _isConnected = true;
      _chainId = 31337; // Hardhat chain ID
      _networkName = 'Localhost';
      _isCorrectNetwork = true;
      
      _isConnecting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isConnecting = false;
      notifyListeners();
      return false;
    }
  }

  void disconnect() {
    _isConnected = false;
    _account = null;
    _chainId = null;
    _networkName = null;
    _isCorrectNetwork = false;
    notifyListeners();
  }

  Future<bool> switchNetwork() async {
    // In a real implementation, this would request network switch
    await Future.delayed(const Duration(milliseconds: 500));
    _isCorrectNetwork = true;
    notifyListeners();
    return true;
  }

  String formatAddress(String address, {int chars = 4}) {
    if (address.length <= chars * 2 + 2) return address;
    return '${address.substring(0, chars + 2)}...${address.substring(address.length - chars)}';
  }

  String formatBalance(String balance, {int decimals = 3}) {
    final double value = double.tryParse(balance) ?? 0.0;
    return value.toStringAsFixed(decimals);
  }
}