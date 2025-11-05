import 'dart:async';
import 'dart:math';

/// QR Code donation system for instant giving
class QRDonationService {
  final Random _random = Random();

  /// Generate donation QR data for a campaign
  Map<String, dynamic> generateDonationQR({
    required String campaignId,
    required String campaignName,
    required String charityWallet,
    String? suggestedAmount,
  }) {
    return {
      'type': 'CHARITY_DONATION',
      'version': '1.0',
      'campaign': campaignId,
      'campaignName': campaignName,
      'wallet': charityWallet,
      'chain': 'ethereum',
      'suggestedAmount': suggestedAmount ?? '10',
      'qrData': 'charitychain://donate/$campaignId?amount=$suggestedAmount',
      'shortUrl': 'cc.org/${_generateShortCode()}',
      'expiresAt': DateTime.now().add(const Duration(days: 30)).toIso8601String(),
    };
  }

  /// Parse scanned QR code
  Map<String, dynamic> parseQRCode(String qrData) {
    // Parse charitychain://donate/campaign_id?amount=10
    final uri = Uri.parse(qrData);
    
    return {
      'valid': uri.scheme == 'charitychain',
      'action': uri.host,
      'campaignId': uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null,
      'suggestedAmount': uri.queryParameters['amount'],
      'parameters': uri.queryParameters,
    };
  }

  /// Get suggested donation amounts
  List<Map<String, dynamic>> getSuggestedAmounts(String category) {
    final suggestions = {
      'Education': [
        {'amount': 5.0, 'impact': '25 textbooks', 'popular': false},
        {'amount': 10.0, 'impact': '2 school supply kits', 'popular': true},
        {'amount': 25.0, 'impact': '5 uniforms', 'popular': false},
        {'amount': 50.0, 'impact': '1 month teacher salary', 'popular': false},
        {'amount': 100.0, 'impact': '6 months of education', 'popular': false},
        {'amount': 200.0, 'impact': '1 year of education', 'popular': false},
      ],
      'Healthcare': [
        {'amount': 5.0, 'impact': '10 vaccines', 'popular': false},
        {'amount': 10.0, 'impact': '2 medical check-ups', 'popular': true},
        {'amount': 25.0, 'impact': '5 medication courses', 'popular': false},
        {'amount': 50.0, 'impact': '2 minor treatments', 'popular': false},
        {'amount': 100.0, 'impact': '20 vaccines', 'popular': false},
        {'amount': 500.0, 'impact': '1 surgery', 'popular': false},
      ],
      'Food': [
        {'amount': 5.0, 'impact': '10 meals', 'popular': true},
        {'amount': 10.0, 'impact': '20 meals', 'popular': false},
        {'amount': 25.0, 'impact': '50 meals', 'popular': false},
        {'amount': 50.0, 'impact': '1 family for 1 month', 'popular': false},
        {'amount': 100.0, 'impact': '2 families for 1 month', 'popular': false},
        {'amount': 150.0, 'impact': '1 family for 3 months', 'popular': false},
      ],
    };

    return suggestions[category] ?? suggestions['Food']!;
  }

  /// Generate printable QR code
  Future<Map<String, dynamic>> generatePrintableQR({
    required String campaignId,
    required String campaignName,
    String format = 'pdf', // pdf, png, svg
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    return {
      'success': true,
      'format': format,
      'downloadUrl': 'https://charitychain.org/qr/$campaignId.$format',
      'printReady': true,
      'includesInstructions': true,
      'size': format == 'pdf' ? 'A4' : '1024x1024',
    };
  }

  /// Track QR code scans
  List<Map<String, dynamic>> getQRScanStats(String campaignId) {
    return [
      {
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'scans': 45,
        'conversions': 23,
        'amount': 567.0,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'scans': 38,
        'conversions': 19,
        'amount': 423.0,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'scans': 52,
        'conversions': 28,
        'amount': 634.0,
      },
    ];
  }

  /// Get QR donation statistics
  Map<String, dynamic> getQRDonationStats() {
    return {
      'totalQRDonations': 3847,
      'totalAmount': 45678.90,
      'averageAmount': 11.88,
      'conversionRate': 0.52, // 52% of scans result in donation
      'topLocations': [
        {'city': 'Mumbai', 'scans': 847},
        {'city': 'Delhi', 'scans': 623},
        {'city': 'Bangalore', 'scans': 892},
      ],
      'peakHours': ['10:00 AM', '2:00 PM', '7:00 PM'],
    };
  }

  String _generateShortCode() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(6, (index) => chars[_random.nextInt(chars.length)]).join();
  }
}
