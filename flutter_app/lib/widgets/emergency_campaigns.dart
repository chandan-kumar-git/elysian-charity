import 'package:flutter/material.dart';
import '../services/realtime_donation_service.dart';

/// Emergency Campaigns Widget - Shows urgent campaigns that need immediate attention
class EmergencyCampaignsWidget extends StatefulWidget {
  final EmergencyCampaignService emergencyService;

  const EmergencyCampaignsWidget({
    Key? key,
    required this.emergencyService,
  }) : super(key: key);

  @override
  State<EmergencyCampaignsWidget> createState() => _EmergencyCampaignsWidgetState();
}

class _EmergencyCampaignsWidgetState extends State<EmergencyCampaignsWidget> with TickerProviderStateMixin {
  late AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    // Create some sample emergency campaigns
    _createSampleEmergencies();
  }

  void _createSampleEmergencies() {
    widget.emergencyService.createEmergencyCampaign(
      title: 'Flash Floods in Mumbai',
      location: 'Mumbai, India',
      description: '10,000 families displaced due to severe flooding. Urgent need for shelter, food, and medical supplies.',
      goalAmount: 500000,
      type: EmergencyType.flood,
    );

    widget.emergencyService.createEmergencyCampaign(
      title: 'Child Heart Surgery',
      location: 'New Delhi, India',
      description: '5-year-old needs urgent heart surgery. Family cannot afford the \$8,000 cost.',
      goalAmount: 8000,
      type: EmergencyType.medical,
    );

    widget.emergencyService.createEmergencyCampaign(
      title: 'Wildfire Evacuations',
      location: 'California, USA',
      description: '2,000 people evacuated from their homes. Need immediate emergency supplies and temporary housing.',
      goalAmount: 250000,
      type: EmergencyType.fire,
    );
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final campaigns = widget.emergencyService.getActiveCampaigns();
    final stats = widget.emergencyService.getEmergencyStats();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Emergency header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFF0000).withOpacity(0.3),
                const Color(0xFFFF6600).withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFFF0000).withOpacity(0.5),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              AnimatedBuilder(
                animation: _blinkController,
                builder: (context, child) {
                  return Icon(
                    Icons.warning_amber_rounded,
                    color: Color.lerp(
                      const Color(0xFFFF0000),
                      const Color(0xFFFF6600),
                      _blinkController.value,
                    ),
                    size: 32,
                  );
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'EMERGENCY CAMPAIGNS',
                      style: TextStyle(
                        color: Color(0xFFFF0000),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${stats['activeEmergencies']} urgent situations • ${stats['totalPeopleAffected']} people affected',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF0000),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF0000).withOpacity(0.5),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: const Text(
                  'ACT NOW',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Emergency campaigns list
        ...campaigns.take(3).map((campaign) => _buildEmergencyCampaignCard(campaign)),
      ],
    );
  }

  Widget _buildEmergencyCampaignCard(EmergencyCampaign campaign) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1A1F3A).withOpacity(0.9),
            const Color(0xFF0A0E27).withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getUrgencyColor(campaign.urgencyLevel).withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: _getUrgencyColor(campaign.urgencyLevel).withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getUrgencyColor(campaign.urgencyLevel).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Text(
                  campaign.typeEmoji,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              campaign.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getUrgencyColor(campaign.urgencyLevel),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              campaign.urgencyLevel,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Color(0xFFFF006E), size: 14),
                          const SizedBox(width: 4),
                          Text(
                            campaign.location,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  campaign.description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),

                // Stats row
                Row(
                  children: [
                    Expanded(
                      child: _buildStatColumn(
                        '👥 ${_formatNumber(campaign.affectedPeople)}',
                        'People Affected',
                      ),
                    ),
                    Container(height: 40, width: 1, color: Colors.white24),
                    Expanded(
                      child: _buildStatColumn(
                        '\$${_formatAmount(campaign.goalAmount)}',
                        'Goal Amount',
                      ),
                    ),
                    Container(height: 40, width: 1, color: Colors.white24),
                    Expanded(
                      child: _buildStatColumn(
                        '${campaign.progressPercentage.toStringAsFixed(0)}%',
                        'Progress',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: campaign.progressPercentage / 100,
                    minHeight: 12,
                    backgroundColor: Colors.white12,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getUrgencyColor(campaign.urgencyLevel),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Donate button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showDonateDialog(campaign);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getUrgencyColor(campaign.urgencyLevel),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.favorite, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'DONATE NOW',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF00F5FF),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency) {
      case 'CRITICAL':
        return const Color(0xFFFF0000);
      case 'HIGH':
        return const Color(0xFFFF6600);
      case 'MEDIUM':
        return const Color(0xFFFF9900);
      default:
        return const Color(0xFF00FF00);
    }
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toStringAsFixed(0);
  }

  void _showDonateDialog(EmergencyCampaign campaign) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F3A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: _getUrgencyColor(campaign.urgencyLevel).withOpacity(0.5),
            width: 2,
          ),
        ),
        title: Text(
          '🚨 Emergency Donation',
          style: TextStyle(
            color: _getUrgencyColor(campaign.urgencyLevel),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              campaign.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your donation will be processed immediately and sent directly to help ${campaign.affectedPeople} affected people.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Emergency donation processed! Tx: 0x${campaign.id}'),
                  backgroundColor: _getUrgencyColor(campaign.urgencyLevel),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _getUrgencyColor(campaign.urgencyLevel),
            ),
            child: const Text('Donate \$100'),
          ),
        ],
      ),
    );
  }
}
