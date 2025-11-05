import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Camera screen with filters and photo capture
class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFf59e0b).withOpacity(0.3),
                  const Color(0xFFef4444).withOpacity(0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Icon(Icons.camera_alt, size: 120, color: Colors.white),
            ),
          ),

          // Top Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.flash_auto, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(),

          // Filters
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: ['Normal', 'Vivid', 'Cool', 'Warm', 'B&W'].map((filter) {
                  return Container(
                    width: 70,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFf59e0b), Color(0xFFef4444)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      filter,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ).animate().slideY(begin: 0.3, end: 0),

          // Bottom Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.photo_library, color: Colors.white, size: 32),
                      onPressed: () {},
                    ),
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: const Icon(Icons.camera, color: Colors.white, size: 32),
                    ),
                    IconButton(
                      icon: const Icon(Icons.flip_camera_ios, color: Colors.white, size: 32),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(delay: 200.ms),
        ],
      ),
    );
  }
}
