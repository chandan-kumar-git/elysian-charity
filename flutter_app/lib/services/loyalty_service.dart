import 'dart:math' as math;

class LoyaltyService {
  static final LoyaltyService _instance = LoyaltyService._internal();
  factory LoyaltyService() => _instance;
  LoyaltyService._internal();

  final _random = math.Random();

  // Donor Tier Levels
  List<Map<String, dynamic>> getDonorTiers() {
    return [
      {
        'name': 'Bronze',
        'minDonation': 0,
        'rewardMultiplier': 1,
        'color': 0xFFCD7F32,
        'benefits': ['Standard impact reports', 'Email updates'],
        'icon': '🥉',
      },
      {
        'name': 'Silver',
        'minDonation': 1,
        'rewardMultiplier': 2,
        'color': 0xFFC0C0C0,
        'benefits': ['Monthly reports', 'Priority support', 'Tax receipts'],
        'icon': '🥈',
      },
      {
        'name': 'Gold',
        'minDonation': 5,
        'rewardMultiplier': 3,
        'color': 0xFFFFD700,
        'benefits': ['Voting rights', 'Quarterly calls', 'Impact NFTs', 'Early campaign access'],
        'icon': '🥇',
      },
      {
        'name': 'Platinum',
        'minDonation': 10,
        'rewardMultiplier': 5,
        'color': 0xFFE5E4E2,
        'benefits': ['Governance voting', 'Personal dashboard', 'Impact NFTs', 'VIP events'],
        'icon': '💎',
      },
      {
        'name': 'Diamond',
        'minDonation': 50,
        'rewardMultiplier': 10,
        'color': 0xFFB9F2FF,
        'benefits': ['Full governance', 'Direct charity contact', 'Custom campaigns', 'Media recognition'],
        'icon': '👑',
      },
    ];
  }

  // User's Loyalty Profile
  Map<String, dynamic> getUserLoyaltyProfile(String userId) {
    final totalDonated = 3.5 + _random.nextDouble() * 10;
    final tier = _calculateTier(totalDonated);
    final nextTier = _getNextTier(tier['name'] as String);
    
    return {
      'userId': userId,
      'totalDonated': totalDonated.toStringAsFixed(2),
      'donationCount': 12 + _random.nextInt(20),
      'rewardsEarned': (totalDonated * 1000).toInt(),
      'currentTier': {
        'name': tier['name'],
        'icon': tier['icon'],
        'color': tier['color'],
      },
      'nextTier': nextTier != null ? {
        'name': nextTier['name'],
        'icon': nextTier['icon'],
        'minDonation': nextTier['minDonation'],
      } : null,
      'joinDate': '2023-06-15',
      'campaignsSupported': 8 + _random.nextInt(15),
      'impactScore': 85 + _random.nextInt(15),
      'achievements': _getUserAchievements(),
      'rewardsRedeemable': true,
    };
  }

  Map<String, dynamic> _calculateTier(double totalDonated) {
    final tiers = getDonorTiers();
    for (var i = tiers.length - 1; i >= 0; i--) {
      if (totalDonated >= tiers[i]['minDonation']) {
        return tiers[i];
      }
    }
    return tiers[0];
  }

  Map<String, dynamic>? _getNextTier(String currentTier) {
    final tiers = getDonorTiers();
    final currentIndex = tiers.indexWhere((t) => t['name'] == currentTier);
    if (currentIndex < tiers.length - 1) {
      return tiers[currentIndex + 1];
    }
    return null;
  }

  // User Achievements
  List<Map<String, dynamic>> _getUserAchievements() {
    return [
      {'name': 'First Donation', 'icon': '🎉', 'date': '2023-06-15', 'earned': true},
      {'name': 'Consistent Giver', 'icon': '🔥', 'date': '2023-08-20', 'earned': true},
      {'name': 'Top Supporter', 'icon': '⭐', 'date': '2024-01-10', 'earned': true},
      {'name': 'Impact Champion', 'icon': '🏆', 'date': '2024-03-15', 'earned': true},
      {'name': 'Community Leader', 'icon': '👑', 'date': null, 'earned': false},
    ];
  }

  // Rewards Catalog
  List<Map<String, dynamic>> getRewardsCatalog() {
    return [
      {
        'id': 1,
        'name': 'Exclusive Impact NFT',
        'description': 'Limited edition NFT showcasing your impact',
        'cost': 1000,
        'icon': '🖼️',
        'category': 'Digital',
      },
      {
        'id': 2,
        'name': 'Personal Impact Report',
        'description': 'Detailed report of your donations and their impact',
        'cost': 500,
        'icon': '📊',
        'category': 'Report',
      },
      {
        'id': 3,
        'name': 'VIP Event Access',
        'description': 'Access to exclusive donor appreciation events',
        'cost': 2000,
        'icon': '🎫',
        'category': 'Experience',
      },
      {
        'id': 4,
        'name': 'Tax Optimization Guide',
        'description': 'Professional guidance on charitable tax deductions',
        'cost': 750,
        'icon': '💼',
        'category': 'Service',
      },
      {
        'id': 5,
        'name': 'Charity Merchandise',
        'description': 'Branded merchandise and impact swag',
        'cost': 300,
        'icon': '👕',
        'category': 'Physical',
      },
    ];
  }

  // Leaderboard
  List<Map<String, dynamic>> getLeaderboard() {
    final names = [
      'Sarah J.', 'Michael C.', 'Emma W.', 'James L.',
      'Olivia B.', 'David M.', 'Sophia G.', 'Daniel K.',
      'Ava R.', 'Ryan P.'
    ];
    
    return List.generate(10, (i) {
      return {
        'rank': i + 1,
        'name': names[i],
        'donations': (100 - i * 8).toString(),
        'amount': (50 - i * 4).toStringAsFixed(1),
        'tier': i < 2 ? 'Diamond' : i < 5 ? 'Platinum' : 'Gold',
        'badge': i < 3 ? ['🥇', '🥈', '🥉'][i] : '',
      };
    });
  }

  // Impact NFTs
  List<Map<String, dynamic>> getImpactNFTs(String userId) {
    return [
      {
        'id': 1,
        'name': 'Education Pioneer #247',
        'campaign': 'Schools for All',
        'impactScore': 95,
        'mintDate': '2024-03-15',
        'image': 'https://picsum.photos/400/400?random=1',
        'rarity': 'Rare',
        'icon': '📚',
        'color': 0xFFB967FF,
      },
      {
        'id': 2,
        'name': 'Healthcare Hero #189',
        'campaign': 'Medical Relief',
        'impactScore': 88,
        'mintDate': '2024-05-20',
        'image': 'https://picsum.photos/400/400?random=2',
        'rarity': 'Epic',
        'icon': '🏥',
        'color': 0xFF00F5FF,
      },
      {
        'id': 3,
        'name': 'Eco Warrior #523',
        'campaign': 'Green Future',
        'impactScore': 92,
        'mintDate': '2024-07-10',
        'image': 'https://picsum.photos/400/400?random=3',
        'rarity': 'Legendary',
        'icon': '🌱',
        'color': 0xFF00FF00,
      },
    ];
  }

  // Referral Program
  Map<String, dynamic> getReferralStats(String userId) {
    return {
      'referralCode': 'IMPACT${_random.nextInt(99999).toString().padLeft(5, '0')}',
      'totalReferrals': 5 + _random.nextInt(10),
      'activeReferrals': 3 + _random.nextInt(5),
      'bonusEarned': (250 + _random.nextInt(500)).toString(),
      'nextMilestone': 10,
      'referralLink': 'https://elysium.io/ref/IMPACT12345',
    };
  }
}
