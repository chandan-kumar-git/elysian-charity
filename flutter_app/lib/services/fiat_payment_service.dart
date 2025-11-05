import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Fiat-to-Crypto Payment Gateway Service
/// Allows users to donate with credit cards, PayPal, etc. without needing crypto
/// Integrates with Stripe, Ramp, MoonPay for seamless fiat conversion
class FiatPaymentService {
  // Payment processor API keys (use test mode for demo)
  final String stripePublishableKey = 'pk_test_YOUR_STRIPE_KEY';
  final String rampApiKey = 'YOUR_RAMP_API_KEY';
  final String moonPayApiKey = 'YOUR_MOONPAY_API_KEY';

  /// Get available payment methods for user
  List<Map<String, dynamic>> getPaymentMethods() {
    return [
      {
        'id': 'credit_card',
        'name': 'Credit/Debit Card',
        'icon': '💳',
        'description': 'Visa, Mastercard, Amex',
        'processingTime': '30 seconds',
        'fee': '2.5%',
        'supported': true,
      },
      {
        'id': 'paypal',
        'name': 'PayPal',
        'icon': '🅿️',
        'description': 'Pay with your PayPal account',
        'processingTime': '1 minute',
        'fee': '2.9%',
        'supported': true,
      },
      {
        'id': 'google_pay',
        'name': 'Google Pay',
        'icon': '🔵',
        'description': 'Quick checkout with Google',
        'processingTime': '20 seconds',
        'fee': '2.0%',
        'supported': true,
      },
      {
        'id': 'apple_pay',
        'name': 'Apple Pay',
        'icon': '🍎',
        'description': 'Pay with Apple Wallet',
        'processingTime': '20 seconds',
        'fee': '2.0%',
        'supported': true,
      },
      {
        'id': 'venmo',
        'name': 'Venmo',
        'icon': '💙',
        'description': 'Send money with Venmo',
        'processingTime': '1 minute',
        'fee': '1.9%',
        'supported': true,
      },
      {
        'id': 'cash_app',
        'name': 'Cash App',
        'icon': '💵',
        'description': 'Pay with Cash App',
        'processingTime': '1 minute',
        'fee': '1.9%',
        'supported': true,
      },
      {
        'id': 'bank_transfer',
        'name': 'Bank Transfer',
        'icon': '🏦',
        'description': 'Direct bank account transfer',
        'processingTime': '2-3 business days',
        'fee': '0.8%',
        'supported': true,
      },
      {
        'id': 'mobile_money',
        'name': 'Mobile Money',
        'icon': '📱',
        'description': 'M-Pesa, PayTM, etc.',
        'processingTime': '30 seconds',
        'fee': '1.5%',
        'supported': true,
      },
    ];
  }

  /// Process credit card payment and convert to crypto
  Future<Map<String, dynamic>> processCreditCardPayment({
    required double amountUSD,
    required String campaignId,
    required String donorEmail,
    required String donorName,
    required Map<String, String> cardDetails,
  }) async {
    try {
      // Simulate Stripe payment processing
      await Future.delayed(Duration(seconds: 2));

      // Step 1: Charge credit card via Stripe
      final paymentIntent = await _createStripePaymentIntent(amountUSD, donorEmail);

      // Step 2: Convert USD to ETH via Ramp
      final cryptoAmount = await _convertFiatToCrypto(amountUSD, 'ETH');

      // Step 3: Send to smart contract
      final txHash = await _sendToSmartContract(
        cryptoAmount,
        campaignId,
        donorEmail,
      );

      return {
        'success': true,
        'paymentId': paymentIntent['id'],
        'amountUSD': amountUSD,
        'amountETH': cryptoAmount,
        'txHash': txHash,
        'blockchainUrl': 'https://sepolia.etherscan.io/tx/$txHash',
        'receiptUrl': 'https://charitychain.org/receipt/${paymentIntent['id']}',
        'timestamp': DateTime.now().toIso8601String(),
        'donorEmail': donorEmail,
        'donorName': donorName,
        'campaignId': campaignId,
        'status': 'confirmed',
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Process PayPal payment
  Future<Map<String, dynamic>> processPayPalPayment({
    required double amountUSD,
    required String campaignId,
    required String donorEmail,
  }) async {
    try {
      await Future.delayed(Duration(seconds: 2));

      final orderId = 'PP_${DateTime.now().millisecondsSinceEpoch}';
      final cryptoAmount = await _convertFiatToCrypto(amountUSD, 'ETH');
      final txHash = _generateMockTxHash();

      return {
        'success': true,
        'orderId': orderId,
        'amountUSD': amountUSD,
        'amountETH': cryptoAmount,
        'txHash': txHash,
        'blockchainUrl': 'https://sepolia.etherscan.io/tx/$txHash',
        'timestamp': DateTime.now().toIso8601String(),
        'status': 'confirmed',
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Generate payment checkout URL for QR code
  String generateCheckoutUrl({
    required String campaignId,
    required double suggestedAmount,
  }) {
    // Generate short URL for QR code scanning
    final checkoutId = DateTime.now().millisecondsSinceEpoch;
    return 'https://donate.charitychain.org/$checkoutId?campaign=$campaignId&amount=$suggestedAmount';
  }

  /// Get conversion rates (USD to crypto)
  Future<Map<String, double>> getConversionRates() async {
    try {
      // In production, fetch from CoinGecko or Chainlink oracle
      // For demo, return mock rates
      return {
        'ETH_USD': 3500.0, // 1 ETH = $3,500
        'BTC_USD': 65000.0, // 1 BTC = $65,000
        'USDC_USD': 1.0, // 1 USDC = $1
        'USDT_USD': 1.0, // 1 USDT = $1
      };
    } catch (e) {
      // Fallback rates
      return {
        'ETH_USD': 3500.0,
        'BTC_USD': 65000.0,
        'USDC_USD': 1.0,
        'USDT_USD': 1.0,
      };
    }
  }

  /// Calculate fees and final amounts
  Map<String, dynamic> calculatePaymentBreakdown({
    required double amountUSD,
    required String paymentMethod,
  }) {
    final methods = getPaymentMethods();
    final method = methods.firstWhere((m) => m['id'] == paymentMethod);
    
    final feePercentage = double.parse(method['fee'].toString().replaceAll('%', ''));
    final feeAmount = amountUSD * (feePercentage / 100);
    final netAmount = amountUSD - feeAmount;
    final ethAmount = netAmount / 3500.0; // Assume $3,500 per ETH

    return {
      'grossAmount': amountUSD,
      'fee': feeAmount,
      'feePercentage': feePercentage,
      'netAmount': netAmount,
      'cryptoAmount': ethAmount,
      'cryptoCurrency': 'ETH',
      'paymentMethod': method['name'],
      'processingTime': method['processingTime'],
      'breakdown': [
        {'label': 'Your Donation', 'amount': amountUSD},
        {'label': 'Processing Fee (${feePercentage}%)', 'amount': -feeAmount},
        {'label': 'Net to Charity', 'amount': netAmount},
        {'label': 'Converted to ETH', 'amount': ethAmount},
      ],
    };
  }

  /// Get payment statistics
  Map<String, dynamic> getPaymentStats() {
    return {
      'totalFiatDonations': 847234.50, // $847K in fiat donations
      'totalCreditCard': 523847.30,
      'totalPayPal': 189234.50,
      'totalMobilePayments': 134152.70,
      'averageDonation': 127.50,
      'conversionRate': 94.5, // 94.5% successful conversions
      'averageProcessingTime': '45 seconds',
      'totalTransactions': 6847,
      'methodBreakdown': {
        'credit_card': 4234, // 62%
        'paypal': 1456, // 21%
        'google_pay': 687, // 10%
        'mobile_money': 470, // 7%
      },
      'topCountries': [
        {'country': 'United States', 'amount': 423847.50},
        {'country': 'United Kingdom', 'amount': 189234.30},
        {'country': 'India', 'amount': 134152.70},
        {'country': 'Kenya', 'amount': 67234.00},
        {'country': 'Brazil', 'amount': 32766.00},
      ],
    };
  }

  /// SMS-based donation instructions
  Map<String, dynamic> getSMSDonationInfo() {
    return {
      'phoneNumber': '+1-555-DONATE',
      'shortCode': '73628', // Spells DONATE on phone keypad
      'instructions': [
        'Text "DONATE [amount] [campaign]" to +1-555-DONATE',
        'Example: "DONATE 50 FOOD"',
        'You\'ll receive a payment link via SMS',
        'Works on any phone - no smartphone needed!',
        'Supports M-Pesa, PayTM, mobile money',
      ],
      'examples': [
        {'text': 'DONATE 25 WATER', 'description': 'Donate \$25 to clean water'},
        {'text': 'DONATE 50 FOOD', 'description': 'Donate \$50 to food relief'},
        {'text': 'DONATE 100 HEALTH', 'description': 'Donate \$100 to healthcare'},
      ],
      'statistics': {
        'smsDonations': 3847,
        'averageAmount': 37.50,
        'countriesReached': 67,
        'basicPhones': 2456, // 64% from non-smartphones
      },
    };
  }

  /// Private helper methods

  Future<Map<String, dynamic>> _createStripePaymentIntent(
    double amount,
    String email,
  ) async {
    // In production, call Stripe API
    // For demo, return mock payment intent
    return {
      'id': 'pi_${DateTime.now().millisecondsSinceEpoch}',
      'amount': (amount * 100).toInt(), // Stripe uses cents
      'currency': 'usd',
      'status': 'succeeded',
      'receipt_email': email,
    };
  }

  Future<double> _convertFiatToCrypto(double amountUSD, String crypto) async {
    // In production, use Ramp/MoonPay API
    // For demo, use mock conversion
    final rates = await getConversionRates();
    final rate = rates['${crypto}_USD'] ?? 3500.0;
    return amountUSD / rate;
  }

  Future<String> _sendToSmartContract(
    double ethAmount,
    String campaignId,
    String donorEmail,
  ) async {
    // In production, interact with blockchain service
    // For demo, return mock transaction hash
    return _generateMockTxHash();
  }

  String _generateMockTxHash() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '0x${timestamp.toRadixString(16)}abc123def456';
  }
}
