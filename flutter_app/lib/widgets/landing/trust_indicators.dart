import 'package:flutter/material.dart';

class TrustIndicators extends StatelessWidget {
  const TrustIndicators({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 48),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIndicator(
            Icons.verified_user,
            'SSL Secured',
            Colors.green,
          ),
          _buildIndicator(
            Icons.security,
            'Blockchain Verified',
            Color(0xFF7B3FF2),
          ),
          _buildIndicator(
            Icons.gpp_good,
            '100% Transparent',
            Color(0xFF00D9FF),
          ),
          _buildIndicator(
            Icons.workspace_premium,
            'Non-Profit Certified',
            Color(0xFFFFBD00),
          ),
          _buildIndicator(
            Icons.lock,
            'Zero Fees',
            Color(0xFFFF006E),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                color.withOpacity(0.3),
                Colors.transparent,
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 32),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
