import 'dart:math' as math;

class ComplianceService {
  static final ComplianceService _instance = ComplianceService._internal();
  factory ComplianceService() => _instance;
  ComplianceService._internal();

  final _random = math.Random();

  // KYC Status
  Map<String, dynamic> getKYCStatus(String charityId) {
    return {
      'status': 'Verified',
      'verifiedDate': '2024-01-15',
      'verificationLevel': 'Level 3 (Enhanced)',
      'documentStatus': {
        'identity': {'verified': true, 'date': '2024-01-15'},
        'address': {'verified': true, 'date': '2024-01-16'},
        'tax': {'verified': true, 'date': '2024-01-17'},
        'banking': {'verified': true, 'date': '2024-01-18'},
      },
      'expiryDate': '2025-01-15',
      'riskScore': 15 + _random.nextInt(10), // Low risk: 0-30
      'jurisdictionCode': 'US-CA',
    };
  }

  // AML Compliance
  Map<String, dynamic> getAMLStatus(String charityId) {
    return {
      'status': 'Cleared',
      'lastCheckDate': '2024-11-01',
      'screeningsPassed': 12,
      'sanctionListCheck': 'Clear',
      'pepCheck': 'Clear',
      'adverseMediaCheck': 'Clear',
      'transactionMonitoring': 'Active',
      'suspiciousActivityReports': 0,
      'nextReviewDate': '2024-12-01',
    };
  }

  // Regulatory Reports
  List<Map<String, dynamic>> getRegulatoryReports(int campaignId) {
    return [
      {
        'reportId': 'REP-2024-Q3-001',
        'type': 'Quarterly Financial Report',
        'submissionDate': '2024-10-15',
        'status': 'Approved',
        'auditor': 'Deloitte & Touche LLP',
        'ipfsHash': 'QmX8k9d2m3n4o5p6q7r8s9t0u1v2w3x4y5z6',
        'downloadUrl': '#',
      },
      {
        'reportId': 'REP-2024-ANN-001',
        'type': 'Annual Compliance Report',
        'submissionDate': '2024-01-30',
        'status': 'Approved',
        'auditor': 'PwC',
        'ipfsHash': 'QmY9l0a3n4o5p6q7r8s9t0u1v2w3x4y5z6a7',
        'downloadUrl': '#',
      },
      {
        'reportId': 'REP-2024-AUD-001',
        'type': 'External Audit Report',
        'submissionDate': '2024-06-20',
        'status': 'Under Review',
        'auditor': 'KPMG',
        'ipfsHash': 'QmZ0b1c4n5o6p7q8r9s0t1u2v3w4x5y6z7a8',
        'downloadUrl': '#',
      },
    ];
  }

  // Fraud Detection Alerts
  List<Map<String, dynamic>> getFraudAlerts() {
    return [
      {
        'alertId': 'FRD-2024-001',
        'severity': 'Low',
        'type': 'Unusual Pattern',
        'description': 'Withdrawal timing outside normal hours',
        'charityName': 'Education for All Foundation',
        'timestamp': '2024-11-02 03:45:00',
        'status': 'Investigating',
        'falsePositive': false,
        'color': 0xFFf59e0b,
      },
      {
        'alertId': 'FRD-2024-002',
        'severity': 'Medium',
        'type': 'Document Mismatch',
        'description': 'Minor discrepancy in financial documents',
        'charityName': 'Clean Water Initiative',
        'timestamp': '2024-11-01 14:20:00',
        'status': 'Under Review',
        'falsePositive': false,
        'color': 0xFFef4444,
      },
    ];
  }

  // Fraud Risk Indicators
  Map<String, dynamic> getFraudRiskScore(String charityId) {
    final baseScore = 20 + _random.nextInt(30);
    
    return {
      'overallScore': baseScore,
      'riskLevel': baseScore < 30 ? 'Low' : baseScore < 60 ? 'Medium' : 'High',
      'indicators': {
        'rapidWithdrawals': 2,
        'unusualPatterns': 1,
        'donorComplaints': 0,
        'documentDiscrepancies': 1,
        'verificationDelays': 0,
      },
      'confidence': '${92 + _random.nextInt(8)}%',
      'lastAnalysis': '2 hours ago',
      'nextAnalysis': 'In 22 hours',
    };
  }

  // Compliance Dashboard Summary
  Map<String, dynamic> getComplianceDashboard() {
    return {
      'totalCharities': 245,
      'kycVerified': 230,
      'kycPending': 12,
      'kycRejected': 3,
      'amlCleared': 228,
      'amlInReview': 17,
      'activeFraudCases': 2,
      'resolvedFraudCases': 148,
      'complianceRate': 94.3,
      'avgVerificationTime': '2.5 days',
      'upcomingAudits': 5,
      'overdueReports': 1,
    };
  }

  // Sanctions Screening
  Map<String, dynamic> getSanctionsScreening(String address) {
    return {
      'address': address,
      'screeningDate': DateTime.now().toIso8601String(),
      'ofacCheck': 'Clear',
      'euSanctionsCheck': 'Clear',
      'unSanctionsCheck': 'Clear',
      'localSanctionsCheck': 'Clear',
      'matchScore': 0,
      'status': 'Cleared',
    };
  }

  // Transaction Monitoring
  List<Map<String, dynamic>> getSuspiciousTransactions() {
    return [
      {
        'txHash': '0x742d...5e89',
        'amount': '12.5 ETH',
        'flag': 'Large Amount',
        'reason': 'Exceeds daily limit',
        'timestamp': '2024-11-02 08:30:00',
        'status': 'Approved',
        'approvedBy': 'Compliance Officer',
      },
    ];
  }

  // Audit Trail
  List<Map<String, dynamic>> getAuditTrail(int campaignId) {
    return [
      {
        'timestamp': '2024-11-02 10:00:00',
        'action': 'Funds Withdrawn',
        'amount': '5.2 ETH',
        'user': '0x742d...5e89',
        'approvals': 3,
        'ipAddress': '192.168.1.1',
      },
      {
        'timestamp': '2024-11-01 15:30:00',
        'action': 'Document Updated',
        'detail': 'Financial report Q3 uploaded',
        'user': '0x742d...5e89',
        'approvals': 2,
        'ipAddress': '192.168.1.1',
      },
      {
        'timestamp': '2024-11-01 09:15:00',
        'action': 'Milestone Completed',
        'detail': 'Phase 2 deliverables submitted',
        'user': '0x742d...5e89',
        'approvals': 5,
        'ipAddress': '192.168.1.1',
      },
    ];
  }

  // Tax Compliance
  Map<String, dynamic> getTaxCompliance(String charityId) {
    return {
      'taxId': 'EIN-XX-XXXXXXX',
      '501c3Status': 'Active',
      'taxExemptSince': '2019-03-15',
      'annualFilings': {
        '2023': 'Filed',
        '2022': 'Filed',
        '2021': 'Filed',
      },
      'form990Status': 'Up to date',
      'stateRegistrations': ['CA', 'NY', 'TX', 'FL'],
      'goodStanding': true,
    };
  }

  // Smart Contract Audit Results
  Map<String, dynamic> getContractAuditResults() {
    return {
      'auditFirm': 'CertiK',
      'auditDate': '2024-08-15',
      'overallScore': 95,
      'criticalIssues': 0,
      'majorIssues': 0,
      'minorIssues': 2,
      'resolved': 2,
      'recommendations': 5,
      'implemented': 4,
      'status': 'Passed',
      'certificate': 'CERT-2024-ELYSIUM-001',
      'reportUrl': '#',
    };
  }
}
