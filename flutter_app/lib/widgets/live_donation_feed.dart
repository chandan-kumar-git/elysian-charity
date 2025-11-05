import 'package:flutter/material.dart';
import '../services/realtime_donation_service.dart';
import 'dart:async';

/// Live donation feed widget - Shows real-time donations as they happen
class LiveDonationFeed extends StatefulWidget {
  final RealTimeDonationService donationService;

  const LiveDonationFeed({
    Key? key,
    required this.donationService,
  }) : super(key: key);

  @override
  State<LiveDonationFeed> createState() => _LiveDonationFeedState();
}

class _LiveDonationFeedState extends State<LiveDonationFeed> with SingleTickerProviderStateMixin {
  final List<DonationEvent> _donations = [];
  StreamSubscription? _subscription;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    // Start live feed
    widget.donationService.startLiveFeed();

    // Listen to donation stream
    _subscription = widget.donationService.donationStream.listen((event) {
      setState(() {
        _donations.insert(0, event);
        if (_donations.length > 20) {
          _donations.removeLast();
        }
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = widget.donationService.getLiveStats();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Live indicator and stats
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1A1F3A).withOpacity(0.9),
                const Color(0xFF0A0E27).withOpacity(0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF00FF00).withOpacity(0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00FF00).withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF00FF00),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00FF00).withOpacity(0.8 * _pulseController.value),
                              blurRadius: 10 + (10 * _pulseController.value),
                              spreadRadius: 2 + (3 * _pulseController.value),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'LIVE DONATION FEED',
                    style: TextStyle(
                      color: Color(0xFF00FF00),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00FF00).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${stats['activeDonors']} Active Donors',
                      style: const TextStyle(
                        color: Color(0xFF00FF00),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    'Today',
                    '\$${(stats['amountToday'] as double).toStringAsFixed(0)}',
                    const Color(0xFF00F5FF),
                  ),
                  Container(height: 40, width: 1, color: Colors.white24),
                  _buildStatItem(
                    'Total',
                    '\$${((stats['totalAmount'] as double) / 1000).toStringAsFixed(0)}K',
                    const Color(0xFFB967FF),
                  ),
                  Container(height: 40, width: 1, color: Colors.white24),
                  _buildStatItem(
                    'Donations',
                    '${stats['totalDonations']}',
                    const Color(0xFFFF006E),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Donation feed
        Container(
          height: 400,
          decoration: BoxDecoration(
            color: const Color(0xFF0A0E27).withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF00F5FF).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: _donations.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        color: Color(0xFF00F5FF),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Waiting for live donations...',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _donations.length,
                  itemBuilder: (context, index) {
                    return _buildDonationCard(_donations[index], index);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
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
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDonationCard(DonationEvent donation, int index) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF1A1F3A).withOpacity(0.8),
                    const Color(0xFF0A0E27).withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: donation.isVerified
                      ? const Color(0xFF00FF00).withOpacity(0.3)
                      : const Color(0xFFFF9900).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Campaign emoji
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF00F5FF).withOpacity(0.2),
                          const Color(0xFFB967FF).withOpacity(0.2),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        donation.campaignEmoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Donation info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              donation.donorName,
                              style: const TextStyle(
                                color: Color(0xFF00F5FF),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              donation.country,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 12,
                              ),
                            ),
                            if (donation.isVerified) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.verified,
                                color: Color(0xFF00FF00),
                                size: 14,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'to ${donation.campaignName}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          donation.timeAgo,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Amount
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00FF00), Color(0xFF00DD00)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00FF00).withOpacity(0.3),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Text(
                      '\$${donation.amount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
