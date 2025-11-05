import 'dart:async';
import 'dart:math' as math;

class MultiCurrencyService {
  static final MultiCurrencyService _instance = MultiCurrencyService._internal();
  factory MultiCurrencyService() => _instance;
  MultiCurrencyService._internal();

  final _random = math.Random();
  final _priceController = StreamController<Map<String, double>>.broadcast();

  Stream<Map<String, double>> get priceStream => _priceController.stream;

  // Supported Currencies
  List<Map<String, dynamic>> getSupportedCurrencies() {
    return [
      {
        'symbol': 'ETH',
        'name': 'Ethereum',
        'icon': '⟠',
        'color': 0xFF627EEA,
        'address': 'native',
        'decimals': 18,
        'minDonation': 0.001,
        'isActive': true,
        'network': 'Ethereum',
      },
      {
        'symbol': 'USDC',
        'name': 'USD Coin',
        'icon': '💵',
        'color': 0xFF2775CA,
        'address': '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48',
        'decimals': 6,
        'minDonation': 1.0,
        'isActive': true,
        'network': 'Ethereum',
      },
      {
        'symbol': 'DAI',
        'name': 'Dai Stablecoin',
        'icon': '◎',
        'color': 0xFFFFB000,
        'address': '0x6B175474E89094C44Da98b954EedeAC495271d0F',
        'decimals': 18,
        'minDonation': 1.0,
        'isActive': true,
        'network': 'Ethereum',
      },
      {
        'symbol': 'USDT',
        'name': 'Tether USD',
        'icon': '₮',
        'color': 0xFF26A17B,
        'address': '0xdAC17F958D2ee523a2206206994597C13D831ec7',
        'decimals': 6,
        'minDonation': 1.0,
        'isActive': true,
        'network': 'Ethereum',
      },
      {
        'symbol': 'MATIC',
        'name': 'Polygon',
        'icon': '🟣',
        'color': 0xFF8247E5,
        'address': '0x7D1AfA7B718fb893dB30A3aBc0Cfc608AaCfeBB0',
        'decimals': 18,
        'minDonation': 1.0,
        'isActive': true,
        'network': 'Polygon',
      },
      {
        'symbol': 'BTC',
        'name': 'Bitcoin',
        'icon': '₿',
        'color': 0xFFF7931A,
        'address': 'btc-native',
        'decimals': 8,
        'minDonation': 0.0001,
        'isActive': false,
        'network': 'Bitcoin',
      },
    ];
  }

  // Live Price Data (Mock)
  Map<String, double> getCurrentPrices() {
    return {
      'ETH': 2485.50 + (_random.nextDouble() - 0.5) * 50,
      'USDC': 1.00 + (_random.nextDouble() - 0.5) * 0.01,
      'DAI': 1.00 + (_random.nextDouble() - 0.5) * 0.01,
      'USDT': 1.00 + (_random.nextDouble() - 0.5) * 0.01,
      'MATIC': 0.85 + (_random.nextDouble() - 0.5) * 0.05,
      'BTC': 42500.00 + (_random.nextDouble() - 0.5) * 500,
    };
  }

  // Start real-time price updates
  void startPriceUpdates() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      _priceController.add(getCurrentPrices());
    });
  }

  // Calculate USD Value
  double calculateUSDValue(String currency, double amount) {
    final prices = getCurrentPrices();
    return amount * (prices[currency] ?? 0);
  }

  // Get Price Change 24h
  Map<String, double> get24hPriceChange() {
    return {
      'ETH': 2.5 + (_random.nextDouble() - 0.5) * 2,
      'USDC': 0.01 + (_random.nextDouble() - 0.5) * 0.02,
      'DAI': -0.02 + (_random.nextDouble() - 0.5) * 0.02,
      'USDT': 0.01 + (_random.nextDouble() - 0.5) * 0.02,
      'MATIC': 5.2 + (_random.nextDouble() - 0.5) * 3,
      'BTC': 1.8 + (_random.nextDouble() - 0.5) * 2,
    };
  }

  // Currency Statistics
  Map<String, dynamic> getCurrencyStats(String symbol) {
    final prices = getCurrentPrices();
    final price = prices[symbol] ?? 0;
    
    return {
      'symbol': symbol,
      'currentPrice': price,
      'priceChange24h': get24hPriceChange()[symbol],
      'volume24h': (1000000 + _random.nextInt(5000000)).toDouble(),
      'marketCap': (10000000000 + _random.nextInt(50000000000)).toDouble(),
      'high24h': price * 1.05,
      'low24h': price * 0.95,
      'supply': symbol == 'ETH' ? 120000000 : 1000000000,
    };
  }

  // Donation Distribution by Currency
  Map<String, dynamic> getDonationDistribution() {
    return {
      'ETH': {'amount': 1250.5, 'percentage': 52, 'donors': 1250},
      'USDC': {'amount': 780.2, 'percentage': 28, 'donors': 890},
      'DAI': {'amount': 350.8, 'percentage': 12, 'donors': 420},
      'USDT': {'amount': 180.5, 'percentage': 6, 'donors': 210},
      'MATIC': {'amount': 50.0, 'percentage': 2, 'donors': 95},
    };
  }

  // Multi-Currency Wallet Balance
  Map<String, double> getWalletBalances(String address) {
    return {
      'ETH': 2.5 + _random.nextDouble() * 5,
      'USDC': 1000 + _random.nextDouble() * 5000,
      'DAI': 500 + _random.nextDouble() * 2000,
      'USDT': 800 + _random.nextDouble() * 3000,
      'MATIC': 100 + _random.nextDouble() * 500,
    };
  }

  // Currency Conversion
  double convertCurrency(String fromCurrency, String toCurrency, double amount) {
    final prices = getCurrentPrices();
    final fromPrice = prices[fromCurrency] ?? 0;
    final toPrice = prices[toCurrency] ?? 0;
    
    if (toPrice == 0) return 0;
    return (amount * fromPrice) / toPrice;
  }

  // Gas Fee Estimation
  Map<String, dynamic> getGasFeeEstimate(String network, String currency) {
    final baseFee = network == 'Ethereum' ? 30 : 0.5;
    
    return {
      'network': network,
      'currency': currency,
      'gasPrice': '${(baseFee + _random.nextDouble() * 10).toStringAsFixed(2)} Gwei',
      'estimatedFee': '${(0.005 + _random.nextDouble() * 0.01).toStringAsFixed(4)} ETH',
      'estimatedFeeUSD': '\$${((0.005 + _random.nextDouble() * 0.01) * 2485).toStringAsFixed(2)}',
      'confirmationTime': '${(15 + _random.nextInt(30))} seconds',
      'networkCongestion': ['Low', 'Medium', 'High'][_random.nextInt(3)],
    };
  }

  // Transaction History by Currency
  List<Map<String, dynamic>> getTransactionHistory(String currency) {
    return List.generate(10, (i) {
      final isDonation = _random.nextBool();
      return {
        'txHash': '0x${_generateHash(64)}',
        'type': isDonation ? 'Donation' : 'Withdrawal',
        'amount': (0.1 + _random.nextDouble() * 5).toStringAsFixed(4),
        'currency': currency,
        'timestamp': DateTime.now().subtract(Duration(hours: i * 6)),
        'status': 'Confirmed',
        'confirmations': 15 + _random.nextInt(50),
      };
    });
  }

  String _generateHash(int length) {
    const chars = '0123456789abcdef';
    return List.generate(length, (i) => chars[_random.nextInt(chars.length)]).join();
  }

  // Popular Currency Pairs
  List<Map<String, dynamic>> getPopularPairs() {
    return [
      {'from': 'ETH', 'to': 'USDC', 'volume': 5000000, 'rate': getCurrentPrices()['ETH']!},
      {'from': 'ETH', 'to': 'DAI', 'volume': 3500000, 'rate': getCurrentPrices()['ETH']!},
      {'from': 'USDC', 'to': 'ETH', 'volume': 2800000, 'rate': 1 / getCurrentPrices()['ETH']!},
      {'from': 'DAI', 'to': 'ETH', 'volume': 1900000, 'rate': 1 / getCurrentPrices()['ETH']!},
    ];
  }

  // Currency Acceptance by Charities
  Map<String, dynamic> getCurrencyAcceptance() {
    return {
      'totalCharities': 245,
      'acceptingETH': 245,
      'acceptingUSDC': 220,
      'acceptingDAI': 210,
      'acceptingUSDT': 195,
      'acceptingMATIC': 180,
      'acceptingMultiple': 165,
    };
  }

  void dispose() {
    _priceController.close();
  }
}
