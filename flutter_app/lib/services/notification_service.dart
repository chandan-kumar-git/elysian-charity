import 'dart:async';
import 'dart:math' as math;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final _random = math.Random();
  final _notificationController = StreamController<Map<String, dynamic>>.broadcast();
  
  Stream<Map<String, dynamic>> get notificationStream => _notificationController.stream;

  // Notification Types
  final List<String> _notificationTypes = [
    'donation_received',
    'milestone_completed',
    'campaign_success',
    'withdrawal_approved',
    'fraud_alert',
    'kyc_verified',
    'reward_earned',
    'achievement_unlocked',
    'price_alert',
    'system_update',
  ];

  // Start real-time notifications
  void startNotifications() {
    Timer.periodic(const Duration(seconds: 15), (timer) {
      _notificationController.add(_generateNotification());
    });
  }

  Map<String, dynamic> _generateNotification() {
    final type = _notificationTypes[_random.nextInt(_notificationTypes.length)];
    
    switch (type) {
      case 'donation_received':
        return {
          'id': 'notif_${DateTime.now().millisecondsSinceEpoch}',
          'type': type,
          'title': 'New Donation Received!',
          'message': 'You received ${(0.1 + _random.nextDouble() * 5).toStringAsFixed(2)} ETH',
          'icon': '💰',
          'color': 0xFF00F5FF,
          'timestamp': DateTime.now(),
          'priority': 'high',
          'actionUrl': '/transactions',
          'read': false,
        };
      
      case 'milestone_completed':
        return {
          'id': 'notif_${DateTime.now().millisecondsSinceEpoch}',
          'type': type,
          'title': 'Milestone Completed!',
          'message': 'Phase ${_random.nextInt(5) + 1} has been successfully completed',
          'icon': '✅',
          'color': 0xFF00FF00,
          'timestamp': DateTime.now(),
          'priority': 'high',
          'actionUrl': '/milestones',
          'read': false,
        };
      
      case 'campaign_success':
        return {
          'id': 'notif_${DateTime.now().millisecondsSinceEpoch}',
          'type': type,
          'title': 'Campaign Successful!',
          'message': 'Education for All reached 100% funding!',
          'icon': '🎉',
          'color': 0xFFFFD700,
          'timestamp': DateTime.now(),
          'priority': 'high',
          'actionUrl': '/campaigns',
          'read': false,
        };
      
      case 'fraud_alert':
        return {
          'id': 'notif_${DateTime.now().millisecondsSinceEpoch}',
          'type': type,
          'title': 'Security Alert',
          'message': 'Suspicious activity detected - under review',
          'icon': '🚨',
          'color': 0xFFFF0000,
          'timestamp': DateTime.now(),
          'priority': 'critical',
          'actionUrl': '/compliance',
          'read': false,
        };
      
      case 'reward_earned':
        return {
          'id': 'notif_${DateTime.now().millisecondsSinceEpoch}',
          'type': type,
          'title': 'Reward Earned!',
          'message': 'You earned ${_random.nextInt(500) + 100} loyalty points',
          'icon': '⭐',
          'color': 0xFFFFD700,
          'timestamp': DateTime.now(),
          'priority': 'medium',
          'actionUrl': '/rewards',
          'read': false,
        };
      
      default:
        return {
          'id': 'notif_${DateTime.now().millisecondsSinceEpoch}',
          'type': type,
          'title': 'System Update',
          'message': 'New features available!',
          'icon': '🔔',
          'color': 0xFF00F5FF,
          'timestamp': DateTime.now(),
          'priority': 'low',
          'actionUrl': '/settings',
          'read': false,
        };
    }
  }

  // Get Recent Notifications
  List<Map<String, dynamic>> getRecentNotifications() {
    return List.generate(20, (i) {
      final type = _notificationTypes[_random.nextInt(_notificationTypes.length)];
      return {
        'id': 'notif_${1000 + i}',
        'type': type,
        'title': _getTitleForType(type),
        'message': _getMessageForType(type),
        'icon': _getIconForType(type),
        'color': _getColorForType(type),
        'timestamp': DateTime.now().subtract(Duration(hours: i * 2)),
        'priority': ['low', 'medium', 'high', 'critical'][_random.nextInt(4)],
        'actionUrl': _getActionUrlForType(type),
        'read': i > 5 ? true : false,
      };
    });
  }

  String _getTitleForType(String type) {
    switch (type) {
      case 'donation_received': return 'New Donation';
      case 'milestone_completed': return 'Milestone Reached';
      case 'campaign_success': return 'Campaign Success';
      case 'withdrawal_approved': return 'Withdrawal Approved';
      case 'fraud_alert': return 'Security Alert';
      case 'kyc_verified': return 'KYC Verified';
      case 'reward_earned': return 'Reward Earned';
      case 'achievement_unlocked': return 'Achievement Unlocked';
      case 'price_alert': return 'Price Alert';
      default: return 'System Update';
    }
  }

  String _getMessageForType(String type) {
    switch (type) {
      case 'donation_received': return '${(0.1 + _random.nextDouble() * 5).toStringAsFixed(2)} ETH received';
      case 'milestone_completed': return 'Phase ${_random.nextInt(5) + 1} completed successfully';
      case 'campaign_success': return 'Campaign reached funding goal!';
      case 'withdrawal_approved': return 'Funds released to charity';
      case 'fraud_alert': return 'Suspicious activity detected';
      case 'kyc_verified': return 'Your identity has been verified';
      case 'reward_earned': return '${_random.nextInt(500) + 100} points earned';
      case 'achievement_unlocked': return 'New achievement unlocked!';
      case 'price_alert': return 'ETH price: \$${(2400 + _random.nextInt(200))}';
      default: return 'Check out new features';
    }
  }

  String _getIconForType(String type) {
    switch (type) {
      case 'donation_received': return '💰';
      case 'milestone_completed': return '✅';
      case 'campaign_success': return '🎉';
      case 'withdrawal_approved': return '💸';
      case 'fraud_alert': return '🚨';
      case 'kyc_verified': return '✔️';
      case 'reward_earned': return '⭐';
      case 'achievement_unlocked': return '🏆';
      case 'price_alert': return '📈';
      default: return '🔔';
    }
  }

  int _getColorForType(String type) {
    switch (type) {
      case 'donation_received': return 0xFF00F5FF;
      case 'milestone_completed': return 0xFF00FF00;
      case 'campaign_success': return 0xFFFFD700;
      case 'withdrawal_approved': return 0xFF00F5FF;
      case 'fraud_alert': return 0xFFFF0000;
      case 'kyc_verified': return 0xFF00FF00;
      case 'reward_earned': return 0xFFFFD700;
      case 'achievement_unlocked': return 0xFFFF006E;
      case 'price_alert': return 0xFFB967FF;
      default: return 0xFF00F5FF;
    }
  }

  String _getActionUrlForType(String type) {
    switch (type) {
      case 'donation_received': return '/transactions';
      case 'milestone_completed': return '/milestones';
      case 'campaign_success': return '/campaigns';
      case 'withdrawal_approved': return '/transactions';
      case 'fraud_alert': return '/compliance';
      case 'kyc_verified': return '/profile';
      case 'reward_earned': return '/rewards';
      case 'achievement_unlocked': return '/achievements';
      case 'price_alert': return '/markets';
      default: return '/settings';
    }
  }

  // Get Unread Count
  int getUnreadCount() {
    return 5 + _random.nextInt(10);
  }

  // Get Notifications by Priority
  Map<String, List<Map<String, dynamic>>> getNotificationsByPriority() {
    final notifications = getRecentNotifications();
    
    return {
      'critical': notifications.where((n) => n['priority'] == 'critical').toList(),
      'high': notifications.where((n) => n['priority'] == 'high').toList(),
      'medium': notifications.where((n) => n['priority'] == 'medium').toList(),
      'low': notifications.where((n) => n['priority'] == 'low').toList(),
    };
  }

  // Notification Statistics
  Map<String, dynamic> getNotificationStats() {
    return {
      'total': 1250 + _random.nextInt(500),
      'unread': 5 + _random.nextInt(10),
      'todayCount': 15 + _random.nextInt(20),
      'thisWeekCount': 85 + _random.nextInt(50),
      'criticalCount': 2 + _random.nextInt(3),
      'byType': {
        'donation_received': 450,
        'milestone_completed': 120,
        'campaign_success': 85,
        'withdrawal_approved': 95,
        'fraud_alert': 5,
        'kyc_verified': 230,
        'reward_earned': 180,
        'achievement_unlocked': 45,
        'price_alert': 25,
        'system_update': 15,
      },
    };
  }

  // Alert Preferences
  Map<String, dynamic> getAlertPreferences() {
    return {
      'emailNotifications': true,
      'pushNotifications': true,
      'smsNotifications': false,
      'donationAlerts': true,
      'milestoneAlerts': true,
      'fraudAlerts': true,
      'priceAlerts': false,
      'weeklyDigest': true,
      'soundEnabled': true,
      'vibrationEnabled': true,
      'quietHours': {'enabled': true, 'start': '22:00', 'end': '08:00'},
    };
  }

  // Critical Alerts (Fraud, Security)
  List<Map<String, dynamic>> getCriticalAlerts() {
    return [
      {
        'id': 'alert_001',
        'type': 'fraud_alert',
        'severity': 'critical',
        'title': 'Unusual Withdrawal Pattern',
        'description': 'Multiple rapid withdrawals detected from Campaign #1245',
        'affectedCampaign': 'Education for All',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'status': 'investigating',
        'investigator': 'Security Team Alpha',
        'estimatedResolution': '24 hours',
      },
      {
        'id': 'alert_002',
        'type': 'security_alert',
        'severity': 'high',
        'title': 'Failed Login Attempts',
        'description': '5 failed login attempts from unknown IP',
        'ipAddress': '192.168.1.100',
        'location': 'Unknown Location',
        'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
        'status': 'blocked',
        'action': 'IP Blacklisted',
      },
    ];
  }

  // Activity Feed
  Stream<Map<String, dynamic>> getActivityFeed() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 10 + _random.nextInt(10)));
      
      final activities = [
        {'type': 'donation', 'message': 'New donation of ${(0.1 + _random.nextDouble() * 5).toStringAsFixed(2)} ETH', 'icon': '💰'},
        {'type': 'campaign', 'message': 'New campaign created: Health Initiative', 'icon': '🏥'},
        {'type': 'milestone', 'message': 'Milestone completed by Clean Water Project', 'icon': '✅'},
        {'type': 'withdrawal', 'message': 'Funds released to Education Foundation', 'icon': '💸'},
        {'type': 'verification', 'message': 'New charity verified: Hope for Tomorrow', 'icon': '✔️'},
      ];
      
      final activity = activities[_random.nextInt(activities.length)];
      yield {
        ...activity,
        'timestamp': DateTime.now(),
        'id': 'activity_${DateTime.now().millisecondsSinceEpoch}',
      };
    }
  }

  void dispose() {
    _notificationController.close();
  }
}
