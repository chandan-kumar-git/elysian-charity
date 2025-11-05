/// AnimatedLoginBackground
/// Flutter widget wrapper for the Flame game scene.
///
/// This widget creates a layered composition:
/// 1. Bottom: Gradient background (soft blue/lavender)
/// 2. Middle: Flame game with character and particles
/// 3. Top: Login/OTP form (provided as child)
///
/// Features:
/// - Responsive scaling using MediaQuery
/// - Proper disposal of game resources
/// - Backdrop blur on login card for depth
/// - Event triggering for character animations
///
/// Usage:
/// ```dart
/// AnimatedLoginBackground(
///   child: LoginFormWidget(),
///   onGameReady: (game) {
///     // Trigger welcome animation
///     game.triggerWelcomeAnimation();
///   },
/// )
/// ```

import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../game/scene_game.dart';

class AnimatedLoginBackground extends StatefulWidget {
  const AnimatedLoginBackground({
    super.key,
    required this.child,
    this.onGameReady,
  });

  final Widget child;
  final Function(SceneGame)? onGameReady;

  @override
  State<AnimatedLoginBackground> createState() => _AnimatedLoginBackgroundState();
}

class _AnimatedLoginBackgroundState extends State<AnimatedLoginBackground> {
  late SceneGame _game;
  bool _gameReady = false;

  @override
  void initState() {
    super.initState();
    // Game will be initialized in build when size is available
  }

  @override
  void dispose() {
    // Cleanup game resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    // Initialize game with screen dimensions
    if (!_gameReady) {
      _game = SceneGame(
        screenWidth: size.width,
        screenHeight: size.height,
      );
      _gameReady = true;
      
      // Notify parent that game is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onGameReady?.call(_game);
      });
    }

    return Stack(
      children: [
        // Layer 1: Gradient Background
        _buildGradientBackground(),

        // Layer 2: Flame Game Scene (character + particles)
        Positioned.fill(
          child: GameWidget(
            game: _game,
          ),
        ),

        // Layer 3: Semi-transparent overlay for depth
        _buildDepthOverlay(),

        // Layer 4: Login/OTP Form (with blur effect)
        Center(
          child: _buildFormCard(),
        ),
      ],
    );
  }

  /// Build gradient background layer
  Widget _buildGradientBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFE0E7FF), // Soft lavender
            Color(0xFFC7D2FE), // Light periwinkle
            Color(0xFFA5B4FC), // Medium lavender
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  /// Build semi-transparent overlay for depth separation
  Widget _buildDepthOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.transparent,
              Colors.black.withOpacity(0.05),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  /// Build login form card with blur effect
  Widget _buildFormCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

/// Alternative version with darker theme
class AnimatedLoginBackgroundDark extends StatefulWidget {
  const AnimatedLoginBackgroundDark({
    super.key,
    required this.child,
    this.onGameReady,
  });

  final Widget child;
  final Function(SceneGame)? onGameReady;

  @override
  State<AnimatedLoginBackgroundDark> createState() =>
      _AnimatedLoginBackgroundDarkState();
}

class _AnimatedLoginBackgroundDarkState extends State<AnimatedLoginBackgroundDark> {
  late SceneGame _game;
  bool _gameReady = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    if (!_gameReady) {
      _game = SceneGame(
        screenWidth: size.width,
        screenHeight: size.height,
      );
      _gameReady = true;
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onGameReady?.call(_game);
      });
    }

    return Stack(
      children: [
        // Dark gradient background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1E1B4B), // Deep purple
                Color(0xFF312E81), // Rich indigo
                Color(0xFF4C1D95), // Dark violet
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        // Flame game
        Positioned.fill(
          child: GameWidget(game: _game),
        ),

        // Form card with dark theme
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 450),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2937).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
