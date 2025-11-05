import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Real-time service for live data updates
class RealTimeService extends ChangeNotifier {
  static final RealTimeService _instance = RealTimeService._internal();
  factory RealTimeService() => _instance;
  RealTimeService._internal();

  // Streams
  final _priceStreamController = StreamController<Map<String, double>>.broadcast();
  final _transactionStreamController = StreamController<Transaction>.broadcast();
  final _notificationStreamController = StreamController<AppNotification>.broadcast();
  final _socialStreamController = StreamController<SocialPost>.broadcast();

  Stream<Map<String, double>> get priceStream => _priceStreamController.stream;
  Stream<Transaction> get transactionStream => _transactionStreamController.stream;
  Stream<AppNotification> get notificationStream => _notificationStreamController.stream;
  Stream<SocialPost> get socialStream => _socialStreamController.stream;

  // Current data
  Map<String, double> _currentPrices = {
    'ETH': 1842.35,
    'BTC': 43521.87,
    'USDC': 1.00,
    'MATIC': 0.82,
  };

  Timer? _priceUpdateTimer;
  Timer? _transactionTimer;
  Timer? _socialTimer;
  bool _isActive = false;

  // Firestore instance
  FirebaseFirestore? _firestore;

  /// Initialize real-time services
  Future<void> initialize() async {
    if (_isActive) return;
    _isActive = true;

    try {
      _firestore = FirebaseFirestore.instance;
      print('✅ Real-time service initialized with Firebase');
    } catch (e) {
      print('⚠️ Firebase not available, using mock data: $e');
    }

    _startPriceUpdates();
    _startTransactionStream();
    _startSocialStream();
  }

  /// Start live crypto price updates
  void _startPriceUpdates() {
    _priceUpdateTimer?.cancel();
    _priceUpdateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      // Simulate price fluctuations
      _currentPrices = _currentPrices.map((key, value) {
        final random = Random();
        final change = (random.nextDouble() - 0.5) * value * 0.002; // ±0.2%
        return MapEntry(key, value + change);
      });

      _priceStreamController.add(_currentPrices);
      notifyListeners();
    });
  }

  /// Start transaction stream
  void _startTransactionStream() {
    _transactionTimer?.cancel();
    _transactionTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final transaction = _generateMockTransaction();
      _transactionStreamController.add(transaction);

      // Send notification for received transactions
      if (transaction.type == TransactionType.received) {
        _notificationStreamController.add(AppNotification(
          title: 'Received ${transaction.amount} ${transaction.symbol}',
          message: 'From ${transaction.from}',
          timestamp: DateTime.now(),
          type: NotificationType.transaction,
        ));
      }
    });
  }

  /// Start social feed stream
  void _startSocialStream() {
    _socialTimer?.cancel();
    _socialTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      final post = _generateMockPost();
      _socialStreamController.add(post);

      _notificationStreamController.add(AppNotification(
        title: 'New post from ${post.username}',
        message: post.content.substring(0, min(50, post.content.length)),
        timestamp: DateTime.now(),
        type: NotificationType.social,
      ));
    });
  }

  /// Generate mock transaction
  Transaction _generateMockTransaction() {
    final random = Random();
    final types = [TransactionType.sent, TransactionType.received, TransactionType.swap];
    final symbols = ['ETH', 'BTC', 'USDC', 'MATIC'];
    final type = types[random.nextInt(types.length)];
    final symbol = symbols[random.nextInt(symbols.length)];

    return Transaction(
      type: type,
      amount: random.nextDouble() * 5,
      symbol: symbol,
      from: type == TransactionType.received ? '0x${_randomHex(8)}' : null,
      to: type == TransactionType.sent ? '0x${_randomHex(8)}' : null,
      timestamp: DateTime.now(),
      status: TransactionStatus.confirmed,
      hash: '0x${_randomHex(64)}',
    );
  }

  /// Generate mock social post
  SocialPost _generateMockPost() {
    final random = Random();
    final usernames = ['CharityHero', 'CryptoGiver', 'ImpactDAO', 'BlockchainForGood'];
    final avatars = ['🦸', '🎁', '🌟', '⛓️'];
    final contents = [
      'Just made another donation! Every bit helps! 💙',
      'Matching donations today! Let\'s go! 🚀',
      'Transparency is everything in charity 📊',
      'Together we can make a difference! 🌍',
    ];

    final index = random.nextInt(usernames.length);
    return SocialPost(
      username: usernames[index],
      avatar: avatars[index],
      content: contents[random.nextInt(contents.length)],
      likes: random.nextInt(1000) + 100,
      comments: random.nextInt(100) + 10,
      timestamp: DateTime.now(),
    );
  }

  /// Get current crypto price
  double getPrice(String symbol) {
    return _currentPrices[symbol] ?? 0.0;
  }

  /// Send transaction to Firebase
  Future<void> sendTransaction(Transaction transaction) async {
    if (_firestore != null) {
      try {
        await _firestore!.collection('transactions').add({
          'type': transaction.type.toString(),
          'amount': transaction.amount,
          'symbol': transaction.symbol,
          'from': transaction.from,
          'to': transaction.to,
          'timestamp': FieldValue.serverTimestamp(),
          'status': transaction.status.toString(),
          'hash': transaction.hash,
        });
        print('✅ Transaction saved to Firebase');
      } catch (e) {
        print('⚠️ Failed to save transaction: $e');
      }
    }
    _transactionStreamController.add(transaction);
  }

  /// Post to social feed
  Future<void> postToSocial(SocialPost post) async {
    if (_firestore != null) {
      try {
        await _firestore!.collection('social_posts').add({
          'username': post.username,
          'avatar': post.avatar,
          'content': post.content,
          'likes': post.likes,
          'comments': post.comments,
          'timestamp': FieldValue.serverTimestamp(),
        });
        print('✅ Post saved to Firebase');
      } catch (e) {
        print('⚠️ Failed to save post: $e');
      }
    }
    _socialStreamController.add(post);
  }

  /// Listen to Firebase transactions
  Stream<List<Transaction>> listenToTransactions() {
    if (_firestore != null) {
      return _firestore!
          .collection('transactions')
          .orderBy('timestamp', descending: true)
          .limit(20)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return Transaction(
            type: _parseTransactionType(data['type']),
            amount: (data['amount'] as num).toDouble(),
            symbol: data['symbol'],
            from: data['from'],
            to: data['to'],
            timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
            status: _parseTransactionStatus(data['status']),
            hash: data['hash'],
          );
        }).toList();
      });
    }
    return Stream.value([]);
  }

  /// Listen to Firebase social posts
  Stream<List<SocialPost>> listenToSocialFeed() {
    if (_firestore != null) {
      return _firestore!
          .collection('social_posts')
          .orderBy('timestamp', descending: true)
          .limit(20)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return SocialPost(
            username: data['username'],
            avatar: data['avatar'],
            content: data['content'],
            likes: data['likes'],
            comments: data['comments'],
            timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
          );
        }).toList();
      });
    }
    return Stream.value([]);
  }

  /// Clean up
  void dispose() {
    _priceUpdateTimer?.cancel();
    _transactionTimer?.cancel();
    _socialTimer?.cancel();
    _priceStreamController.close();
    _transactionStreamController.close();
    _notificationStreamController.close();
    _socialStreamController.close();
    _isActive = false;
    super.dispose();
  }

  // Helper methods
  String _randomHex(int length) {
    final random = Random();
    return List.generate(length, (index) {
      return random.nextInt(16).toRadixString(16);
    }).join();
  }

  TransactionType _parseTransactionType(String? type) {
    if (type == null) return TransactionType.sent;
    if (type.contains('received')) return TransactionType.received;
    if (type.contains('swap')) return TransactionType.swap;
    return TransactionType.sent;
  }

  TransactionStatus _parseTransactionStatus(String? status) {
    if (status == null) return TransactionStatus.pending;
    if (status.contains('confirmed')) return TransactionStatus.confirmed;
    if (status.contains('failed')) return TransactionStatus.failed;
    return TransactionStatus.pending;
  }
}

// Data models
enum TransactionType { sent, received, swap }
enum TransactionStatus { pending, confirmed, failed }
enum NotificationType { transaction, social, system }

class Transaction {
  final TransactionType type;
  final double amount;
  final String symbol;
  final String? from;
  final String? to;
  final DateTime timestamp;
  final TransactionStatus status;
  final String hash;

  Transaction({
    required this.type,
    required this.amount,
    required this.symbol,
    this.from,
    this.to,
    required this.timestamp,
    required this.status,
    required this.hash,
  });
}

class SocialPost {
  final String username;
  final String avatar;
  final String content;
  final int likes;
  final int comments;
  final DateTime timestamp;

  SocialPost({
    required this.username,
    required this.avatar,
    required this.content,
    required this.likes,
    required this.comments,
    required this.timestamp,
  });
}

class AppNotification {
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;

  AppNotification({
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
  });
}
