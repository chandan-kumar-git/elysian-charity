import 'dart:async';
import 'dart:math';

/// Corporate matching donation program
class CorporateMatchingService {
  final Random _random = Random();

  /// Get active corporate matching campaigns
  List<Map<String, dynamic>> getActiveMatchingPrograms() {
    return [
      {
        'id': 'corp_001',
        'corporationName': 'Microsoft',
        'logo': 'https://logo.clearbit.com/microsoft.com',
        'matchingRatio': 2.0, // 2x match
        'maxMatch': 100000.0,
        'currentMatched': 65420.0,
        'percentageUsed': 65.4,
        'employeeParticipation': 847,
        'eligibleCampaigns': ['Education', 'Technology'],
        'startDate': DateTime.now().subtract(const Duration(days: 30)),
        'endDate': DateTime.now().add(const Duration(days: 60)),
        'status': 'ACTIVE',
        'color': 0xFF00A4EF,
      },
      {
        'id': 'corp_002',
        'corporationName': 'Google',
        'logo': 'https://logo.clearbit.com/google.com',
        'matchingRatio': 1.5,
        'maxMatch': 150000.0,
        'currentMatched': 89250.0,
        'percentageUsed': 59.5,
        'employeeParticipation': 1234,
        'eligibleCampaigns': ['Education', 'Healthcare', 'Environment'],
        'startDate': DateTime.now().subtract(const Duration(days: 15)),
        'endDate': DateTime.now().add(const Duration(days: 75)),
        'status': 'ACTIVE',
        'color': 0xFF4285F4,
      },
      {
        'id': 'corp_003',
        'corporationName': 'Amazon',
        'logo': 'https://logo.clearbit.com/amazon.com',
        'matchingRatio': 1.0,
        'maxMatch': 200000.0,
        'currentMatched': 124500.0,
        'percentageUsed': 62.3,
        'employeeParticipation': 2156,
        'eligibleCampaigns': ['Food', 'Shelter', 'Education'],
        'startDate': DateTime.now().subtract(const Duration(days: 45)),
        'endDate': DateTime.now().add(const Duration(days: 45)),
        'status': 'ACTIVE',
        'color': 0xFFFF9900,
      },
    ];
  }

  /// Check if donation is eligible for matching
  Future<Map<String, dynamic>> checkMatchingEligibility({
    required String campaignId,
    required String category,
    required double amount,
    String? employeeEmail,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final matchingPrograms = getActiveMatchingPrograms()
        .where((p) => (p['eligibleCampaigns'] as List).contains(category))
        .toList();

    if (matchingPrograms.isEmpty) {
      return {
        'eligible': false,
        'reason': 'No active matching programs for this category',
      };
    }

    // Find best matching program
    final bestMatch = matchingPrograms.reduce((a, b) =>
        (a['matchingRatio'] as double) > (b['matchingRatio'] as double) ? a : b);

    final matchedAmount = amount * (bestMatch['matchingRatio'] as double);
    final remainingMatch = (bestMatch['maxMatch'] as double) - (bestMatch['currentMatched'] as double);

    if (matchedAmount > remainingMatch) {
      return {
        'eligible': true,
        'matchedAmount': remainingMatch,
        'actualRatio': remainingMatch / amount,
        'corporationName': bestMatch['corporationName'],
        'reason': 'Partial match - program limit reached',
        'totalDonation': amount + remainingMatch,
      };
    }

    return {
      'eligible': true,
      'matchedAmount': matchedAmount,
      'actualRatio': bestMatch['matchingRatio'],
      'corporationName': bestMatch['corporationName'],
      'corporationLogo': bestMatch['logo'],
      'totalDonation': amount + matchedAmount,
      'matchingProgramId': bestMatch['id'],
      'message': 'Your \$${amount.toStringAsFixed(0)} becomes \$${(amount + matchedAmount).toStringAsFixed(0)}!',
    };
  }

  /// Setup new corporate matching campaign
  Future<Map<String, dynamic>> setupMatchingCampaign({
    required String corporationName,
    required double matchingRatio,
    required double maxMatch,
    required List<String> eligibleCampaigns,
    int durationDays = 90,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    return {
      'success': true,
      'campaignId': 'corp_${_generateId()}',
      'corporationName': corporationName,
      'matchingRatio': matchingRatio,
      'maxMatch': maxMatch,
      'eligibleCampaigns': eligibleCampaigns,
      'startDate': DateTime.now().toIso8601String(),
      'endDate': DateTime.now().add(Duration(days: durationDays)).toIso8601String(),
      'status': 'ACTIVE',
      'employeePortalUrl': 'https://charitychain.org/corporate/$corporationName',
    };
  }

  /// Get corporate matching statistics
  Map<String, dynamic> getMatchingStatistics() {
    return {
      'totalCorporations': 15,
      'activePrograms': 8,
      'totalMatched': 847562.0,
      'totalDonations': 1547892.0,
      'averageRatio': 1.7,
      'topCorporations': [
        {
          'name': 'Microsoft',
          'totalMatched': 245678.0,
          'employees': 847,
        },
        {
          'name': 'Google',
          'totalMatched': 198456.0,
          'employees': 1234,
        },
        {
          'name': 'Amazon',
          'totalMatched': 187234.0,
          'employees': 2156,
        },
      ],
      'categoryBreakdown': {
        'Education': 345678.0,
        'Healthcare': 234567.0,
        'Food': 156789.0,
        'Environment': 110528.0,
      },
    };
  }

  /// Get employee participation stats
  Map<String, dynamic> getEmployeeStats(String corporationId) {
    return {
      'totalEmployees': 5000,
      'participating': 847,
      'participationRate': 16.94,
      'totalDonated': 124567.0,
      'totalMatched': 249134.0,
      'averageDonation': 147.16,
      'topDepartments': [
        {'name': 'Engineering', 'participants': 234, 'amount': 45678.0},
        {'name': 'Sales', 'participants': 189, 'amount': 34567.0},
        {'name': 'Marketing', 'participants': 145, 'amount': 23456.0},
      ],
      'engagement': {
        'newThisMonth': 45,
        'recurringDonors': 623,
        'oneTimeDonors': 224,
      },
    };
  }

  /// Generate tax deduction certificate
  Future<Map<String, dynamic>> generateTaxCertificate({
    required String userId,
    required int year,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    final donations = _getUserDonations(userId, year);
    
    return {
      'success': true,
      'certificateId': 'TAX_${year}_${_generateId()}',
      'year': year,
      'totalDonations': donations['total'],
      'totalMatched': donations['matched'],
      'grandTotal': donations['total'] + donations['matched'],
      'eligibleForDeduction': donations['total'], // Only user's portion
      'donationCount': donations['count'],
      'pdfUrl': 'https://charitychain.org/tax-cert/$userId/$year.pdf',
      'format': 'IRS 501(c)(3) Compliant',
      'digitalSignature': true,
      'qrCodeVerification': true,
      'validUntil': DateTime(year + 7, 12, 31), // 7 year retention
    };
  }

  Map<String, dynamic> _getUserDonations(String userId, int year) {
    return {
      'total': 1245.67 + _random.nextDouble() * 1000,
      'matched': 2145.89 + _random.nextDouble() * 1500,
      'count': 24 + _random.nextInt(20),
    };
  }

  /// Get leaderboard for corporate giving
  List<Map<String, dynamic>> getCorporateLeaderboard() {
    return [
      {
        'rank': 1,
        'corporation': 'Microsoft',
        'totalMatched': 845672.0,
        'employees': 2847,
        'growth': '+24%',
      },
      {
        'rank': 2,
        'corporation': 'Google',
        'totalMatched': 723456.0,
        'employees': 3234,
        'growth': '+18%',
      },
      {
        'rank': 3,
        'corporation': 'Amazon',
        'totalMatched': 687234.0,
        'employees': 4156,
        'growth': '+31%',
      },
      {
        'rank': 4,
        'corporation': 'Apple',
        'totalMatched': 534567.0,
        'employees': 1892,
        'growth': '+15%',
      },
      {
        'rank': 5,
        'corporation': 'Meta',
        'totalMatched': 423456.0,
        'employees': 1645,
        'growth': '+22%',
      },
    ];
  }

  String _generateId() {
    return _random.nextInt(999999).toString().padLeft(6, '0');
  }
}
