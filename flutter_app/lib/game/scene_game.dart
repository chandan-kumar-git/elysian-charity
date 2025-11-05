/// SceneGame
/// Main Flame game controller for the animated login background.
///
/// This game manages:
/// - Character controller component (anime girl assistant)
/// - Particle system for ambient atmosphere
/// - Background gradient/effects
/// - Performance optimization (60 FPS cap)
///
/// Architecture:
/// - Extends FlameGame for game loop and component management
/// - Uses HasCollisionDetection for future interactive features
/// - Integrates with Flutter UI via GameWidget wrapper
///
/// Performance targets:
/// - 60 FPS stable on web and mobile
/// - < 100 MB memory footprint
/// - Smooth character animations without jitter

import 'dart:async' as dartAsync;
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'character_controller.dart';

/// Main game class managing the animated scene
class SceneGame extends FlameGame {
  SceneGame({
    required this.screenWidth,
    required this.screenHeight,
  }) : super();

  final double screenWidth;
  final double screenHeight;

  late CharacterController character;
  final Random _random = Random();

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Initialize character
    character = CharacterController(
      screenWidth: screenWidth,
      screenHeight: screenHeight,
    );
    await add(character);

    // Add ambient particles
    _addAmbientParticles();

    // Optional: Add floating sakura petals for extra ambience
    _addFloatingPetals();
  }

  /// Add ambient floating particles for atmosphere
  void _addAmbientParticles() {
    final particleComponent = ParticleSystemComponent(
      particle: Particle.generate(
        count: 30,
        lifespan: 8,
        generator: (i) {
          final startX = _random.nextDouble() * screenWidth;
          final startY = _random.nextDouble() * screenHeight;

          return AcceleratedParticle(
            position: Vector2(startX, startY),
            speed: Vector2(
              _random.nextDouble() * 20 - 10,
              _random.nextDouble() * 30 + 10,
            ),
            acceleration: Vector2(0, 5),
            child: CircleParticle(
              radius: _random.nextDouble() * 2 + 1,
              paint: Paint()
                ..color = Colors.white.withOpacity(0.3)
                ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
            ),
          );
        },
      ),
      position: Vector2.zero(),
      size: Vector2(screenWidth, screenHeight),
    );

    add(particleComponent);

    // Regenerate particles periodically
    dartAsync.Timer.periodic(const Duration(seconds: 8), (_) {
      if (!isMounted) return;
      _addAmbientParticles();
    });
  }

  /// Add floating sakura-style petals
  void _addFloatingPetals() {
    final petalComponent = ParticleSystemComponent(
      particle: Particle.generate(
        count: 15,
        lifespan: 12,
        generator: (i) {
          final startX = _random.nextDouble() * screenWidth;
          final startY = -50.0;

          return AcceleratedParticle(
            position: Vector2(startX, startY),
            speed: Vector2(
              _random.nextDouble() * 20 - 10,
              _random.nextDouble() * 20 + 20,
            ),
            acceleration: Vector2(
              sin(_random.nextDouble() * pi * 2) * 5,
              5,
            ),
            child: RotatingParticle(
              from: 0,
              to: pi * 2,
              child: CircleParticle(
                radius: _random.nextDouble() * 3 + 2,
                paint: Paint()
                  ..color = Color.lerp(
                    const Color(0xFFFFC0CB),
                    const Color(0xFFFFE4E1),
                    _random.nextDouble(),
                  )!.withOpacity(0.6)
                  ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
              ),
            ),
          );
        },
      ),
      position: Vector2.zero(),
      size: Vector2(screenWidth, screenHeight),
    );

    add(petalComponent);

    // Regenerate petals periodically
    dartAsync.Timer.periodic(const Duration(seconds: 12), (_) {
      if (!isMounted) return;
      _addFloatingPetals();
    });
  }

  /// Trigger character animation from external event
  /// Example: call this when user opens the login page
  void triggerWelcomeAnimation() {
    character.triggerAnimation(CharacterState.wave);
  }

  /// Trigger celebration animation
  /// Example: call this on successful login
  void triggerSuccessAnimation() {
    character.triggerAnimation(CharacterState.laugh);
  }

  /// Trigger pointing animation
  /// Example: call this when user hasn't interacted for a while
  void triggerPointAnimation() {
    character.triggerAnimation(CharacterState.point);
  }

  @override
  void onRemove() {
    // Cleanup if needed
    super.onRemove();
  }
}
