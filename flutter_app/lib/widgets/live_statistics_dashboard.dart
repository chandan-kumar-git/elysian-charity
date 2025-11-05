import 'package:flutter/material.dart';
import 'dart:math' as math;

class LiveStatisticsDashboard extends StatefulWidget {
  const LiveStatisticsDashboard({Key? key}) : super(key: key);

  @override
  State<LiveStatisticsDashboard> createState() => _LiveStatisticsDashboardState();
}

class _LiveStatisticsDashboardState extends State<LiveStatisticsDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _totalDonations = 1234567;
  int _totalUsers = 45678;
  double _impactScore = 87.5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Simulate live updates
    Future.delayed(const Duration(seconds: 2), _updateStats);
  }

  void _updateStats() {
    if (mounted) {
      setState(() {
        _totalDonations += math.Random().nextInt(100);
        _totalUsers += math.Random().nextInt(5);
        _impactScore = (87 + math.Random().nextDouble() * 3);
      });
      Future.delayed(const Duration(seconds: 3), _updateStats);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatCard(
            'Total Donations',
            '\$$_totalDonations',
            Icons.attach_money,
            Colors.green,
          ),
          _buildStatCard(
            'Active Users',
            '$_totalUsers',
            Icons.people,
            Colors.blue,
          ),
          _buildStatCard(
            'Impact Score',
            '${_impactScore.toStringAsFixed(1)}%',
            Icons.trending_up,
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 200,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.2),
                color.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withOpacity(0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3 + _controller.value * 0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 16),
              Text(
                value,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
