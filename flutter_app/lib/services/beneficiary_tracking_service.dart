import 'dart:async';
import 'dart:math';

/// Live beneficiary tracking with interactive map
class BeneficiaryTrackingService {
  final Random _random = Random();

  /// Get all beneficiaries for map display
  List<Map<String, dynamic>> getBeneficiaries() {
    return [
      {
        'id': 'ben_001',
        'name': 'Priya Sharma',
        'age': 12,
        'location': 'Mumbai, India',
        'lat': 19.0760,
        'lng': 72.8777,
        'category': 'Education',
        'needsMet': true,
        'donationReceived': 250.0,
        'story': 'Received school supplies and uniform',
        'photo': 'https://i.pravatar.cc/150?img=1',
        'lastUpdate': DateTime.now().subtract(const Duration(hours: 2)),
        'progress': 100,
        'campaignId': 'camp_edu_001',
      },
      {
        'id': 'ben_002',
        'name': 'Rahul Kumar',
        'age': 8,
        'location': 'Delhi, India',
        'lat': 28.7041,
        'lng': 77.1025,
        'category': 'Healthcare',
        'needsMet': false,
        'donationReceived': 120.0,
        'targetAmount': 500.0,
        'story': 'Needs surgery for cleft lip',
        'photo': 'https://i.pravatar.cc/150?img=2',
        'lastUpdate': DateTime.now().subtract(const Duration(hours: 5)),
        'progress': 24,
        'campaignId': 'camp_health_001',
      },
      {
        'id': 'ben_003',
        'name': 'Anita Devi',
        'age': 35,
        'location': 'Bangalore, India',
        'lat': 12.9716,
        'lng': 77.5946,
        'category': 'Food',
        'needsMet': true,
        'donationReceived': 180.0,
        'story': 'Family of 4 received 3 months food supply',
        'photo': 'https://i.pravatar.cc/150?img=3',
        'lastUpdate': DateTime.now().subtract(const Duration(days: 1)),
        'progress': 100,
        'campaignId': 'camp_food_001',
      },
      {
        'id': 'ben_004',
        'name': 'Vikram Singh',
        'age': 15,
        'location': 'Jaipur, India',
        'lat': 26.9124,
        'lng': 75.7873,
        'category': 'Education',
        'needsMet': false,
        'donationReceived': 340.0,
        'targetAmount': 500.0,
        'story': 'Needs laptop for online classes',
        'photo': 'https://i.pravatar.cc/150?img=4',
        'lastUpdate': DateTime.now().subtract(const Duration(hours: 12)),
        'progress': 68,
        'campaignId': 'camp_edu_002',
      },
      {
        'id': 'ben_005',
        'name': 'Maya Patel',
        'age': 7,
        'location': 'Ahmedabad, India',
        'lat': 23.0225,
        'lng': 72.5714,
        'category': 'Healthcare',
        'needsMet': true,
        'donationReceived': 850.0,
        'story': 'Successfully completed heart surgery',
        'photo': 'https://i.pravatar.cc/150?img=5',
        'lastUpdate': DateTime.now().subtract(const Duration(days: 3)),
        'progress': 100,
        'campaignId': 'camp_health_002',
      },
      {
        'id': 'ben_006',
        'name': 'Suresh Rao',
        'age': 42,
        'location': 'Hyderabad, India',
        'lat': 17.3850,
        'lng': 78.4867,
        'category': 'Food',
        'needsMet': false,
        'donationReceived': 95.0,
        'targetAmount': 200.0,
        'story': 'Single parent, needs monthly groceries',
        'photo': 'https://i.pravatar.cc/150?img=6',
        'lastUpdate': DateTime.now().subtract(const Duration(hours: 8)),
        'progress': 48,
        'campaignId': 'camp_food_002',
      },
    ];
  }

  /// Get heatmap data for donation density
  List<Map<String, dynamic>> getDonationHeatmap() {
    return [
      {'lat': 19.0760, 'lng': 72.8777, 'weight': 0.8}, // Mumbai - High
      {'lat': 28.7041, 'lng': 77.1025, 'weight': 0.6}, // Delhi - Medium
      {'lat': 12.9716, 'lng': 77.5946, 'weight': 0.9}, // Bangalore - High
      {'lat': 26.9124, 'lng': 75.7873, 'weight': 0.4}, // Jaipur - Low
      {'lat': 23.0225, 'lng': 72.5714, 'weight': 0.7}, // Ahmedabad - Medium-High
      {'lat': 17.3850, 'lng': 78.4867, 'weight': 0.5}, // Hyderabad - Medium
    ];
  }

  /// Get beneficiary details by ID
  Map<String, dynamic> getBeneficiaryDetails(String beneficiaryId) {
    final beneficiaries = getBeneficiaries();
    final beneficiary = beneficiaries.firstWhere(
      (b) => b['id'] == beneficiaryId,
      orElse: () => beneficiaries.first,
    );

    return {
      ...beneficiary,
      'fullStory': 'Detailed story about ${beneficiary['name']}\'s journey...',
      'updates': [
        {
          'date': DateTime.now().subtract(const Duration(days: 1)),
          'message': 'Received first installment of funds',
          'amount': 100.0,
        },
        {
          'date': DateTime.now().subtract(const Duration(days: 5)),
          'message': 'Application verified and approved',
        },
      ],
      'photos': [
        'https://picsum.photos/seed/${beneficiaryId}1/400/300',
        'https://picsum.photos/seed/${beneficiaryId}2/400/300',
      ],
      'documents': [
        {'type': 'ID Proof', 'verified': true},
        {'type': 'Address Proof', 'verified': true},
        {'type': 'Income Certificate', 'verified': true},
      ],
    };
  }

  /// Track donation to specific beneficiary
  Future<Map<String, dynamic>> trackDonationToBeneficiary({
    required String beneficiaryId,
    required double amount,
    required String donorId,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    return {
      'success': true,
      'transactionHash': '0x${_generateHash()}',
      'beneficiary': beneficiaryId,
      'amount': amount,
      'timestamp': DateTime.now().toIso8601String(),
      'estimatedDelivery': DateTime.now().add(const Duration(hours: 24)),
      'smsNotificationSent': true,
      'trackingUrl': 'https://charitychain.org/track/$beneficiaryId',
    };
  }

  /// Get impact statistics by region
  Map<String, dynamic> getRegionalImpact() {
    return {
      'totalBeneficiaries': 1247,
      'regionsServed': 15,
      'categories': {
        'Education': 542,
        'Healthcare': 385,
        'Food': 320,
      },
      'byRegion': {
        'Mumbai': {'count': 245, 'funded': 198},
        'Delhi': {'count': 189, 'funded': 156},
        'Bangalore': {'count': 312, 'funded': 289},
        'Jaipur': {'count': 98, 'funded': 67},
        'Ahmedabad': {'count': 156, 'funded': 134},
        'Hyderabad': {'count': 247, 'funded': 203},
      },
    };
  }

  String _generateHash() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(64, (index) => chars[_random.nextInt(chars.length)]).join();
  }
}
