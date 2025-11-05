/// CharacterController
/// Handles character movement and animation state transitions for the anime girl assistant.
///
/// This component manages:
/// - State machine (Idle, WalkLeft, WalkRight, Point, Laugh)
/// - Random behavior cycles every 10-15 seconds
/// - Smooth position interpolation using Flame effects
/// - Character depth positioning (behind login form)
///
/// The character is rendered as a custom painted sprite with vector-style animation
/// that mimics professional Rive-style motion without requiring external .riv files.
/// This approach provides full control while maintaining smooth 60 FPS performance.

import 'dart:async' as dartAsync;
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

/// Character animation states
enum CharacterState {
  idle,       // Standing still with breathing animation
  walkLeft,   // Walking toward left edge
  walkRight,  // Walking toward right edge
  point,      // Pointing gesture toward login form
  laugh,      // Happy/cheer animation
  wave,       // Friendly greeting
}

/// Main character controller component
/// Extends PositionComponent for movement and rendering
class CharacterController extends PositionComponent {
  CharacterController({
    required this.screenWidth,
    required this.screenHeight,
  }) : super(
          size: Vector2(200, 400), // Character dimensions
          anchor: Anchor.bottomCenter,
        );

  final double screenWidth;
  final double screenHeight;

  // State management
  CharacterState _currentState = CharacterState.idle;
  CharacterState get currentState => _currentState;

  // Movement properties
  bool _movingRight = true;
  double _walkSpeed = 30.0; // pixels per second
  double _targetX = 0.0;

  // Animation timing
  double _animationTime = 0.0;
  double _idlePhase = 0.0;
  double _blinkTimer = 0.0;
  bool _isBlinking = false;

  // Behavior randomization
  dartAsync.Timer? _behaviorTimer;
  final Random _random = Random();

  // Character visual properties
  double _armAngle = 0.0;
  double _legPhase = 0.0;
  double _breathScale = 1.0;
  double _headTilt = 0.0;

  // Speech bubble
  String? _speechBubbleText;
  double _speechBubbleAlpha = 0.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Position character at bottom center initially
    position = Vector2(screenWidth / 2, screenHeight - 50);
    _targetX = position.x;

    // Start behavior randomization timer
    _startBehaviorTimer();
  }

  @override
  void onRemove() {
    _behaviorTimer?.cancel();
    super.onRemove();
  }

  /// Start periodic behavior changes
  void _startBehaviorTimer() {
    _behaviorTimer = dartAsync.Timer.periodic(
      Duration(seconds: 10 + _random.nextInt(6)), // 10-15 seconds
      (_) => _randomizeBehavior(),
    );
  }

  /// Pick a random behavior state
  void _randomizeBehavior() {
    if (_currentState != CharacterState.idle) {
      return; // Don't interrupt active animations
    }

    final choices = [
      CharacterState.walkLeft,
      CharacterState.walkRight,
      CharacterState.point,
      CharacterState.laugh,
      CharacterState.wave,
    ];

    _changeState(choices[_random.nextInt(choices.length)]);
  }

  /// Change character state with appropriate setup
  void _changeState(CharacterState newState) {
    _currentState = newState;
    _animationTime = 0.0;

    switch (newState) {
      case CharacterState.walkLeft:
        _movingRight = false;
        _targetX = 150.0; // Left boundary
        _showSpeechBubble('Let me check...');
        break;

      case CharacterState.walkRight:
        _movingRight = true;
        _targetX = screenWidth - 150.0; // Right boundary
        _showSpeechBubble('Over here!');
        break;

      case CharacterState.point:
        _showSpeechBubble('Login here! →');
        // Return to idle after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          if (_currentState == CharacterState.point) {
            _changeState(CharacterState.idle);
          }
        });
        break;

      case CharacterState.laugh:
        _showSpeechBubble('Welcome! 😊');
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (_currentState == CharacterState.laugh) {
            _changeState(CharacterState.idle);
          }
        });
        break;

      case CharacterState.wave:
        _showSpeechBubble('Hello there!');
        Future.delayed(const Duration(milliseconds: 1800), () {
          if (_currentState == CharacterState.wave) {
            _changeState(CharacterState.idle);
          }
        });
        break;

      case CharacterState.idle:
        _speechBubbleText = null;
        break;
    }
  }

  /// Show speech bubble with text
  void _showSpeechBubble(String text) {
    _speechBubbleText = text;
    _speechBubbleAlpha = 1.0;

    // Fade out after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      _speechBubbleAlpha = 0.0;
    });
  }

  @override
  void update(double dt) {
    super.update(dt);

    _animationTime += dt;

    // Update blink timer
    _blinkTimer += dt;
    if (_blinkTimer > 3.5 && !_isBlinking) {
      _isBlinking = true;
      _blinkTimer = 0.0;
    } else if (_isBlinking && _blinkTimer > 0.15) {
      _isBlinking = false;
      _blinkTimer = 0.0;
    }

    // Fade out speech bubble
    if (_speechBubbleAlpha > 0) {
      _speechBubbleAlpha = max(0, _speechBubbleAlpha - dt * 0.3);
    }

    // State-specific updates
    switch (_currentState) {
      case CharacterState.idle:
        _updateIdleAnimation(dt);
        break;

      case CharacterState.walkLeft:
      case CharacterState.walkRight:
        _updateWalkAnimation(dt);
        break;

      case CharacterState.point:
        _updatePointAnimation(dt);
        break;

      case CharacterState.laugh:
        _updateLaughAnimation(dt);
        break;

      case CharacterState.wave:
        _updateWaveAnimation(dt);
        break;
    }
  }

  /// Idle animation - gentle breathing and subtle movements
  void _updateIdleAnimation(double dt) {
    _idlePhase += dt;
    _breathScale = 1.0 + sin(_idlePhase * 2) * 0.015;
    _headTilt = sin(_idlePhase * 1.5) * 0.03;
  }

  /// Walk animation - leg movement and horizontal translation
  void _updateWalkAnimation(double dt) {
    _legPhase += dt * 8; // Walk cycle speed

    // Move toward target
    final direction = _movingRight ? 1 : -1;
    final newX = position.x + (_walkSpeed * direction * dt);

    // Check if reached target
    if ((_movingRight && newX >= _targetX) || (!_movingRight && newX <= _targetX)) {
      position.x = _targetX;
      _changeState(CharacterState.idle);
    } else {
      position.x = newX;
    }

    // Breathing continues during walk
    _breathScale = 1.0 + sin(_animationTime * 3) * 0.01;
  }

  /// Point animation - arm extends toward login form
  void _updatePointAnimation(double dt) {
    _armAngle = sin(_animationTime * 3) * 0.2 + 0.5;
    _breathScale = 1.0 + sin(_animationTime * 2) * 0.01;
  }

  /// Laugh animation - bouncing motion
  void _updateLaughAnimation(double dt) {
    _breathScale = 1.0 + (sin(_animationTime * 6)).abs() * 0.05;
    _headTilt = sin(_animationTime * 5) * 0.1;
  }

  /// Wave animation - arm waving motion
  void _updateWaveAnimation(double dt) {
    _armAngle = sin(_animationTime * 4) * 0.4;
    _breathScale = 1.0 + sin(_animationTime * 2) * 0.015;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Apply depth opacity when character is "behind" login form
    // (Center 60% of screen has reduced opacity)
    final centerZone = screenWidth * 0.6;
    final leftBound = (screenWidth - centerZone) / 2;
    final rightBound = screenWidth - leftBound;
    
    double opacity = 1.0;
    if (position.x > leftBound && position.x < rightBound) {
      opacity = 0.75; // Behind login card
    }

    canvas.save();
    
    // Apply opacity
    if (opacity < 1.0) {
      canvas.saveLayer(null, Paint()..color = Colors.white.withOpacity(opacity));
    }

    // Flip character when moving left
    if (!_movingRight && _currentState == CharacterState.walkLeft) {
      canvas.scale(-1.0, 1.0);
      canvas.translate(-size.x, 0);
    }

    // Apply breathing scale
    canvas.translate(size.x / 2, size.y);
    canvas.scale(_breathScale, _breathScale);
    canvas.translate(-size.x / 2, -size.y);

    // Draw character components
    _drawCharacter(canvas);

    // Draw speech bubble
    if (_speechBubbleText != null && _speechBubbleAlpha > 0) {
      _drawSpeechBubble(canvas);
    }

    if (opacity < 1.0) {
      canvas.restore();
    }
    canvas.restore();
  }

  /// Draw the anime girl character
  void _drawCharacter(Canvas canvas) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Character center position
    final centerX = size.x / 2;
    final bodyY = size.y * 0.4;

    // === LEGS === (navy skirt bottom visible)
    _drawLegs(canvas, centerX, bodyY);

    // === SKIRT === (knee-length, navy)
    _drawSkirt(canvas, centerX, bodyY);

    // === BODY === (white shirt, red tie)
    _drawBody(canvas, centerX, bodyY);

    // === ARMS ===
    _drawArms(canvas, centerX, bodyY);

    // === HEAD === (skin tone)
    _drawHead(canvas, centerX, bodyY);

    // === HAIR === (anime-style, pink/brown)
    _drawHair(canvas, centerX, bodyY);

    // === FACE === (eyes, mouth)
    _drawFace(canvas, centerX, bodyY);
  }

  void _drawLegs(Canvas canvas, double centerX, double bodyY) {
    final paint = Paint()
      ..color = const Color(0xFFFFE0BD) // Skin tone
      ..style = PaintingStyle.fill;

    final legWidth = 12.0;
    final legHeight = size.y * 0.35;
    final legGap = 16.0;

    // Walking animation
    double leftLegOffset = 0;
    double rightLegOffset = 0;
    if (_currentState == CharacterState.walkLeft || _currentState == CharacterState.walkRight) {
      leftLegOffset = sin(_legPhase) * 15;
      rightLegOffset = sin(_legPhase + pi) * 15;
    }

    // Left leg
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          centerX - legGap - legWidth,
          bodyY + size.y * 0.25 + leftLegOffset,
          legWidth,
          legHeight,
        ),
        const Radius.circular(6),
      ),
      paint,
    );

    // Right leg
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          centerX + legGap,
          bodyY + size.y * 0.25 + rightLegOffset,
          legWidth,
          legHeight,
        ),
        const Radius.circular(6),
      ),
      paint,
    );

    // Sneakers (white with accent)
    final shoePaint = Paint()..color = Colors.white;
    final shoeAccent = Paint()..color = const Color(0xFFE74C3C);

    // Left shoe
    canvas.drawOval(
      Rect.fromLTWH(
        centerX - legGap - legWidth - 4,
        bodyY + size.y * 0.25 + legHeight + leftLegOffset,
        legWidth + 12,
        16,
      ),
      shoePaint,
    );
    canvas.drawCircle(
      Offset(centerX - legGap - 2, bodyY + size.y * 0.25 + legHeight + leftLegOffset + 8),
      4,
      shoeAccent,
    );

    // Right shoe
    canvas.drawOval(
      Rect.fromLTWH(
        centerX + legGap - 4,
        bodyY + size.y * 0.25 + legHeight + rightLegOffset,
        legWidth + 12,
        16,
      ),
      shoePaint,
    );
    canvas.drawCircle(
      Offset(centerX + legGap + 8, bodyY + size.y * 0.25 + legHeight + rightLegOffset + 8),
      4,
      shoeAccent,
    );
  }

  void _drawSkirt(Canvas canvas, double centerX, double bodyY) {
    final paint = Paint()
      ..color = const Color(0xFF2C3E50) // Navy blue
      ..style = PaintingStyle.fill;

    // Pleated skirt effect
    final skirtPath = Path();
    skirtPath.moveTo(centerX - 45, bodyY + 20);
    skirtPath.lineTo(centerX - 55, bodyY + size.y * 0.25);
    skirtPath.lineTo(centerX - 35, bodyY + size.y * 0.25);
    skirtPath.lineTo(centerX - 15, bodyY + size.y * 0.25);
    skirtPath.lineTo(centerX + 15, bodyY + size.y * 0.25);
    skirtPath.lineTo(centerX + 35, bodyY + size.y * 0.25);
    skirtPath.lineTo(centerX + 55, bodyY + size.y * 0.25);
    skirtPath.lineTo(centerX + 45, bodyY + 20);
    skirtPath.close();

    canvas.drawPath(skirtPath, paint);

    // Pleat lines
    final pleatPaint = Paint()
      ..color = Colors.black12
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (double x = -35; x <= 35; x += 20) {
      canvas.drawLine(
        Offset(centerX + x, bodyY + 20),
        Offset(centerX + x, bodyY + size.y * 0.25),
        pleatPaint,
      );
    }
  }

  void _drawBody(Canvas canvas, double centerX, double bodyY) {
    // White shirt
    final shirtPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          centerX - 40,
          bodyY - 50,
          80,
          70,
        ),
        const Radius.circular(8),
      ),
      shirtPaint,
    );

    // Collar
    final collarPaint = Paint()
      ..color = const Color(0xFFF0F0F0)
      ..style = PaintingStyle.fill;

    final collarPath = Path();
    collarPath.moveTo(centerX, bodyY - 50);
    collarPath.lineTo(centerX - 20, bodyY - 40);
    collarPath.lineTo(centerX - 15, bodyY - 30);
    collarPath.lineTo(centerX, bodyY - 35);
    collarPath.close();

    canvas.drawPath(collarPath, collarPaint);

    final collarPath2 = Path();
    collarPath2.moveTo(centerX, bodyY - 50);
    collarPath2.lineTo(centerX + 20, bodyY - 40);
    collarPath2.lineTo(centerX + 15, bodyY - 30);
    collarPath2.lineTo(centerX, bodyY - 35);
    collarPath2.close();

    canvas.drawPath(collarPath2, collarPaint);

    // Red tie
    final tiePaint = Paint()
      ..color = const Color(0xFFE74C3C)
      ..style = PaintingStyle.fill;

    final tiePath = Path();
    tiePath.moveTo(centerX, bodyY - 35);
    tiePath.lineTo(centerX - 8, bodyY - 25);
    tiePath.lineTo(centerX - 6, bodyY + 10);
    tiePath.lineTo(centerX, bodyY + 15);
    tiePath.lineTo(centerX + 6, bodyY + 10);
    tiePath.lineTo(centerX + 8, bodyY - 25);
    tiePath.close();

    canvas.drawPath(tiePath, tiePaint);
  }

  void _drawArms(Canvas canvas, double centerX, double bodyY) {
    final paint = Paint()
      ..color = const Color(0xFFFFE0BD) // Skin tone
      ..style = PaintingStyle.fill;

    final armWidth = 14.0;
    final armLength = 55.0;

    // Left arm
    canvas.save();
    canvas.translate(centerX - 40, bodyY - 30);
    canvas.rotate(-0.3);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, armWidth, armLength),
        const Radius.circular(7),
      ),
      paint,
    );
    canvas.restore();

    // Right arm - animated for pointing/waving
    canvas.save();
    canvas.translate(centerX + 40, bodyY - 30);
    
    double armRotation = 0.3;
    if (_currentState == CharacterState.point) {
      armRotation = -0.5 + _armAngle;
    } else if (_currentState == CharacterState.wave) {
      armRotation = -0.8 + _armAngle;
    }
    
    canvas.rotate(armRotation);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-armWidth, 0, armWidth, armLength),
        const Radius.circular(7),
      ),
      paint,
    );
    canvas.restore();
  }

  void _drawHead(Canvas canvas, double centerX, double bodyY) {
    final paint = Paint()
      ..color = const Color(0xFFFFE0BD) // Skin tone
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(centerX, bodyY - 50);
    canvas.rotate(_headTilt);

    // Head oval
    canvas.drawOval(
      Rect.fromCenter(
        center: const Offset(0, -30),
        width: 70,
        height: 85,
      ),
      paint,
    );

    canvas.restore();
  }

  void _drawHair(Canvas canvas, double centerX, double bodyY) {
    final paint = Paint()
      ..color = const Color(0xFF8B4513) // Brown hair
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(centerX, bodyY - 50);
    canvas.rotate(_headTilt);

    // Top hair mass
    canvas.drawOval(
      Rect.fromCenter(
        center: const Offset(0, -40),
        width: 75,
        height: 50,
      ),
      paint,
    );

    // Side bangs
    canvas.drawCircle(const Offset(-25, -30), 20, paint);
    canvas.drawCircle(const Offset(25, -30), 20, paint);

    // Twin tails (anime style)
    final tailPaint = Paint()
      ..color = const Color(0xFF8B4513)
      ..style = PaintingStyle.fill;

    // Left tail
    final leftTailPath = Path();
    leftTailPath.moveTo(-35, -20);
    leftTailPath.quadraticBezierTo(-45, 0, -40, 30);
    leftTailPath.quadraticBezierTo(-35, 35, -30, 30);
    leftTailPath.quadraticBezierTo(-32, 0, -25, -20);
    leftTailPath.close();
    canvas.drawPath(leftTailPath, tailPaint);

    // Right tail
    final rightTailPath = Path();
    rightTailPath.moveTo(35, -20);
    rightTailPath.quadraticBezierTo(45, 0, 40, 30);
    rightTailPath.quadraticBezierTo(35, 35, 30, 30);
    rightTailPath.quadraticBezierTo(32, 0, 25, -20);
    rightTailPath.close();
    canvas.drawPath(rightTailPath, tailPaint);

    canvas.restore();
  }

  void _drawFace(Canvas canvas, double centerX, double bodyY) {
    canvas.save();
    canvas.translate(centerX, bodyY - 50);
    canvas.rotate(_headTilt);

    // Eyes
    final eyePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    if (_isBlinking) {
      // Closed eyes
      final blinkPaint = Paint()
        ..color = Colors.black
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      canvas.drawLine(const Offset(-15, -25), const Offset(-8, -25), blinkPaint);
      canvas.drawLine(const Offset(8, -25), const Offset(15, -25), blinkPaint);
    } else {
      // Open eyes (large anime eyes)
      final eyeWhite = Paint()..color = Colors.white;
      
      // Left eye
      canvas.drawOval(
        Rect.fromCenter(center: const Offset(-12, -25), width: 16, height: 20),
        eyeWhite,
      );
      canvas.drawCircle(const Offset(-12, -25), 6, eyePaint);
      canvas.drawCircle(const Offset(-10, -27), 3, Paint()..color = Colors.white);

      // Right eye
      canvas.drawOval(
        Rect.fromCenter(center: const Offset(12, -25), width: 16, height: 20),
        eyeWhite,
      );
      canvas.drawCircle(const Offset(12, -25), 6, eyePaint);
      canvas.drawCircle(const Offset(14, -27), 3, Paint()..color = Colors.white);
    }

    // Mouth (changes based on state)
    final mouthPaint = Paint()
      ..color = const Color(0xFFE74C3C)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    if (_currentState == CharacterState.laugh) {
      // Wide smile
      final smilePath = Path();
      smilePath.moveTo(-12, -10);
      smilePath.quadraticBezierTo(0, -2, 12, -10);
      canvas.drawPath(smilePath, mouthPaint);
    } else {
      // Gentle smile
      final smilePath = Path();
      smilePath.moveTo(-8, -12);
      smilePath.quadraticBezierTo(0, -8, 8, -12);
      canvas.drawPath(smilePath, mouthPaint);
    }

    canvas.restore();
  }

  void _drawSpeechBubble(Canvas canvas) {
    if (_speechBubbleText == null || _speechBubbleAlpha <= 0) return;

    final bubblePaint = Paint()
      ..color = Colors.white.withOpacity(_speechBubbleAlpha * 0.95)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.black.withOpacity(_speechBubbleAlpha * 0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Bubble position above character
    final bubbleX = size.x / 2;
    final bubbleY = -60.0;

    // Bubble background
    final bubbleRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(bubbleX, bubbleY),
        width: 150,
        height: 50,
      ),
      const Radius.circular(15),
    );

    canvas.drawRRect(bubbleRect, bubblePaint);
    canvas.drawRRect(bubbleRect, borderPaint);

    // Bubble tail
    final tailPath = Path();
    tailPath.moveTo(bubbleX - 10, bubbleY + 20);
    tailPath.lineTo(bubbleX, bubbleY + 30);
    tailPath.lineTo(bubbleX + 10, bubbleY + 20);
    tailPath.close();
    canvas.drawPath(tailPath, bubblePaint);
    canvas.drawPath(tailPath, borderPaint);

    // Text
    final textPainter = TextPainter(
      text: TextSpan(
        text: _speechBubbleText,
        style: TextStyle(
          color: Colors.black.withOpacity(_speechBubbleAlpha),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout(maxWidth: 140);
    textPainter.paint(
      canvas,
      Offset(bubbleX - textPainter.width / 2, bubbleY - textPainter.height / 2),
    );
  }

  /// Public method to trigger specific animations from external events
  void triggerAnimation(CharacterState state) {
    _changeState(state);
  }
}
