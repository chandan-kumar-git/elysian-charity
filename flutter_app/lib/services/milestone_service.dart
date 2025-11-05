import 'dart:math' as math;

class MilestoneService {
  static final MilestoneService _instance = MilestoneService._internal();
  factory MilestoneService() => _instance;
  MilestoneService._internal();

  final _random = math.Random();

  // Campaign Milestones
  List<Map<String, dynamic>> getCampaignMilestones(int campaignId) {
    return [
      {
        'milestoneId': 1,
        'phase': 1,
        'name': 'Planning & Procurement',
        'title': 'Phase 1: Planning & Procurement',
        'description': 'Complete project planning and procurement of materials',
        'targetAmount': 10.0,
        'currentAmount': 10.0,
        'deadline': '2024-09-30',
        'status': 'Completed',
        'completedDate': '2024-09-28',
        'progress': 100,
        'deliverables': [
          {'name': 'Project Plan', 'status': 'Submitted', 'verified': true},
          {'name': 'Material Receipts', 'status': 'Submitted', 'verified': true},
          {'name': 'Vendor Contracts', 'status': 'Submitted', 'verified': true},
        ],
        'approvals': 5,
        'requiredApprovals': 3,
        'fundsReleased': true,
      },
      {
        'milestoneId': 2,
        'phase': 2,
        'name': 'Infrastructure Setup',
        'title': 'Phase 2: Infrastructure Setup',
        'description': 'Build basic infrastructure and setup facilities',
        'targetAmount': 15.0,
        'currentAmount': 15.0,
        'deadline': '2024-10-31',
        'status': 'Completed',
        'completedDate': '2024-10-29',
        'progress': 100,
        'deliverables': [
          {'name': 'Construction Photos', 'status': 'Submitted', 'verified': true},
          {'name': 'Safety Inspections', 'status': 'Submitted', 'verified': true},
          {'name': 'Progress Report', 'status': 'Submitted', 'verified': true},
        ],
        'approvals': 4,
        'requiredApprovals': 3,
        'fundsReleased': true,
      },
      {
        'milestoneId': 3,
        'phase': 3,
        'name': 'Equipment Installation',
        'title': 'Phase 3: Equipment Installation',
        'description': 'Install all necessary equipment and systems',
        'targetAmount': 20.0,
        'currentAmount': 18.5,
        'deadline': '2024-11-30',
        'status': 'In Progress',
        'completedDate': null,
        'progress': 75,
        'deliverables': [
          {'name': 'Equipment List', 'status': 'Submitted', 'verified': true},
          {'name': 'Installation Photos', 'status': 'In Progress', 'verified': false},
          {'name': 'Testing Reports', 'status': 'Pending', 'verified': false},
        ],
        'approvals': 2,
        'requiredApprovals': 3,
        'fundsReleased': false,
      },
      {
        'milestoneId': 4,
        'phase': 4,
        'name': 'Staff Training',
        'title': 'Phase 4: Staff Training',
        'description': 'Train staff and prepare for operations',
        'targetAmount': 10.0,
        'currentAmount': 5.0,
        'deadline': '2024-12-15',
        'status': 'Pending',
        'completedDate': null,
        'progress': 0,
        'deliverables': [
          {'name': 'Training Curriculum', 'status': 'Pending', 'verified': false},
          {'name': 'Staff Certificates', 'status': 'Pending', 'verified': false},
          {'name': 'Operations Manual', 'status': 'Pending', 'verified': false},
        ],
        'approvals': 0,
        'requiredApprovals': 3,
        'fundsReleased': false,
      },
      {
        'milestoneId': 5,
        'phase': 5,
        'name': 'Launch & Monitoring',
        'title': 'Phase 5: Launch & Monitoring',
        'description': 'Official launch and continuous monitoring',
        'targetAmount': 10.0,
        'currentAmount': 0.0,
        'deadline': '2024-12-31',
        'status': 'Pending',
        'completedDate': null,
        'progress': 0,
        'deliverables': [
          {'name': 'Launch Event Report', 'status': 'Pending', 'verified': false},
          {'name': 'Impact Metrics', 'status': 'Pending', 'verified': false},
          {'name': 'Final Documentation', 'status': 'Pending', 'verified': false},
        ],
        'approvals': 0,
        'requiredApprovals': 3,
        'fundsReleased': false,
      },
    ];
  }

  // Escrow Account Details
  Map<String, dynamic> getEscrowDetails(int campaignId) {
    return {
      'campaignId': campaignId,
      'totalEscrowed': 65.0,
      'totalReleased': 25.0,
      'totalPending': 33.5,
      'totalRefunded': 0.0,
      'availableForRelease': 18.5,
      'lockedUntilMilestone': 6.5,
      'isActive': true,
      'escrowAddress': '0x742d35Cc6634C0532925a3b844Bc9e7595f5e89',
      'smartContractVersion': 'v2.1.0',
      'lastActivity': '2024-11-02 10:30:00',
    };
  }

  // Milestone Timeline
  List<Map<String, dynamic>> getMilestoneTimeline(int campaignId) {
    return [
      {
        'date': '2024-09-28',
        'event': 'Milestone 1 Completed',
        'description': 'Phase 1 deliverables approved',
        'type': 'milestone',
        'icon': '✅',
      },
      {
        'date': '2024-09-29',
        'event': 'Funds Released',
        'description': '10.0 ETH released to charity',
        'type': 'transaction',
        'icon': '💰',
      },
      {
        'date': '2024-10-15',
        'event': 'Progress Update',
        'description': 'Phase 2 - 50% complete',
        'type': 'update',
        'icon': '📊',
      },
      {
        'date': '2024-10-29',
        'event': 'Milestone 2 Completed',
        'description': 'Infrastructure setup finished',
        'type': 'milestone',
        'icon': '✅',
      },
      {
        'date': '2024-10-30',
        'event': 'Funds Released',
        'description': '15.0 ETH released to charity',
        'type': 'transaction',
        'icon': '💰',
      },
      {
        'date': '2024-11-01',
        'event': 'Phase 3 Started',
        'description': 'Equipment installation begun',
        'type': 'update',
        'icon': '🔧',
      },
    ];
  }

  // Approvers List
  List<Map<String, dynamic>> getMilestoneApprovers(int milestoneId) {
    return [
      {
        'address': '0x1234...5678',
        'name': 'Community Validator #1',
        'reputation': 95,
        'approved': true,
        'timestamp': '2024-10-28 14:30:00',
        'role': 'Community',
      },
      {
        'address': '0x2345...6789',
        'name': 'Independent Auditor',
        'reputation': 98,
        'approved': true,
        'timestamp': '2024-10-28 16:45:00',
        'role': 'Auditor',
      },
      {
        'address': '0x3456...7890',
        'name': 'Platform Verifier',
        'reputation': 100,
        'approved': true,
        'timestamp': '2024-10-29 09:15:00',
        'role': 'Platform',
      },
      {
        'address': '0x4567...8901',
        'name': 'Community Validator #2',
        'reputation': 92,
        'approved': false,
        'timestamp': null,
        'role': 'Community',
      },
    ];
  }

  // Deliverables Evidence
  Map<String, dynamic> getDeliverableEvidence(int milestoneId, String deliverableName) {
    return {
      'name': deliverableName,
      'uploadDate': '2024-10-28',
      'fileType': 'PDF',
      'fileSize': '2.4 MB',
      'ipfsHash': 'QmX8k9d2m3n4o5p6q7r8s9t0u1v2w3x4y5z6',
      'verified': true,
      'verifiedBy': '0x1234...5678',
      'verifiedDate': '2024-10-28',
      'photoCount': 15,
      'videoCount': 2,
      'documentCount': 8,
      'thumbnailUrl': 'https://picsum.photos/300/200',
    };
  }

  // Impact Evidence
  List<Map<String, dynamic>> getImpactEvidence(int campaignId) {
    return [
      {
        'type': 'photo',
        'title': 'Construction Progress',
        'date': '2024-10-25',
        'url': 'https://picsum.photos/400/300?random=1',
        'description': 'Foundation and structure complete',
        'location': 'Project Site A',
        'verified': true,
      },
      {
        'type': 'video',
        'title': 'Beneficiary Interview',
        'date': '2024-10-20',
        'url': '#',
        'description': 'Community members sharing their stories',
        'location': 'Local Community',
        'verified': true,
      },
      {
        'type': 'photo',
        'title': 'Equipment Installation',
        'date': '2024-11-01',
        'url': 'https://picsum.photos/400/300?random=2',
        'description': 'Medical equipment being installed',
        'location': 'Project Site A',
        'verified': false,
      },
    ];
  }

  // Withdrawal Requests
  List<Map<String, dynamic>> getWithdrawalRequests(int campaignId) {
    return [
      {
        'requestId': 'WD-2024-001',
        'amount': 10.0,
        'milestone': 'Phase 1',
        'requestDate': '2024-09-28',
        'approvalDate': '2024-09-29',
        'status': 'Approved',
        'txHash': '0xabc123...def456',
      },
      {
        'requestId': 'WD-2024-002',
        'amount': 15.0,
        'milestone': 'Phase 2',
        'requestDate': '2024-10-29',
        'approvalDate': '2024-10-30',
        'status': 'Approved',
        'txHash': '0xghi789...jkl012',
      },
      {
        'requestId': 'WD-2024-003',
        'amount': 20.0,
        'milestone': 'Phase 3',
        'requestDate': '2024-11-01',
        'approvalDate': null,
        'status': 'Pending',
        'txHash': null,
      },
    ];
  }

  // Escrow Statistics
  Map<String, dynamic> getEscrowStatistics() {
    return {
      'totalCampaigns': 125,
      'totalEscrowedValue': 2450.5,
      'totalReleasedValue': 1850.3,
      'averageReleaseTime': '3.2 days',
      'successfulReleases': 342,
      'pendingApprovals': 28,
      'disputeRate': '0.8%',
      'avgMilestonesPerCampaign': 4.2,
    };
  }

  // Milestone Performance Metrics
  Map<String, dynamic> getMilestonePerformance(int milestoneId) {
    return {
      'completionRate': 87,
      'onTimeDelivery': true,
      'daysAheadOfSchedule': 2,
      'qualityScore': 9.2,
      'communityRating': 4.8,
      'documentationCompleteness': 95,
      'transparencyScore': 98,
    };
  }
}
