import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class DonationTicker extends StatefulWidget {
  const DonationTicker({Key? key}) : super(key: key);

  @override
  State<DonationTicker> createState() => _DonationTickerState();
}

class _DonationTickerState extends State<DonationTicker> {
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  
  final List<DonationItem> _donations = [
    DonationItem('Sarah M.', '0.5 ETH', 'Education Fund', '🎓'),
    DonationItem('John D.', '1.2 ETH', 'Healthcare', '🏥'),
    DonationItem('Anonymous', '0.8 ETH', 'Clean Water', '💧'),
    DonationItem('Maria G.', '2.0 ETH', 'Emergency Relief', '🆘'),
    DonationItem('Alex K.', '0.3 ETH', 'Education Fund', '🎓'),
    DonationItem('Lisa P.', '1.5 ETH', 'Food Bank', '🍽️'),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_scrollController.hasClients &&
          _scrollController.position.hasContentDimensions) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.offset;
        
        if (currentScroll >= maxScroll) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.jumpTo(currentScroll + 1);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF7B3FF2).withOpacity(0.2),
            Color(0xFFB65FFF).withOpacity(0.1),
          ],
        ),
        border: Border(
          top: BorderSide(color: Color(0xFF7B3FF2).withOpacity(0.3)),
          bottom: BorderSide(color: Color(0xFF7B3FF2).withOpacity(0.3)),
        ),
      ),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: _donations.length * 100, // Infinite scroll effect
        itemBuilder: (context, index) {
          final donation = _donations[index % _donations.length];
          return _buildDonationItem(donation);
        },
      ),
    );
  }

  Widget _buildDonationItem(DonationItem donation) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Text(donation.emoji, style: TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Text(
            '${donation.donor} donated ${donation.amount}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'to ${donation.category}',
            style: TextStyle(
              color: Color(0xFF7B3FF2),
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.verified, color: Colors.green, size: 16),
        ],
      ),
    );
  }
}

class DonationItem {
  final String donor;
  final String amount;
  final String category;
  final String emoji;

  DonationItem(this.donor, this.amount, this.category, this.emoji);
}
