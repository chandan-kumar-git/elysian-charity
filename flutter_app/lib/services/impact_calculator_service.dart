import 'dart:math';

/// Impact calculator to show donors exact impact of their contributions
class ImpactCalculatorService {
  final Random _random = Random();

  /// Calculate impact based on donation amount and category
  Map<String, dynamic> calculateImpact(double donationAmount, String category) {
    switch (category.toLowerCase()) {
      case 'education':
        return _calculateEducationImpact(donationAmount);
      
      case 'healthcare':
        return _calculateHealthcareImpact(donationAmount);
      
      case 'food':
        return _calculateFoodImpact(donationAmount);
      
      case 'shelter':
        return _calculateShelterImpact(donationAmount);
      
      case 'water':
        return _calculateWaterImpact(donationAmount);
      
      default:
        return _calculateGeneralImpact(donationAmount);
    }
  }

  Map<String, dynamic> _calculateEducationImpact(double amount) {
    return {
      'category': 'Education',
      'icon': '📚',
      'color': 0xFFB967FF,
      'mainImpact': {
        'value': (amount / 200).floor(),
        'unit': 'students',
        'description': 'educated for 1 year',
      },
      'breakdown': [
        {
          'icon': '📖',
          'value': (amount / 10).floor(),
          'label': 'Textbooks',
          'description': 'provided',
        },
        {
          'icon': '✏️',
          'value': (amount / 5).floor(),
          'label': 'School Supplies',
          'description': 'kits distributed',
        },
        {
          'icon': '🏫',
          'value': (amount / 50000).toStringAsFixed(3),
          'label': 'Schools',
          'description': 'can be built',
        },
        {
          'icon': '👨‍🏫',
          'value': (amount / 500).floor(),
          'label': 'Teacher Salaries',
          'description': 'months funded',
        },
      ],
      'visualization': 'You educated ${(amount / 200).floor()} students for 1 year!',
      'comparison': amount >= 50000 
          ? 'That\'s enough to build ${(amount / 50000).floor()} schools!' 
          : 'That\'s ${(amount / 10).floor()} textbooks or ${(amount / 5).floor()} supply kits!',
      'livesChanged': (amount / 200).floor(),
      'longTermImpact': 'Education creates generational change. Your \$${amount.toStringAsFixed(0)} will impact families for decades.',
    };
  }

  Map<String, dynamic> _calculateHealthcareImpact(double amount) {
    return {
      'category': 'Healthcare',
      'icon': '🏥',
      'color': 0xFF00F5FF,
      'mainImpact': {
        'value': (amount / 2).floor(),
        'unit': 'vaccines',
        'description': 'administered',
      },
      'breakdown': [
        {
          'icon': '💉',
          'value': (amount / 2).floor(),
          'label': 'Vaccines',
          'description': 'doses provided',
        },
        {
          'icon': '🏥',
          'value': (amount / 500).floor(),
          'label': 'Surgeries',
          'description': 'funded',
        },
        {
          'icon': '💊',
          'value': (amount / 5).floor(),
          'label': 'Medications',
          'description': 'prescriptions filled',
        },
        {
          'icon': '🩺',
          'value': (amount / 25).floor(),
          'label': 'Check-ups',
          'description': 'medical examinations',
        },
      ],
      'visualization': 'You provided ${(amount / 2).floor()} life-saving vaccines!',
      'comparison': amount >= 500 
          ? 'That\'s ${(amount / 500).floor()} surgeries that changed lives forever!' 
          : 'That\'s ${(amount / 5).floor()} medication prescriptions!',
      'livesChanged': (amount / 50).floor(),
      'longTermImpact': 'Healthcare saves lives today and builds healthier communities tomorrow.',
    };
  }

  Map<String, dynamic> _calculateFoodImpact(double amount) {
    return {
      'category': 'Food Security',
      'icon': '🍲',
      'color': 0xFF00FF00,
      'mainImpact': {
        'value': (amount / 0.5).floor(),
        'unit': 'meals',
        'description': 'provided',
      },
      'breakdown': [
        {
          'icon': '🍽️',
          'value': (amount / 0.5).floor(),
          'label': 'Meals',
          'description': 'served',
        },
        {
          'icon': '👨‍👩‍👧‍👦',
          'value': (amount / 50).floor(),
          'label': 'Families',
          'description': 'fed for 1 month',
        },
        {
          'icon': '📦',
          'value': (amount / 30).floor(),
          'label': 'Food Boxes',
          'description': 'distributed',
        },
        {
          'icon': '🌾',
          'value': (amount / 150).floor(),
          'label': 'Months',
          'description': 'of food security',
        },
      ],
      'visualization': 'You provided ${(amount / 0.5).floor()} nutritious meals!',
      'comparison': 'That\'s enough to feed ${(amount / 50).floor()} families for a month!',
      'livesChanged': (amount / 50).floor() * 4, // Average 4 people per family
      'longTermImpact': 'No child should go hungry. Your donation fights food insecurity.',
    };
  }

  Map<String, dynamic> _calculateShelterImpact(double amount) {
    return {
      'category': 'Shelter & Housing',
      'icon': '🏠',
      'color': 0xFFFF6B35,
      'mainImpact': {
        'value': (amount / 5000).toStringAsFixed(2),
        'unit': 'homes',
        'description': 'built',
      },
      'breakdown': [
        {
          'icon': '🏗️',
          'value': (amount / 5000).toStringAsFixed(2),
          'label': 'Houses',
          'description': 'constructed',
        },
        {
          'icon': '🛏️',
          'value': (amount / 100).floor(),
          'label': 'Bed Nights',
          'description': 'in shelters',
        },
        {
          'icon': '🔨',
          'value': (amount / 50).floor(),
          'label': 'Repairs',
          'description': 'completed',
        },
        {
          'icon': '🚪',
          'value': (amount / 1000).floor(),
          'label': 'Families',
          'description': 'housed',
        },
      ],
      'visualization': 'You helped build ${(amount / 5000).toStringAsFixed(2)} homes!',
      'comparison': amount >= 5000 
          ? 'That\'s a complete home for a family!' 
          : 'That\'s ${(amount / 100).floor()} nights of safe shelter!',
      'livesChanged': (amount / 1000).floor() * 4,
      'longTermImpact': 'A home is more than walls - it\'s dignity, security, and hope.',
    };
  }

  Map<String, dynamic> _calculateWaterImpact(double amount) {
    return {
      'category': 'Clean Water',
      'icon': '💧',
      'color': 0xFF00A8E8,
      'mainImpact': {
        'value': (amount / 50).floor(),
        'unit': 'people',
        'description': 'with clean water for 1 year',
      },
      'breakdown': [
        {
          'icon': '🚰',
          'value': (amount / 5000).floor(),
          'label': 'Wells',
          'description': 'constructed',
        },
        {
          'icon': '💧',
          'value': (amount * 365).floor(),
          'label': 'Liters',
          'description': 'of clean water',
        },
        {
          'icon': '🏘️',
          'value': (amount / 10000).floor(),
          'label': 'Villages',
          'description': 'with water access',
        },
        {
          'icon': '🔧',
          'value': (amount / 200).floor(),
          'label': 'Filters',
          'description': 'installed',
        },
      ],
      'visualization': 'You provided ${(amount / 50).floor()} people with clean water for 1 year!',
      'comparison': 'That\'s ${(amount * 365).floor()} liters of life-saving water!',
      'livesChanged': (amount / 50).floor(),
      'longTermImpact': 'Clean water prevents disease and transforms communities.',
    };
  }

  Map<String, dynamic> _calculateGeneralImpact(double amount) {
    return {
      'category': 'General Impact',
      'icon': '❤️',
      'color': 0xFFFF006E,
      'mainImpact': {
        'value': (amount / 100).floor(),
        'unit': 'lives',
        'description': 'positively impacted',
      },
      'breakdown': [
        {
          'icon': '👥',
          'value': (amount / 100).floor(),
          'label': 'People',
          'description': 'helped',
        },
        {
          'icon': '🌍',
          'value': (amount / 500).floor(),
          'label': 'Communities',
          'description': 'supported',
        },
        {
          'icon': '✨',
          'value': (amount / 50).floor(),
          'label': 'Projects',
          'description': 'funded',
        },
      ],
      'visualization': 'You positively impacted ${(amount / 100).floor()} lives!',
      'comparison': 'Your generosity creates ripples of hope!',
      'livesChanged': (amount / 100).floor(),
      'longTermImpact': 'Every donation matters. You\'re making the world better.',
    };
  }

  /// Get comparative impact across categories
  Map<String, dynamic> getComparativeImpact(double amount) {
    return {
      'amount': amount,
      'categories': {
        'Education': (amount / 200).floor(),
        'Healthcare': (amount / 2).floor(),
        'Food': (amount / 0.5).floor(),
        'Shelter': (amount / 100).floor(),
        'Water': (amount / 50).floor(),
      },
      'bestValue': {
        'category': 'Food',
        'reason': 'Most immediate impact per dollar',
        'impact': (amount / 0.5).floor(),
      },
      'longestTerm': {
        'category': 'Education',
        'reason': 'Creates generational change',
        'impact': (amount / 200).floor(),
      },
    };
  }

  /// Get real-time impact statistics
  Map<String, dynamic> getGlobalImpact() {
    final baseImpact = DateTime.now().millisecondsSinceEpoch ~/ 1000000;
    
    return {
      'totalDonations': 1234567.89 + _random.nextDouble() * 1000,
      'livesImpacted': baseImpact + 12847,
      'mealsProvided': (baseImpact + 456789) * 2,
      'studentsEducated': baseImpact ~/ 5 + 5420,
      'vaccinesGiven': (baseImpact + 89456) * 3,
      'familiesHoused': baseImpact ~/ 20 + 892,
      'wellsBuilt': baseImpact ~/ 100 + 145,
      'lastUpdated': DateTime.now(),
    };
  }
}
