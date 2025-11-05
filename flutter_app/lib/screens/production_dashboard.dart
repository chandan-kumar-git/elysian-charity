import 'package:flutter/material.dart';
import 'dart:ui';
import '../services/analytics_service.dart';
import '../services/loyalty_service.dart';
import '../services/notification_service.dart';
import '../services/video_proof_service.dart';
import '../services/beneficiary_tracking_service.dart';
import '../services/fraud_detection_service.dart';
import '../services/impact_calculator_service.dart';
import '../services/qr_donation_service.dart';
import '../services/corporate_matching_service.dart';
import '../services/fiat_payment_service.dart';
import '../services/realtime_donation_service.dart';
import '../widgets/ai_debug_dashboard.dart';
import '../widgets/premium_components.dart';
import '../widgets/payment_gateway_modal.dart';
import '../widgets/advanced_animations.dart';
import '../widgets/blockchain_visualization.dart';
import '../widgets/live_donation_feed.dart';
import '../widgets/emergency_campaigns.dart';

class ProductionDashboard extends StatefulWidget {
  const ProductionDashboard({Key? key}) : super(key: key);

  @override
  State<ProductionDashboard> createState() => _ProductionDashboardState();
}

class _ProductionDashboardState extends State<ProductionDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _analyticsService = AnalyticsService();
  final _loyaltyService = LoyaltyService();
  final _notificationService = NotificationService();
  final _videoProofService = VideoProofService();
  final _beneficiaryService = BeneficiaryTrackingService();
  final _fraudService = FraudDetectionService();
  final _impactCalculator = ImpactCalculatorService();
  final _qrService = QRDonationService();
  final _corporateService = CorporateMatchingService();
  final _fiatPaymentService = FiatPaymentService();
  final _realtimeDonationService = RealTimeDonationService();
  final _emergencyCampaignService = EmergencyCampaignService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Changed from 6 to 3
    _notificationService.startNotifications();
    _fraudService.startMonitoring();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fraudService.dispose();
    _realtimeDonationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedParticleBackground(
      particleCount: 80,
      particleColor: const Color(0xFF00F5FF),
      child: FloatingParticles(
        particleCount: 50,
        particleColor: const Color(0xFF00F5FF).withOpacity(0.3),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF1A1F3A).withOpacity(0.8),
                        const Color(0xFF0A0E27).withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            title: Row(
              children: [
                // Logo with glow
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00F5FF), Color(0xFFB967FF)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00F5FF).withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.account_balance, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                GradientAnimatedText(
                  text: 'CharityChain',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00FF00), Color(0xFF00DD00)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00FF00).withOpacity(0.5),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const PulsingDot(color: Color(0xFF00FF00), size: 8),
                      const SizedBox(width: 6),
                      const Text(
                        'LIVE PRODUCTION',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          actions: [
            // Premium Notification Bell with badge
            StreamBuilder<Map<String, dynamic>>(
              stream: _notificationService.notificationStream,
              builder: (context, snapshot) {
                return Stack(
                  children: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF00F5FF).withOpacity(0.2),
                              const Color(0xFFB967FF).withOpacity(0.2),
                            ],
                          ),
                        ),
                        child: const Icon(Icons.notifications_active, color: Color(0xFF00F5FF)),
                      ),
                      onPressed: () => _showNotificationsPanel(context),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF006E), Color(0xFFFF3E9E)],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF006E).withOpacity(0.6),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Text(
                          '${_notificationService.getUnreadCount()}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(width: 16),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFF00F5FF),
                indicatorWeight: 3,
                labelColor: const Color(0xFF00F5FF),
                unselectedLabelColor: Colors.white54,
                tabs: const [
                  Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
                  Tab(icon: Icon(Icons.map), text: 'Impact Tracking'),
                  Tab(icon: Icon(Icons.qr_code_2), text: 'Smart Donations'),
                ],
              ),
            ),
          ),
        ),
        body: AnimatedGradientBackground(
          colors: const [
            Color(0xFF0A0E27),
            Color(0xFF1A1F3A),
            Color(0xFF0A0E27),
          ],
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildAnalyticsTab(),
              _buildImpactTrackingTab(),
              _buildSmartDonationsTab(),
            ],
          ),
        ),
        floatingActionButton: PulsingFloatingButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AIDebugDashboard()),
            );
          },
          icon: Icons.bug_report,
          label: 'AI Debug',
          color: const Color(0xFF00FF00),
        ),
        ), // Scaffold
      ), // FloatingParticles
    ); // AnimatedParticleBackground
  }

  // Analytics Tab
  Widget _buildAnalyticsTab() {
    final metrics = _analyticsService.getDashboardMetrics();
    final trends = _analyticsService.getMonthlyTrends();
    final topDonors = _analyticsService.getTopDonors();
    final categories = _analyticsService.getCategoryDistribution();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Metrics Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildMetricCard('💰 Total Donations', metrics['totalDonations'], const Color(0xFF00F5FF)),
              _buildMetricCard('🎯 Active Campaigns', '${metrics['activeCampaigns']}', const Color(0xFFFF006E)),
              _buildMetricCard('✅ Success Rate', '${metrics['successRate']}%', const Color(0xFF00FF00)),
              _buildMetricCard('👥 Total Users', metrics['registeredUsers'], const Color(0xFFB967FF)),
            ],
          ),
          const SizedBox(height: 24),

          // Monthly Trends
          _buildSectionTitle('📈 Monthly Trends'),
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F3A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF00F5FF).withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: trends.map<Widget>((trend) {
                final amount = (trend['amount'] as int);
                // Constrain height to fit within container (200 - 16*2 padding - 8 gap - 20 text = 140 max)
                final height = (amount * 0.8).clamp(20.0, 140.0);
                return Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: height,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              const Color(0xFF00F5FF),
                              const Color(0xFF00F5FF).withOpacity(0.3),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        trend['month'],
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Top Donors
          _buildSectionTitle('🏆 Top Donors'),
          ...topDonors.take(5).map((donor) => _buildDonorCard(donor)),
          const SizedBox(height: 24),

          // Category Distribution
          _buildSectionTitle('📊 Donation Categories'),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: categories.map<Widget>((cat) => _buildCategoryCard(cat)).toList(),
          ),
        ],
      ),
    );
  }

  // Impact Tracking Tab - Shows beneficiaries, video proofs, and real-time impact
  Widget _buildImpactTrackingTab() {
    final beneficiaries = _beneficiaryService.getBeneficiaries();
    final videoProofs = _videoProofService.getCampaignVideoProofs('camp_001');
    final regionalImpact = _beneficiaryService.getRegionalImpact();
    final globalImpact = _impactCalculator.getGlobalImpact();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Global Impact Counter
          _buildSectionTitle('🌍 Live Global Impact'),
          GlassCard(
            blur: 15,
            opacity: 0.15,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildLiveCounter('Lives Impacted', globalImpact['livesImpacted'], Icons.people, const Color(0xFF00F5FF)),
                      _buildLiveCounter('Meals Provided', globalImpact['mealsProvided'], Icons.restaurant, const Color(0xFF00FF00)),
                      _buildLiveCounter('Students Educated', globalImpact['studentsEducated'], Icons.school, const Color(0xFFB967FF)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Video Proof Section
          _buildSectionTitle('🎥 Video Proof of Impact'),
          const SizedBox(height: 12),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: videoProofs.length,
              itemBuilder: (context, index) {
                return _buildVideoProofCard(videoProofs[index]);
              },
            ),
          ),
          const SizedBox(height: 24),

          // AI Fraud Detection
          _buildSectionTitle('🛡️ AI Fraud Prevention'),
          _buildFraudDetectionCard(),
          const SizedBox(height: 24),

          // Beneficiary Map Preview
          _buildSectionTitle('📍 Live Beneficiary Tracking'),
          HoverScaleCard(
            child: GlassCard(
              blur: 15,
              opacity: 0.15,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00F5FF), Color(0xFFB967FF)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.map, color: Colors.white, size: 32),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Interactive World Map',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${regionalImpact['totalBeneficiaries']} beneficiaries tracked across ${regionalImpact['regionsServed']} regions',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildRegionChip('Mumbai', 245, 198, const Color(0xFF00F5FF)),
                        _buildRegionChip('Bangalore', 312, 289, const Color(0xFF00FF00)),
                        _buildRegionChip('Delhi', 189, 156, const Color(0xFFB967FF)),
                        _buildRegionChip('Hyderabad', 247, 203, const Color(0xFFFF006E)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Beneficiary Cards
          _buildSectionTitle('👥 Recent Beneficiaries'),
          ...beneficiaries.take(6).map((b) => _buildBeneficiaryCard(b)),
        ],
      ),
    );
  }

  // Smart Donations Tab - QR codes, corporate matching, impact calculator
  Widget _buildSmartDonationsTab() {
    final matchingPrograms = _corporateService.getActiveMatchingPrograms();
    final qrStats = _qrService.getQRDonationStats();
    final matchingStats = _corporateService.getMatchingStatistics();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ⭐ NEW: LIVE DONATION FEED
          _buildSectionTitle('🔴 LIVE - Real-Time Donations'),
          LiveDonationFeed(donationService: _realtimeDonationService),
          const SizedBox(height: 32),

          // ⭐ NEW: EMERGENCY CAMPAIGNS
          _buildSectionTitle('🚨 Emergency Campaigns - ACT NOW!'),
          EmergencyCampaignsWidget(emergencyService: _emergencyCampaignService),
          const SizedBox(height: 32),

          // ⭐ NEW: Blockchain Visualization Section
          _buildBlockchainVisualizationSection(),
          const SizedBox(height: 32),

          // Impact Calculator
          _buildSectionTitle('💡 Calculate Your Impact'),
          _buildImpactCalculator(),
          const SizedBox(height: 24),

          // Corporate Matching Programs
          _buildSectionTitle('🏢 Corporate Matching Programs'),
          const SizedBox(height: 12),
          ...matchingPrograms.map((program) => _buildCorporateMatchingCard(program)),
          const SizedBox(height: 24),

          // QR Code Donations
          _buildSectionTitle('📱 QR Code Instant Donations'),
          _buildQRDonationSection(qrStats),
          const SizedBox(height: 24),

          // Payment Methods (NEW!)
          _buildSectionTitle('💳 Fiat Payment Methods - No Crypto Needed!'),
          _buildFiatPaymentMethods(),
          const SizedBox(height: 24),

          // Loyalty & Rewards
          _buildSectionTitle('⭐ Loyalty Rewards'),
          _buildLoyaltySection(),
        ],
      ),
    );
  }

  // Helper Widgets
  Widget _buildMetricCard(String title, String value, Color color) {
    return HoverScaleCard(
      scale: 1.08,
      child: GlassCard(
        blur: 15,
        opacity: 0.15,
        gradientColors: [
          color.withOpacity(0.15),
          color.withOpacity(0.05),
        ],
        border: Border.all(
          width: 2,
          color: color.withOpacity(0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                _getIconForMetric(title),
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            FittedBox(
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Colors.white, color],
                ).createShader(bounds),
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForMetric(String title) {
    if (title.contains('Donations')) return Icons.payments;
    if (title.contains('Campaigns')) return Icons.campaign;
    if (title.contains('Success')) return Icons.check_circle;
    if (title.contains('Users')) return Icons.people;
    return Icons.analytics;
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 30,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00F5FF), Color(0xFFB967FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF00F5FF), Color(0xFFB967FF)],
            ).createShader(bounds),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonorCard(Map<String, dynamic> donor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(donor['tierColor']).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Color(donor['tierColor']),
            child: Text(donor['rank'].toString()),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  donor['name'],
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${donor['totalDonated']} ETH • ${donor['tier']}',
                  style: TextStyle(color: Color(donor['tierColor']), fontSize: 14),
                ),
              ],
            ),
          ),
          Text(
            '${donor['donationCount']} donations',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A1F3A),
            Color(category['color']).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(category['color']).withOpacity(0.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            category['icon'],
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 8),
          Text(
            category['name'],
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '${category['percentage']}%',
            style: TextStyle(color: Color(category['color']), fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildNFTCard(Map<String, dynamic> nft) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A1F3A),
            Color(nft['color']).withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(nft['color'])),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Color(nft['color']).withOpacity(0.2),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Center(
              child: Text(
                nft['icon'],
                style: const TextStyle(fontSize: 48),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nft['name'],
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  nft['rarity'],
                  style: TextStyle(color: Color(nft['color']), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardCard(Map<String, dynamic> donor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1A1F3A),
            donor['rank'] <= 3 ? const Color(0xFFFFD700).withOpacity(0.1) : const Color(0xFF1A1F3A),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: donor['rank'] <= 3 ? const Color(0xFFFFD700) : const Color(0xFF00F5FF).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  donor['rank'] == 1 ? const Color(0xFFFFD700) : 
                  donor['rank'] == 2 ? const Color(0xFFC0C0C0) :
                  donor['rank'] == 3 ? const Color(0xFFCD7F32) : const Color(0xFF00F5FF),
                  Colors.white,
                ],
              ),
            ),
            child: Center(
              child: Text(
                donor['badge'] ?? '#${donor['rank']}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  donor['name'],
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${donor['tier']} • ${donor['totalDonations']} donations',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Text(
            '${donor['totalAmount']} ETH',
            style: const TextStyle(color: Color(0xFF00F5FF), fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildFraudAlertCard(Map<String, dynamic> alert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(alert['color']).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(alert['color'])),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: Color(alert['color']), size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert['type'],
                  style: TextStyle(color: Color(alert['color']), fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  alert['description'],
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(alert['color']).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              alert['severity'].toUpperCase(),
              style: TextStyle(color: Color(alert['color']), fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneCard(Map<String, dynamic> milestone) {
    final progress = milestone['progress'] as int;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: progress == 100 ? const Color(0xFF00FF00) : const Color(0xFF00F5FF).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: progress == 100 ? const Color(0xFF00FF00).withOpacity(0.2) : const Color(0xFF00F5FF).withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: progress == 100 ? const Color(0xFF00FF00) : const Color(0xFF00F5FF),
                  ),
                ),
                child: Center(
                  child: Text(
                    '${milestone['phase']}',
                    style: TextStyle(
                      color: progress == 100 ? const Color(0xFF00FF00) : const Color(0xFF00F5FF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      milestone['name'],
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      milestone['status'],
                      style: TextStyle(
                        color: progress == 100 ? const Color(0xFF00FF00) : const Color(0xFF00F5FF),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${milestone['targetAmount']} ETH',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress == 100 ? const Color(0xFF00FF00) : const Color(0xFF00F5FF),
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$progress% Complete',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyCard(Map<String, dynamic> currency, double price, double change) {
    final isPositive = change >= 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1A1F3A),
            Color(currency['color']).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(currency['color']).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Color(currency['color']).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                currency['icon'],
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currency['name'],
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  currency['symbol'],
                  style: TextStyle(color: Color(currency['color']), fontSize: 14),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${price.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Icon(
                    isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isPositive ? const Color(0xFF00FF00) : const Color(0xFFFF006E),
                    size: 16,
                  ),
                  Text(
                    '${change.abs().toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: isPositive ? const Color(0xFF00FF00) : const Color(0xFFFF006E),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00F5FF).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Text(
            activity['icon'] ?? '📡',
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['description'] ?? 'Activity',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimestamp(activity['timestamp'] ?? DateTime.now()),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildEscrowStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(color: Color(0xFF00F5FF), fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  // NEW HELPER WIDGETS FOR WINNING FEATURES

  Widget _buildLiveCounter(String label, dynamic value, IconData icon, Color color) {
    final intValue = value is int ? value : (value as double).toInt();
    
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        AnimatedCounter(
          value: intValue,
          duration: const Duration(seconds: 2),
          style: TextStyle(
            color: color,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildVideoProofCard(Map<String, dynamic> video) {
    return Container(
      width: 320,
      height: 280, // Fixed height to prevent overflow
      margin: const EdgeInsets.only(right: 16),
      child: HoverScaleCard(
        child: GlassCard(
          blur: 15,
          opacity: 0.15,
          child: Column(
            mainAxisSize: MainAxisSize.min, // Prevent overflow
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(video['thumbnail']),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Play button overlay
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
                        ),
                      ),
                      // AI Verification badge
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00FF00), Color(0xFF00F5FF)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.verified, color: Colors.white, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '${video['verificationScore']}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Content with fixed padding
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10), // Reduced from 12
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        video['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13, // Reduced from 14
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4), // Reduced from 6
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Color(0xFF00F5FF), size: 12),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              video['location'],
                              style: const TextStyle(color: Colors.white70, fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${video['facesDetected']} people',
                            style: const TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2), // Reduced from 4
                      Row(
                        children: [
                          const Icon(Icons.visibility, color: Colors.white54, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            '${video['views']} views',
                            style: const TextStyle(color: Colors.white54, fontSize: 10),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.favorite, color: Colors.white54, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            '${video['likes']}',
                            style: const TextStyle(color: Colors.white54, fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFraudDetectionCard() {
    final stats = _fraudService.getFraudStats();
    final alerts = _fraudService.getPendingAlerts();

    return HoverScaleCard(
      child: GlassCard(
        blur: 15,
        opacity: 0.15,
        border: Border.all(color: const Color(0xFF00FF00).withOpacity(0.3)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00FF00), Color(0xFF00F5FF)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00FF00).withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.security, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'AI Protection Active',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Monitoring ${stats['totalMonitored']} transactions',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  PulsingDot(color: const Color(0xFF00FF00)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildFraudStat(
                      'Fraud Prevented',
                      '${stats['fraudPrevented']}',
                      Icons.block,
                      const Color(0xFF00FF00),
                    ),
                  ),
                  Expanded(
                    child: _buildFraudStat(
                      'Money Saved',
                      '\$${(stats['moneySaved'] / 1000000).toStringAsFixed(1)}M',
                      Icons.savings,
                      const Color(0xFFFFD700),
                    ),
                  ),
                  Expanded(
                    child: _buildFraudStat(
                      'Accuracy',
                      '${stats['accuracy']}%',
                      Icons.check_circle,
                      const Color(0xFF00F5FF),
                    ),
                  ),
                  Expanded(
                    child: _buildFraudStat(
                      'Active Alerts',
                      '${alerts.length}',
                      Icons.warning,
                      alerts.isEmpty ? const Color(0xFF00FF00) : const Color(0xFFFF006E),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFraudStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRegionChip(String city, int total, int funded, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_city, color: color, size: 16),
          const SizedBox(width: 8),
          Text(
            '$city: $funded/$total',
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBeneficiaryCard(Map<String, dynamic> beneficiary) {
    final progress = beneficiary['progress'] as int;
    final needsMet = beneficiary['needsMet'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: HoverScaleCard(
        child: GlassCard(
          blur: 15,
          opacity: 0.15,
          border: Border.all(
            color: needsMet ? const Color(0xFF00FF00).withOpacity(0.3) : const Color(0xFF00F5FF).withOpacity(0.3),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(beneficiary['photo']),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        beneficiary['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: const Color(0xFF00F5FF),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            beneficiary['location'],
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        beneficiary['story'],
                        style: const TextStyle(color: Colors.white60, fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress / 100,
                        backgroundColor: Colors.white10,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          needsMet ? const Color(0xFF00FF00) : const Color(0xFF00F5FF),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${beneficiary['donationReceived'].toStringAsFixed(0)}',
                      style: TextStyle(
                        color: needsMet ? const Color(0xFF00FF00) : const Color(0xFF00F5FF),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (!needsMet && beneficiary.containsKey('targetAmount'))
                      Text(
                        'of \$${beneficiary['targetAmount'].toStringAsFixed(0)}',
                        style: const TextStyle(color: Colors.white54, fontSize: 11),
                      ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: needsMet
                            ? const Color(0xFF00FF00).withOpacity(0.2)
                            : const Color(0xFFFF006E).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        needsMet ? 'Helped ✓' : 'Needs Help',
                        style: TextStyle(
                          color: needsMet ? const Color(0xFF00FF00) : const Color(0xFFFF006E),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImpactCalculator() {
    String selectedCategory = 'Education';
    double donationAmount = 100.0;

    return StatefulBuilder(
      builder: (context, setState) {
        final impact = _impactCalculator.calculateImpact(donationAmount, selectedCategory);

        return HoverScaleCard(
          child: GlassCard(
            blur: 15,
            opacity: 0.15,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        impact['icon'],
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'See Your Impact',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Category',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: ['Education', 'Healthcare', 'Food', 'Water', 'Shelter'].map((cat) {
                                final isSelected = cat == selectedCategory;
                                return GestureDetector(
                                  onTap: () => setState(() => selectedCategory = cat),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFF00F5FF).withOpacity(0.2)
                                          : Colors.white10,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFF00F5FF)
                                            : Colors.white30,
                                      ),
                                    ),
                                    child: Text(
                                      cat,
                                      style: TextStyle(
                                        color: isSelected ? const Color(0xFF00F5FF) : Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Amount (\$)',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 150,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFF00F5FF).withOpacity(0.3)),
                            ),
                            child: Text(
                              '\$${donationAmount.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: Color(0xFF00F5FF),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(impact['color']).withOpacity(0.2),
                          Color(impact['color']).withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(impact['color']).withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          impact['visualization'],
                          style: TextStyle(
                            color: Color(impact['color']),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 20,
                          runSpacing: 16,
                          alignment: WrapAlignment.center,
                          children: (impact['breakdown'] as List).map<Widget>((item) {
                            return Column(
                              children: [
                                Text(
                                  item['icon'],
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${item['value']}',
                                  style: TextStyle(
                                    color: Color(impact['color']),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  item['label'],
                                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    impact['comparison'],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCorporateMatchingCard(Map<String, dynamic> program) {
    final percentageUsed = program['percentageUsed'] as double;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: HoverScaleCard(
        child: GlassCard(
          blur: 15,
          opacity: 0.15,
          border: Border.all(color: Color(program['color']).withOpacity(0.3)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(program['logo']),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            program['corporationName'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(program['color']),
                                      Color(program['color']).withOpacity(0.6),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${program['matchingRatio']}X MATCH',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${program['employeeParticipation']} employees participating',
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Your \$10 becomes \$${(10 * program['matchingRatio']).toStringAsFixed(0)}!',
                  style: TextStyle(
                    color: Color(program['color']),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${(program['currentMatched'] / 1000).toStringAsFixed(1)}K matched',
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                              Text(
                                '${percentageUsed.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  color: Color(program['color']),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: percentageUsed / 100,
                            backgroundColor: Colors.white10,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(program['color'])),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: (program['eligibleCampaigns'] as List<String>).map((category) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(program['color']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(program['color']).withOpacity(0.3)),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: Color(program['color']),
                          fontSize: 11,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQRDonationSection(Map<String, dynamic> stats) {
    return HoverScaleCard(
      child: GlassCard(
        blur: 15,
        opacity: 0.15,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.qr_code_2, size: 120, color: Colors.black),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Scan & Donate',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1 scan = 1 donation. No crypto knowledge needed.',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildQRStat('Total Donations', '${stats['totalQRDonations']}', const Color(0xFF00F5FF)),
                        const SizedBox(width: 24),
                        _buildQRStat('Average', '\$${stats['averageAmount'].toStringAsFixed(0)}', const Color(0xFF00FF00)),
                        const SizedBox(width: 24),
                        _buildQRStat('Success Rate', '${(stats['conversionRate'] * 100).toStringAsFixed(0)}%', const Color(0xFFFFD700)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _showPaymentGateway(context, 50.0, 'Clean Water Project', 'camp_water'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00F5FF),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.payment, color: Colors.black),
                      label: const Text(
                        'Donate Now - No Crypto!',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQRStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildLoyaltySection() {
    final profile = _loyaltyService.getUserLoyaltyProfile('user123');
    final nfts = _loyaltyService.getImpactNFTs('user123');
    final tier = profile['currentTier'] as Map<String, dynamic>;

    return HoverScaleCard(
      child: GlassCard(
        blur: 15,
        opacity: 0.15,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFF006E)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.stars, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${tier['name']} Tier',
                          style: TextStyle(
                            color: Color(tier['color'] as int),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${profile['rewardsEarned']} Impact Points',
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildLoyaltyStat('Total Donations', '\$${profile['totalDonated']}', Icons.payments),
                  ),
                  Expanded(
                    child: _buildLoyaltyStat('Campaigns', '${profile['campaignsSupported']}', Icons.campaign),
                  ),
                  Expanded(
                    child: _buildLoyaltyStat('NFTs Earned', '${nfts.length}', Icons.emoji_events),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoyaltyStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF00F5FF), size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF00F5FF),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showNotificationsPanel(BuildContext context) {
    final notifications = _notificationService.getRecentNotifications();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1F3A),
      builder: (context) => Container(
        height: 500,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '🔔 Notifications',
                  style: TextStyle(
                    color: Color(0xFF00F5FF),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF006E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_notificationService.getUnreadCount()} new',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notif = notifications[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: notif['read'] ? const Color(0xFF0A0E27) : const Color(0xFF2A2F4A),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Color(notif['color']).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          notif['icon'],
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notif['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                notif['message'],
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // NEW: Fiat Payment Methods Section
  Widget _buildFiatPaymentMethods() {
    final paymentMethods = _fiatPaymentService.getPaymentMethods();
    final stats = _fiatPaymentService.getPaymentStats();
    final smsInfo = _fiatPaymentService.getSMSDonationInfo();

    return Column(
      children: [
        // Stats Overview Card
        HoverScaleCard(
          child: GlassCard(
            blur: 15,
            opacity: 0.15,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00F5FF), Color(0xFF00FF00)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.payment, color: Colors.white, size: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Donate Without Crypto!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'We convert your payment to blockchain automatically',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildPaymentStat(
                        '\$${(stats['totalFiatDonations'] / 1000).toStringAsFixed(0)}K',
                        'Total Donations',
                        Icons.attach_money,
                        const Color(0xFF00FF00),
                      ),
                      _buildPaymentStat(
                        '${stats['totalTransactions']}',
                        'Transactions',
                        Icons.receipt,
                        const Color(0xFF00F5FF),
                      ),
                      _buildPaymentStat(
                        '${stats['conversionRate']}%',
                        'Success Rate',
                        Icons.check_circle,
                        const Color(0xFFB967FF),
                      ),
                      _buildPaymentStat(
                        stats['averageProcessingTime'],
                        'Avg Time',
                        Icons.speed,
                        const Color(0xFFFF6B6B),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Payment Methods Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: paymentMethods.length,
          itemBuilder: (context, index) {
            final method = paymentMethods[index];
            return _buildPaymentMethodCard(method);
          },
        ),
        const SizedBox(height: 16),

        // SMS Donations Card
        HoverScaleCard(
          child: GlassCard(
            blur: 15,
            opacity: 0.15,
            gradientColors: [
              const Color(0xFF00F5FF).withOpacity(0.1),
              const Color(0xFFB967FF).withOpacity(0.1),
            ],
            border: Border.all(
              width: 2,
              color: const Color(0xFF00F5FF).withOpacity(0.3),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00F5FF), Color(0xFFB967FF)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00F5FF).withOpacity(0.4),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.sms, color: Colors.white, size: 40),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'SMS Donations',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF00FF00), Color(0xFF00F5FF)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'NO INTERNET NEEDED',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Text "${smsInfo['examples'][0]['text']}" to ${smsInfo['phoneNumber']}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Works on basic phones • Reaches 2.5B people • ${smsInfo['statistics']['smsDonations']} donations so far',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> method) {
    return InkWell(
      onTap: () => _showPaymentGateway(context, 100.0, 'Education Fund', 'camp_edu'),
      child: HoverScaleCard(
        scale: 1.08,
        child: GlassCard(
          blur: 15,
          opacity: 0.15,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  method['icon'],
                  style: const TextStyle(fontSize: 36),
                ),
                const SizedBox(height: 8),
                Text(
                  method['name'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  method['fee'],
                  style: TextStyle(
                    color: const Color(0xFF00FF00).withOpacity(0.8),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  method['processingTime'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00F5FF).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'CLICK TO DONATE',
                    style: TextStyle(
                      color: Color(0xFF00F5FF),
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentStat(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // Show payment gateway modal
  void _showPaymentGateway(BuildContext context, double amount, String campaignName, String campaignId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PaymentGatewayModal(
        amount: amount,
        campaignName: campaignName,
        campaignId: campaignId,
      ),
    ).then((success) {
      if (success == true) {
        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Color(0xFF00FF00)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Donation Successful!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'Your \$$amount donation is now on the blockchain',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF1a1a2e),
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(
                color: Color(0xFF00FF00),
                width: 2,
              ),
            ),
          ),
        );
      }
    });
  }

  // ⭐ NEW: Blockchain Visualization Section
  Widget _buildBlockchainVisualizationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title with gradient animation
        GradientAnimatedText(
          text: '⛓️ Live Blockchain Network',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Watch your donations being processed on the Ethereum Sepolia testnet in real-time',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 24),

        // Blockchain Chain Visualization
        HoverScaleCard(
          scale: 1.02,
          child: GlassCard(
            blur: 20,
            opacity: 0.1,
            gradientColors: [
              const Color(0xFF00F5FF).withOpacity(0.1),
              const Color(0xFFB967FF).withOpacity(0.05),
            ],
            border: Border.all(
              color: const Color(0xFF00F5FF).withOpacity(0.3),
              width: 2,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Blockchain Chain',
                            style: TextStyle(
                              color: Color(0xFF00F5FF),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Secure • Transparent • Immutable',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00FF00), Color(0xFF00DD00)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00FF00).withOpacity(0.5),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: Row(
                          children: const [
                            PulsingDot(color: Colors.black, size: 8),
                            SizedBox(width: 8),
                            Text(
                              'LIVE',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const BlockchainChainVisualization(
                    blockCount: 5,
                    isActive: true,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Stats Cards Row
        Row(
          children: [
            Expanded(
              child: AnimatedStatCard(
                label: 'Blocks Mined',
                value: 847,
                icon: Icons.backup_rounded,
                color: const Color(0xFF00F5FF),
                prefix: '',
                suffix: '',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AnimatedStatCard(
                label: 'Transactions',
                value: 6847,
                icon: Icons.receipt_long,
                color: const Color(0xFFB967FF),
                prefix: '',
                suffix: '',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AnimatedStatCard(
                label: 'Network Nodes',
                value: 234,
                icon: Icons.hub,
                color: const Color(0xFF00FF00),
                prefix: '',
                suffix: '',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AnimatedStatCard(
                label: 'Gas Price',
                value: 25,
                icon: Icons.local_gas_station,
                color: const Color(0xFFFF006E),
                prefix: '',
                suffix: ' Gwei',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Network Mesh Visualization
        HoverScaleCard(
          scale: 1.02,
          child: GlassCard(
            blur: 20,
            opacity: 0.1,
            gradientColors: [
              const Color(0xFFB967FF).withOpacity(0.1),
              const Color(0xFFFF006E).withOpacity(0.05),
            ],
            border: Border.all(
              color: const Color(0xFFB967FF).withOpacity(0.3),
              width: 2,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🌐 Decentralized Network',
                    style: TextStyle(
                      color: Color(0xFFB967FF),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Real-time visualization of 234 active nodes on Ethereum network',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 300,
                    child: const BlockchainNetworkMesh(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
