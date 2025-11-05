import 'dart:async';
import 'dart:math' as math;

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  final _transactionController = StreamController<MockTransaction>.broadcast();
  final _balanceController = StreamController<double>.broadcast();
  
  Stream<MockTransaction> get transactionStream => _transactionController.stream;
  Stream<double> get balanceStream => _balanceController.stream;
  
  Timer? _transactionTimer;
  Timer? _balanceTimer;
  
  double _currentBalance = 12.583;
  final _random = math.Random();
  
  final List<String> _donors = [
    'Sarah Johnson', 'Michael Chen', 'Emma Wilson', 'James Lee',
    'Olivia Brown', 'David Martinez', 'Sophia Garcia', 'Daniel Kim',
    'Ava Rodriguez', 'Ryan Patel', 'Isabella Clark', 'Matthew Singh',
    'Mia Thompson', 'Andrew White', 'Charlotte Davis', 'Joshua Taylor'
  ];
  
  final List<String> _categories = [
    'Education', 'Healthcare', 'Environment', 'Disaster Relief',
    'Clean Water', 'Food Security', 'Child Welfare', 'Women Empowerment'
  ];
  
  final List<String> _locations = [
    'New York, USA', 'London, UK', 'Tokyo, Japan', 'Singapore',
    'Dubai, UAE', 'Sydney, Australia', 'Toronto, Canada', 'Berlin, Germany',
    'Paris, France', 'Seoul, South Korea', 'Mumbai, India', 'São Paulo, Brazil'
  ];

  void startMockData() {
    // Generate new transaction every 5-10 seconds
    _transactionTimer = Timer.periodic(const Duration(seconds: 7), (timer) {
      _generateTransaction();
    });
    
    // Update balance every 3 seconds
    _balanceTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _updateBalance();
    });
  }
  
  void stopMockData() {
    _transactionTimer?.cancel();
    _balanceTimer?.cancel();
  }
  
  void _generateTransaction() {
    final isDonation = _random.nextBool();
    final amount = isDonation 
        ? 0.1 + _random.nextDouble() * 2.0  // Donations: 0.1 - 2.1 ETH
        : 0.5 + _random.nextDouble() * 1.5; // Withdrawals: 0.5 - 2.0 ETH
    
    final transaction = MockTransaction(
      type: isDonation ? TransactionType.donation : TransactionType.withdrawal,
      amount: amount,
      donor: _donors[_random.nextInt(_donors.length)],
      category: _categories[_random.nextInt(_categories.length)],
      location: _locations[_random.nextInt(_locations.length)],
      hash: _generateTxHash(),
      timestamp: DateTime.now(),
    );
    
    _transactionController.add(transaction);
    
    // Update balance
    if (isDonation) {
      _currentBalance += amount;
    } else {
      _currentBalance -= amount;
    }
  }
  
  void _updateBalance() {
    // Small random fluctuations
    final change = (_random.nextDouble() - 0.5) * 0.1;
    _currentBalance += change;
    _balanceController.add(_currentBalance);
  }
  
  String _generateTxHash() {
    const chars = '0123456789abcdef';
    return '0x' + List.generate(40, (i) => chars[_random.nextInt(chars.length)]).join();
  }
  
  // Generate initial transactions
  List<MockTransaction> getInitialTransactions() {
    return List.generate(5, (i) {
      final isDonation = i % 2 == 0;
      return MockTransaction(
        type: isDonation ? TransactionType.donation : TransactionType.withdrawal,
        amount: 0.5 + _random.nextDouble() * 1.5,
        donor: _donors[_random.nextInt(_donors.length)],
        category: _categories[_random.nextInt(_categories.length)],
        location: _locations[_random.nextInt(_locations.length)],
        hash: _generateTxHash(),
        timestamp: DateTime.now().subtract(Duration(minutes: i * 5)),
      );
    });
  }
  
  void dispose() {
    _transactionController.close();
    _balanceController.close();
    stopMockData();
  }
}

enum TransactionType { donation, withdrawal }

class MockTransaction {
  final TransactionType type;
  final double amount;
  final String donor;
  final String category;
  final String location;
  final String hash;
  final DateTime timestamp;
  
  MockTransaction({
    required this.type,
    required this.amount,
    required this.donor,
    required this.category,
    required this.location,
    required this.hash,
    required this.timestamp,
  });
  
  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
  
  String get shortHash => '${hash.substring(0, 6)}...${hash.substring(hash.length - 4)}';
}
