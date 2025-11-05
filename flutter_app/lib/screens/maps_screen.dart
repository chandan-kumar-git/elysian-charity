import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Maps screen with charity locations
class MapsScreen extends StatelessWidget {
  const MapsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      body: Stack(
        children: [
          // Map View
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF8b5cf6).withOpacity(0.3),
                  const Color(0xFF6366f1).withOpacity(0.3),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.map, size: 100, color: Colors.white),
                  const SizedBox(height: 20),
                  Text(
                    'Charity Locations Nearby',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Top Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.search, size: 20),
                            SizedBox(width: 8),
                            Text('Search locations...'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(),

          // Location Cards
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(16),
                children: [
                  _buildLocationCard('Food Bank', '2.3 km', '🍞', 156),
                  _buildLocationCard('Medical Center', '4.1 km', '🏥', 89),
                  _buildLocationCard('Shelter', '1.8 km', '🏠', 234),
                ],
              ),
            ),
          ).animate().slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }

  Widget _buildLocationCard(String name, String distance, String icon, int helped) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 32)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF8b5cf6).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  distance,
                  style: const TextStyle(
                    color: Color(0xFF8b5cf6),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$helped people helped',
            style: TextStyle(
              color: Colors.black.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8b5cf6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Navigate'),
            ),
          ),
        ],
      ),
    );
  }
}
