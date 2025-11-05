import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../cyberpunk_glitch_text.dart';

class ImpactCounters extends StatefulWidget {
  const ImpactCounters({Key? key}) : super(key: key);

  @override
  State<ImpactCounters> createState() => _ImpactCountersState();
}

class _ImpactCountersState extends State<ImpactCounters> {
  int _totalDonations = 0;
  int _activeDonors = 0;
  int _countriesReached = 0;
  int _livesImpacted = 0;

  final int _targetDonations = 1247350;
  final int _targetDonors = 12543;
  final int _targetCountries = 78;
  final int _targetLives = 234567;

  @override
  void initState() {
    super.initState();
    _animateCounters();
  }

  void _animateCounters() {
    const duration = Duration(milliseconds: 2000);
    const steps = 60;
    final stepDuration = Duration(milliseconds: duration.inMilliseconds ~/ steps);

    Timer.periodic(stepDuration, (timer) {
      if (timer.tick <= steps) {
        setState(() {
          _totalDonations = (_targetDonations * timer.tick / steps).round();
          _activeDonors = (_targetDonors * timer.tick / steps).round();
          _countriesReached = (_targetCountries * timer.tick / steps).round();
          _livesImpacted = (_targetLives * timer.tick / steps).round();
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF7B3FF2).withOpacity(0.1),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          CyberpunkGlitchText(
            text: 'Our Impact in Numbers',
            fontSize: 42,
          ),
          const SizedBox(height: 16),
          Text(
            'Real-time statistics powered by blockchain',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 48,
            runSpacing: 48,
            alignment: WrapAlignment.center,
            children: [
              _buildCounter(
                '\$${NumberFormat('#,###').format(_totalDonations)}',
                'Total Donations',
                Icons.attach_money,
                Color(0xFF00FF88),
              ),
              _buildCounter(
                NumberFormat('#,###').format(_activeDonors),
                'Active Donors',
                Icons.people,
                Color(0xFF00D9FF),
              ),
              _buildCounter(
                _countriesReached.toString(),
                'Countries Reached',
                Icons.public,
                Color(0xFF7B3FF2),
              ),
              _buildCounter(
                '${NumberFormat('#,###').format(_livesImpacted)}+',
                'Lives Impacted',
                Icons.favorite,
                Color(0xFFFF006E),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCounter(String value, String label, IconData icon, Color color) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [color.withOpacity(0.5), Colors.transparent],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 40),
          ),
          const SizedBox(height: 24),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
