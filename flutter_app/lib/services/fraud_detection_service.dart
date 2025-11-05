import 'dart:async';
import 'dart:math';

/// AI-powered fraud detection and prevention
class FraudDetectionService {
  final Random _random = Random();
  final StreamController<FraudAlert> _alertController = StreamController<FraudAlert>.broadcast();

  Stream<FraudAlert> get alertStream => _alertController.stream;

  /// Start monitoring for suspicious activities
  void startMonitoring() {
    Timer.periodic(const Duration(seconds: 30), (timer) {
      // Simulate occasional fraud detection
      if (_random.nextInt(10) > 7) {
        _detectFraud();
      }
    });
  }

  void _detectFraud() {
    final alerts = getPendingAlerts();
    if (alerts.isNotEmpty && _random.nextBool()) {
      _alertController.add(FraudAlert(
        id: alerts.first['id'] as String,
        type: alerts.first['type'] as String,
        charityName: alerts.first['charityName'] as String,
        riskScore: alerts.first['riskScore'] as int,
        reason: alerts.first['reason'] as String,
        evidence: List<String>.from(alerts.first['evidence']),
        action: alerts.first['action'] as String,
        timestamp: DateTime.now(),
      ));
    }
  }

  /// Get current fraud statistics
  Map<String, dynamic> getFraudStats() {
    return {
      'totalMonitored': 15847,
      'fraudPrevented': 127,
      'moneySaved': 2847562.0,
      'activeAlerts': 3,
      'resolvedCases': 124,
      'falsePositives': 8,
      'accuracy': 98.5,
      'avgResponseTime': '45 seconds',
      'lastScan': DateTime.now().subtract(const Duration(seconds: 15)),
    };
  }

  /// Get pending fraud alerts
  List<Map<String, dynamic>> getPendingAlerts() {
    return [
      {
        'id': 'fraud_001',
        'type': 'SUSPICIOUS_WITHDRAWAL',
        'charityName': 'Hope Foundation',
        'charityId': 'charity_789',
        'riskScore': 87,
        'severity': 'HIGH',
        'reason': 'Unusual withdrawal pattern detected',
        'evidence': [
          '3 rapid withdrawals in 1 hour',
          'New bank account added 2 days ago',
          'Withdrawal amount 300% above average',
          'GPS location mismatch: India → Nigeria',
        ],
        'action': 'ACCOUNT_FROZEN',
        'actionTaken': true,
        'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
        'status': 'PENDING_REVIEW',
      },
      {
        'id': 'fraud_002',
        'type': 'DUPLICATE_CAMPAIGN',
        'charityName': 'Education Trust',
        'charityId': 'charity_456',
        'riskScore': 72,
        'severity': 'MEDIUM',
        'reason': 'Campaign content matches existing campaign',
        'evidence': [
          'Images 95% similar to campaign #1247',
          'Description contains copied text',
          'Same beneficiary photos used',
        ],
        'action': 'CAMPAIGN_FLAGGED',
        'actionTaken': true,
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'status': 'UNDER_INVESTIGATION',
      },
      {
        'id': 'fraud_003',
        'type': 'IDENTITY_THEFT',
        'charityName': 'Care & Share',
        'charityId': 'charity_123',
        'riskScore': 94,
        'severity': 'CRITICAL',
        'reason': 'Stolen identity used for registration',
        'evidence': [
          'KYC documents flagged as forged',
          'Face recognition mismatch',
          'Phone number reported as fraudulent',
          'Email domain suspicious',
        ],
        'action': 'ACCOUNT_SUSPENDED',
        'actionTaken': true,
        'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
        'status': 'BLOCKED',
      },
    ];
  }

  /// Get resolved fraud cases
  List<Map<String, dynamic>> getResolvedCases() {
    return [
      {
        'id': 'fraud_resolved_001',
        'type': 'SUSPICIOUS_DONATION',
        'charityName': 'Green Earth',
        'resolution': 'False positive - legitimate bulk donation',
        'recoveredAmount': 0.0,
        'resolvedDate': DateTime.now().subtract(const Duration(days: 2)),
        'investigationTime': '3 hours',
      },
      {
        'id': 'fraud_resolved_002',
        'type': 'FAKE_CHARITY',
        'charityName': 'Kids First',
        'resolution': 'Confirmed fraud - funds recovered',
        'recoveredAmount': 45000.0,
        'resolvedDate': DateTime.now().subtract(const Duration(days: 5)),
        'investigationTime': '12 hours',
      },
    ];
  }

  /// Analyze transaction for fraud
  Future<Map<String, dynamic>> analyzeTransaction({
    required String transactionId,
    required String charityId,
    required double amount,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    final riskScore = _random.nextInt(100);
    final isSuspicious = riskScore > 70;

    return {
      'transactionId': transactionId,
      'riskScore': riskScore,
      'status': isSuspicious ? 'FLAGGED' : 'APPROVED',
      'confidence': riskScore >= 90 ? 'HIGH' : riskScore >= 70 ? 'MEDIUM' : 'LOW',
      'flags': isSuspicious
          ? [
              'Amount exceeds normal range',
              'Unusual time of transaction',
            ]
          : [],
      'recommendation': isSuspicious ? 'MANUAL_REVIEW' : 'PROCEED',
      'analysisTime': '1.2 seconds',
    };
  }

  /// Get fraud prevention tips
  List<Map<String, dynamic>> getPreventionTips() {
    return [
      {
        'icon': '🔐',
        'title': 'Enable 2FA',
        'description': 'Add two-factor authentication for withdrawals',
        'priority': 'HIGH',
      },
      {
        'icon': '📱',
        'title': 'Verify Phone',
        'description': 'Keep your phone number verified and updated',
        'priority': 'MEDIUM',
      },
      {
        'icon': '🔔',
        'title': 'Enable Alerts',
        'description': 'Get instant notifications for all transactions',
        'priority': 'HIGH',
      },
      {
        'icon': '📊',
        'title': 'Review Activity',
        'description': 'Check your activity log regularly',
        'priority': 'LOW',
      },
    ];
  }

  void dispose() {
    _alertController.close();
  }
}

class FraudAlert {
  final String id;
  final String type;
  final String charityName;
  final int riskScore;
  final String reason;
  final List<String> evidence;
  final String action;
  final DateTime timestamp;

  FraudAlert({
    required this.id,
    required this.type,
    required this.charityName,
    required this.riskScore,
    required this.reason,
    required this.evidence,
    required this.action,
    required this.timestamp,
  });
}
