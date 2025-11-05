import 'dart:async';
import 'dart:math' as math;

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final _random = math.Random();
  
  // Mock Analytics Data
  Map<String, dynamic> getDashboardMetrics() {
    return {
      'totalDonations': '1.2B+',
      'totalValue': '\$${(1200 + _random.nextInt(50)).toString()}M',
      'activeCampaigns': (547 + _random.nextInt(20)).toString(),
      'successRate': '${(94 + _random.nextInt(6))}%',
      'registeredUsers': '${(50000 + _random.nextInt(5000))}+',
      'activeToday': (1523 + _random.nextInt(200)).toString(),
      'countries': '47+',
      'partneredNGOs': '230+',
      'averageDonation': '\$${(450 + _random.nextInt(50))}',
      'repeatDonors': '${(67 + _random.nextInt(5))}%',
    };
  }
  
  // Campaign Performance Grades
  Map<String, dynamic> getCampaignPerformance(int campaignId) {
    final grades = ['A+', 'A', 'A-', 'B+', 'B'];
    final grade = grades[_random.nextInt(grades.length)];
    
    return {
      'grade': grade,
      'fundingVelocity': '${(15 + _random.nextInt(10))} ETH/day',
      'donorRetention': '${(75 + _random.nextInt(20))}%',
      'avgDonation': '${(0.5 + _random.nextDouble() * 2).toStringAsFixed(2)} ETH',
      'projectedCompletion': '${(5 + _random.nextInt(15))} days',
      'impactScore': (85 + _random.nextInt(15)),
      'transparencyRating': (4.5 + _random.nextDouble() * 0.5).toStringAsFixed(1),
    };
  }
  
  // Monthly Donation Trends (last 6 months)
  List<Map<String, dynamic>> getMonthlyTrends() {
    final months = ['Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov'];
    return months.map((month) {
      return {
        'month': month,
        'amount': (50 + _random.nextInt(100)).toDouble(),
        'donations': (150 + _random.nextInt(100)),
      };
    }).toList();
  }
  
  // Category-wise Distribution
  List<Map<String, dynamic>> getCategoryDistribution() {
    return [
      {'name': 'Education', 'icon': '📚', 'amount': 45200, 'percentage': 32, 'color': 0xFF3b82f6},
      {'name': 'Healthcare', 'icon': '🏥', 'amount': 38700, 'percentage': 27, 'color': 0xFFef4444},
      {'name': 'Environment', 'icon': '🌱', 'amount': 22100, 'percentage': 16, 'color': 0xFF10b981},
      {'name': 'Disaster Relief', 'icon': '🚨', 'amount': 19400, 'percentage': 14, 'color': 0xFFf59e0b},
      {'name': 'Other', 'icon': '💼', 'amount': 15600, 'percentage': 11, 'color': 0xFF8b5cf6},
    ];
  }
  
  // Top Donors (Mock Data)
  List<Map<String, dynamic>> getTopDonors() {
    final names = [
      'Sarah Johnson', 'Michael Chen', 'Emma Wilson', 'James Lee',
      'Olivia Brown', 'David Martinez', 'Sophia Garcia', 'Daniel Kim'
    ];
    
    final tierColors = {
      'Diamond': 0xFFB9F2FF,
      'Platinum': 0xFFE5E4E2,
      'Gold': 0xFFFFD700,
      'Silver': 0xFFC0C0C0,
    };
    
    return List.generate(8, (i) {
      final tier = i < 2 ? 'Diamond' : i < 4 ? 'Platinum' : i < 6 ? 'Gold' : 'Silver';
      return {
        'rank': i + 1,
        'name': names[i],
        'totalDonated': (50 - i * 5 + _random.nextDouble() * 5).toStringAsFixed(2),
        'donationCount': (25 - i * 2 + _random.nextInt(5)),
        'tier': tier,
        'tierColor': tierColors[tier],
        'avatar': 'https://i.pravatar.cc/150?img=${i + 1}',
      };
    });
  }
  
  // Recent Milestones Achieved
  List<Map<String, dynamic>> getRecentMilestones() {
    final milestones = [
      {'title': '1 Million Meals Provided', 'category': 'Food Security', 'date': 'Today'},
      {'title': '500 Schools Built', 'category': 'Education', 'date': '2 days ago'},
      {'title': '10,000 Clean Water Wells', 'category': 'Water', 'date': '5 days ago'},
      {'title': '50,000 Medical Checkups', 'category': 'Healthcare', 'date': '1 week ago'},
      {'title': '100K Trees Planted', 'category': 'Environment', 'date': '2 weeks ago'},
    ];
    
    return milestones;
  }
  
  // Global Impact Map Data
  List<Map<String, dynamic>> getGlobalImpact() {
    return [
      {'country': 'United States', 'donations': 12500, 'campaigns': 45, 'lat': 37.0902, 'lng': -95.7129},
      {'country': 'United Kingdom', 'donations': 8900, 'campaigns': 32, 'lat': 55.3781, 'lng': -3.4360},
      {'country': 'India', 'donations': 15600, 'campaigns': 67, 'lat': 20.5937, 'lng': 78.9629},
      {'country': 'Germany', 'donations': 6700, 'campaigns': 28, 'lat': 51.1657, 'lng': 10.4515},
      {'country': 'Australia', 'donations': 5400, 'campaigns': 21, 'lat': -25.2744, 'lng': 133.7751},
      {'country': 'Canada', 'donations': 7200, 'campaigns': 30, 'lat': 56.1304, 'lng': -106.3468},
      {'country': 'Japan', 'donations': 9100, 'campaigns': 38, 'lat': 36.2048, 'lng': 138.2529},
      {'country': 'Brazil', 'donations': 4800, 'campaigns': 25, 'lat': -14.2350, 'lng': -51.9253},
    ];
  }
  
  // Fraud Detection Alerts (Mock)
  List<Map<String, dynamic>> getFraudAlerts() {
    return [
      {
        'severity': 'low',
        'campaign': 'Education for All',
        'reason': 'Unusual withdrawal pattern detected',
        'status': 'Investigating',
        'date': '2 hours ago'
      },
      {
        'severity': 'medium',
        'campaign': 'Clean Water Initiative',
        'reason': 'Document verification pending',
        'status': 'Under Review',
        'date': '1 day ago'
      },
    ];
  }
  
  // Compliance Status
  Map<String, dynamic> getComplianceStatus() {
    return {
      'kycVerified': 230,
      'kycPending': 15,
      'amlCleared': 225,
      'amlInReview': 20,
      'taxCompliant': 218,
      'auditsPassed': 45,
      'overallScore': 94,
    };
  }
  
  // Live Activity Stream
  Stream<Map<String, dynamic>> getLiveActivityStream() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 8 + _random.nextInt(5)));
      
      final activities = [
        {'type': 'donation', 'icon': '💰', 'text': 'received 2.5 ETH donation', 'user': 'Anonymous'},
        {'type': 'campaign', 'icon': '🎯', 'text': 'launched new campaign', 'user': 'Save The Children'},
        {'type': 'milestone', 'icon': '🏆', 'text': 'reached 80% funding goal', 'user': 'Education Fund'},
        {'type': 'withdraw', 'icon': '📤', 'text': 'withdrew 5.2 ETH for supplies', 'user': 'Medical Relief'},
        {'type': 'verify', 'icon': '✅', 'text': 'completed KYC verification', 'user': 'Green Earth Org'},
      ];
      
      final activity = activities[_random.nextInt(activities.length)];
      yield {
        ...activity,
        'timestamp': DateTime.now(),
        'location': _getRandomLocation(),
      };
    }
  }
  
  String _getRandomLocation() {
    final locations = [
      'New York, USA', 'London, UK', 'Tokyo, Japan', 'Singapore',
      'Dubai, UAE', 'Sydney, Australia', 'Toronto, Canada', 'Berlin, Germany'
    ];
    return locations[_random.nextInt(locations.length)];
  }
  
  // Emergency Campaigns
  List<Map<String, dynamic>> getEmergencyCampaigns() {
    return [
      {
        'title': 'Hurricane Relief Fund',
        'location': 'Florida, USA',
        'urgency': 10,
        'target': 50000,
        'raised': 38500,
        'hours': 18,
        'status': 'CRITICAL',
      },
      {
        'title': 'Earthquake Emergency',
        'location': 'Turkey',
        'urgency': 9,
        'target': 75000,
        'raised': 65200,
        'hours': 36,
        'status': 'URGENT',
      },
    ];
  }
}
