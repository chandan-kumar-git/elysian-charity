import 'package:flutter/material.dart';
import 'dart:math' as math;

class LiveActivityFeed extends StatefulWidget {
  const LiveActivityFeed({Key? key}) : super(key: key);

  @override
  State<LiveActivityFeed> createState() => _LiveActivityFeedState();
}

class _LiveActivityFeedState extends State<LiveActivityFeed>
    with SingleTickerProviderStateMixin {
  final List<DonationActivity> _activities = [];
  final List<String> _names = ['Alice', 'Bob', 'Charlie', 'Diana', 'Eve', 'Frank', 'Grace', 'Henry'];

  @override
  void initState() {
    super.initState();
    _addActivity();
  }

  void _addActivity() {
    if (mounted) {
      final random = math.Random();
      setState(() {
        _activities.insert(
          0,
          DonationActivity(
            name: _names[random.nextInt(_names.length)],
            amount: random.nextInt(900) + 100,
            time: 'Just now',
          ),
        );
        if (_activities.length > 5) {
          _activities.removeLast();
        }
      });
      Future.delayed(Duration(seconds: random.nextInt(3) + 2), _addActivity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt, color: Colors.yellow, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Live Activity',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._activities.map((activity) => _buildActivityItem(activity)).toList(),
        ],
      ),
    );
  }

  Widget _buildActivityItem(DonationActivity activity) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 500),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, (1 - value) * -20),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.withOpacity(0.2),
                    Colors.blue.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.purple,
                    child: Text(
                      activity.name[0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'donated \$${activity.amount}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    activity.time,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 11,
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

class DonationActivity {
  final String name;
  final int amount;
  final String time;

  DonationActivity({
    required this.name,
    required this.amount,
    required this.time,
  });
}
