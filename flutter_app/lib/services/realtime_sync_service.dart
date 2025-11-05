import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Real-time Firebase Firestore synchronization service
/// Enables live collaborative features and instant updates
class RealtimeSyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Stream controllers for real-time updates
  final _donationController = StreamController<Map<String, dynamic>>.broadcast();
  final _campaignController = StreamController<Map<String, dynamic>>.broadcast();
  final _beneficiaryController = StreamController<Map<String, dynamic>>.broadcast();
  
  Stream<Map<String, dynamic>> get donationStream => _donationController.stream;
  Stream<Map<String, dynamic>> get campaignStream => _campaignController.stream;
  Stream<Map<String, dynamic>> get beneficiaryStream => _beneficiaryController.stream;

  /// Listen to real-time donation updates
  StreamSubscription<QuerySnapshot> listenToDonations() {
    return _firestore
        .collection('donations')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final data = change.doc.data() as Map<String, dynamic>;
          _donationController.add({
            'id': change.doc.id,
            'type': 'NEW_DONATION',
            'amount': data['amount'],
            'campaignId': data['campaignId'],
            'donorName': data['donorName'],
            'timestamp': data['timestamp'],
          });
        }
      }
    });
  }

  /// Listen to campaign progress updates
  StreamSubscription<QuerySnapshot> listenToCampaigns() {
    return _firestore
        .collection('campaigns')
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.modified) {
          final data = change.doc.data() as Map<String, dynamic>;
          _campaignController.add({
            'id': change.doc.id,
            'type': 'CAMPAIGN_UPDATE',
            'raised': data['raised'],
            'goal': data['goal'],
            'progress': (data['raised'] / data['goal'] * 100).toInt(),
          });
        }
      }
    });
  }

  /// Listen to beneficiary status updates
  StreamSubscription<QuerySnapshot> listenToBeneficiaries() {
    return _firestore
        .collection('beneficiaries')
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.modified) {
          final data = change.doc.data() as Map<String, dynamic>;
          _beneficiaryController.add({
            'id': change.doc.id,
            'type': 'BENEFICIARY_UPDATE',
            'name': data['name'],
            'needsMet': data['needsMet'],
            'progress': data['progress'],
          });
        }
      }
    });
  }

  /// Create new donation (syncs to all clients)
  Future<void> createDonation({
    required String campaignId,
    required double amount,
    required String donorId,
    required String donorName,
    required String transactionHash,
  }) async {
    await _firestore.collection('donations').add({
      'campaignId': campaignId,
      'amount': amount,
      'donorId': donorId,
      'donorName': donorName,
      'transactionHash': transactionHash,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'confirmed',
    });
  }

  /// Update campaign progress (syncs to all clients)
  Future<void> updateCampaignProgress({
    required String campaignId,
    required double newAmount,
  }) async {
    final campaignRef = _firestore.collection('campaigns').doc(campaignId);
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(campaignRef);
      final currentRaised = snapshot.data()?['raised'] ?? 0.0;
      transaction.update(campaignRef, {
        'raised': currentRaised + newAmount,
        'lastDonation': FieldValue.serverTimestamp(),
        'donorCount': FieldValue.increment(1),
      });
    });
  }

  /// Update beneficiary status (syncs to all clients)
  Future<void> updateBeneficiaryStatus({
    required String beneficiaryId,
    required bool needsMet,
    required int progress,
  }) async {
    await _firestore.collection('beneficiaries').doc(beneficiaryId).update({
      'needsMet': needsMet,
      'progress': progress,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  /// Get live global statistics
  Stream<Map<String, dynamic>> getGlobalStatsStream() {
    return _firestore
        .collection('global_stats')
        .doc('live')
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data() ?? {};
      return {
        'totalDonations': data['totalDonations'] ?? 0,
        'totalAmount': data['totalAmount'] ?? 0.0,
        'activeCampaigns': data['activeCampaigns'] ?? 0,
        'beneficiariesHelped': data['beneficiariesHelped'] ?? 0,
        'lastUpdate': data['lastUpdate'],
      };
    });
  }

  /// Get online users (presence system)
  Stream<int> getOnlineUsersStream() {
    return _firestore
        .collection('presence')
        .where('status', isEqualTo: 'online')
        .where('lastSeen', isGreaterThan: DateTime.now().subtract(Duration(minutes: 5)))
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  /// Set user presence (online/offline)
  Future<void> setUserPresence({
    required String userId,
    required bool online,
  }) async {
    await _firestore.collection('presence').doc(userId).set({
      'status': online ? 'online' : 'offline',
      'lastSeen': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Cleanup
  void dispose() {
    _donationController.close();
    _campaignController.close();
    _beneficiaryController.close();
  }
}
