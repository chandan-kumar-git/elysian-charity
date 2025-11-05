import 'dart:async';
import 'dart:math' as math;

/// Real-time donation feed service with WebSocket simulation
class RealTimeDonationService {
  final StreamController<DonationEvent> _donationStreamController = StreamController<DonationEvent>.broadcast();
  Timer? _simulationTimer;
  bool _isActive = false;

  Stream<DonationEvent> get donationStream => _donationStreamController.stream;

  /// Start real-time donation feed
  void startLiveFeed() {
    if (_isActive) return;
    _isActive = true;

    // Simulate live donations every 3-8 seconds
    _simulationTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      _generateRandomDonation();
    });
  }

  /// Stop real-time feed
  void stopLiveFeed() {
    _isActive = false;
    _simulationTimer?.cancel();
  }

  /// Generate random donation event
  void _generateRandomDonation() {
    final random = math.Random();
    final donors = [
      'Sarah M.', 'John D.', 'Emily R.', 'Michael B.', 'Jessica L.',
      'David W.', 'Amanda K.', 'Chris P.', 'Lisa T.', 'Robert H.',
      'Anonymous', 'Maria G.', 'James F.', 'Sophie N.', 'Daniel C.',
    ];

    final campaigns = [
      {'name': 'Clean Water Project', 'id': 'water_001', 'emoji': '💧'},
      {'name': 'Education Fund', 'id': 'edu_001', 'emoji': '📚'},
      {'name': 'Medical Emergency', 'id': 'med_001', 'emoji': '🏥'},
      {'name': 'Disaster Relief', 'id': 'disaster_001', 'emoji': '🚨'},
      {'name': 'Food Distribution', 'id': 'food_001', 'emoji': '🍞'},
      {'name': 'Orphanage Support', 'id': 'orphan_001', 'emoji': '👶'},
    ];

    final countries = ['🇺🇸 USA', '🇬🇧 UK', '🇮🇳 India', '🇨🇦 Canada', '🇦🇺 Australia', '🇩🇪 Germany'];
    
    final amounts = [10, 25, 50, 100, 250, 500, 1000, 5000];
    final amount = amounts[random.nextInt(amounts.length)];
    final campaign = campaigns[random.nextInt(campaigns.length)];
    final donor = donors[random.nextInt(donors.length)];
    final country = countries[random.nextInt(countries.length)];

    final event = DonationEvent(
      id: 'don_${DateTime.now().millisecondsSinceEpoch}',
      donorName: donor,
      amount: amount.toDouble(),
      campaignName: campaign['name']!,
      campaignId: campaign['id']!,
      campaignEmoji: campaign['emoji']!,
      country: country,
      timestamp: DateTime.now(),
      txHash: '0x${_generateTxHash()}',
      isVerified: random.nextDouble() > 0.1, // 90% verified
    );

    _donationStreamController.add(event);
  }

  /// Generate fake transaction hash
  String _generateTxHash() {
    final random = math.Random();
    return List.generate(64, (index) => random.nextInt(16).toRadixString(16)).join();
  }

  /// Get recent donations (last 50)
  List<DonationEvent> getRecentDonations() {
    return _recentDonations;
  }

  /// Store recent donations in memory
  final List<DonationEvent> _recentDonations = [];

  /// Add donation to recent list
  void _addToRecent(DonationEvent event) {
    _recentDonations.insert(0, event);
    if (_recentDonations.length > 50) {
      _recentDonations.removeLast();
    }
  }

  /// Get live statistics
  Map<String, dynamic> getLiveStats() {
    return {
      'totalDonations': 8473,
      'totalAmount': 1847392.50,
      'activeDonors': 2847,
      'donationsToday': 234,
      'amountToday': 52847.50,
      'averageDonation': 217.85,
      'topCountry': '🇺🇸 USA',
      'trendingCampaign': '💧 Clean Water Project',
    };
  }

  /// Dispose resources
  void dispose() {
    _simulationTimer?.cancel();
    _donationStreamController.close();
  }
}

/// Donation event model
class DonationEvent {
  final String id;
  final String donorName;
  final double amount;
  final String campaignName;
  final String campaignId;
  final String campaignEmoji;
  final String country;
  final DateTime timestamp;
  final String txHash;
  final bool isVerified;

  DonationEvent({
    required this.id,
    required this.donorName,
    required this.amount,
    required this.campaignName,
    required this.campaignId,
    required this.campaignEmoji,
    required this.country,
    required this.timestamp,
    required this.txHash,
    required this.isVerified,
  });

  /// Get time ago string
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

/// Emergency Campaign Service - Auto-creates campaigns for disasters
class EmergencyCampaignService {
  final List<EmergencyCampaign> _activeCampaigns = [];

  /// Get active emergency campaigns
  List<EmergencyCampaign> getActiveCampaigns() {
    return _activeCampaigns;
  }

  /// Create emergency campaign
  EmergencyCampaign createEmergencyCampaign({
    required String title,
    required String location,
    required String description,
    required double goalAmount,
    required EmergencyType type,
  }) {
    final campaign = EmergencyCampaign(
      id: 'emergency_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      location: location,
      description: description,
      goalAmount: goalAmount,
      currentAmount: 0,
      type: type,
      createdAt: DateTime.now(),
      priority: _calculatePriority(type),
      affectedPeople: _estimateAffectedPeople(type),
    );

    _activeCampaigns.insert(0, campaign);
    return campaign;
  }

  /// Calculate priority based on emergency type
  int _calculatePriority(EmergencyType type) {
    switch (type) {
      case EmergencyType.earthquake:
        return 10;
      case EmergencyType.flood:
        return 9;
      case EmergencyType.fire:
        return 8;
      case EmergencyType.medical:
        return 9;
      case EmergencyType.famine:
        return 7;
      case EmergencyType.war:
        return 10;
      default:
        return 5;
    }
  }

  /// Estimate affected people
  int _estimateAffectedPeople(EmergencyType type) {
    final random = math.Random();
    switch (type) {
      case EmergencyType.earthquake:
        return 10000 + random.nextInt(90000);
      case EmergencyType.flood:
        return 5000 + random.nextInt(45000);
      case EmergencyType.fire:
        return 100 + random.nextInt(900);
      case EmergencyType.medical:
        return 1;
      case EmergencyType.famine:
        return 50000 + random.nextInt(150000);
      case EmergencyType.war:
        return 100000 + random.nextInt(400000);
      default:
        return 1000;
    }
  }

  /// Get emergency statistics
  Map<String, dynamic> getEmergencyStats() {
    final totalPeopleAffected = _activeCampaigns.fold<int>(
      0,
      (sum, campaign) => sum + campaign.affectedPeople,
    );

    final totalRaised = _activeCampaigns.fold<double>(
      0,
      (sum, campaign) => sum + campaign.currentAmount,
    );

    final totalGoal = _activeCampaigns.fold<double>(
      0,
      (sum, campaign) => sum + campaign.goalAmount,
    );

    return {
      'activeEmergencies': _activeCampaigns.length,
      'totalPeopleAffected': totalPeopleAffected,
      'totalRaised': totalRaised,
      'totalGoal': totalGoal,
      'progressPercentage': totalGoal > 0 ? (totalRaised / totalGoal * 100) : 0,
    };
  }
}

/// Emergency campaign model
class EmergencyCampaign {
  final String id;
  final String title;
  final String location;
  final String description;
  final double goalAmount;
  final double currentAmount;
  final EmergencyType type;
  final DateTime createdAt;
  final int priority;
  final int affectedPeople;

  EmergencyCampaign({
    required this.id,
    required this.title,
    required this.location,
    required this.description,
    required this.goalAmount,
    required this.currentAmount,
    required this.type,
    required this.createdAt,
    required this.priority,
    required this.affectedPeople,
  });

  /// Get progress percentage
  double get progressPercentage {
    return goalAmount > 0 ? (currentAmount / goalAmount * 100).clamp(0, 100) : 0;
  }

  /// Get urgency level
  String get urgencyLevel {
    if (priority >= 9) return 'CRITICAL';
    if (priority >= 7) return 'HIGH';
    if (priority >= 5) return 'MEDIUM';
    return 'LOW';
  }

  /// Get emoji for type
  String get typeEmoji {
    switch (type) {
      case EmergencyType.earthquake:
        return '🌊';
      case EmergencyType.flood:
        return '💧';
      case EmergencyType.fire:
        return '🔥';
      case EmergencyType.medical:
        return '🏥';
      case EmergencyType.famine:
        return '🍞';
      case EmergencyType.war:
        return '🕊️';
      default:
        return '🚨';
    }
  }
}

/// Emergency types
enum EmergencyType {
  earthquake,
  flood,
  fire,
  medical,
  famine,
  war,
  other,
}
