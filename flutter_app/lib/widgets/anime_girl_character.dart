import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'dart:async';

class AnimeGirlCharacter extends StatefulWidget {
  const AnimeGirlCharacter({super.key});

  @override
  State<AnimeGirlCharacter> createState() => _AnimeGirlCharacterState();
}

class _AnimeGirlCharacterState extends State<AnimeGirlCharacter>
    with TickerProviderStateMixin {
  late AnimationController _walkController;
  late AnimationController _waveController;
  late AnimationController _blinkController;
  late AnimationController _positionController;
  
  bool _isWalking = true;
  bool _isWaving = false;
  bool _facingRight = true;
  double _currentX = 0.0;
  String _currentAction = 'idle';
  Timer? _actionTimer;
  Timer? _laughTimer;

  @override
  void initState() {
    super.initState();
    
    _walkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat();

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _positionController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _startRandomActions();
    _startRandomBlinks();
  }

  void _startRandomActions() {
    _actionTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      
      final random = math.Random();
      final action = random.nextInt(4);
      
      setState(() {
        switch (action) {
          case 0: // Walk
            _currentAction = 'walk';
            _startWalking();
            break;
          case 1: // Wave
            _currentAction = 'wave';
            _performWave();
            break;
          case 2: // Point to form
            _currentAction = 'point';
            _performPoint();
            break;
          case 3: // Idle/Laugh
            _currentAction = 'idle';
            _walkController.stop();
            break;
        }
      });
    });
  }

  void _startRandomBlinks() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      _blinkController.forward(from: 0.0);
    });
  }

  void _startWalking() {
    final random = math.Random();
    final targetX = random.nextDouble() * 0.6 - 0.3; // -0.3 to 0.3
    
    _positionController.animateTo(1.0, duration: const Duration(seconds: 3)).then((_) {
      if (mounted) {
        setState(() {
          _currentX = targetX;
          _facingRight = targetX > _currentX;
        });
        _positionController.reset();
      }
    });
  }

  void _performWave() {
    _isWaving = true;
    _walkController.stop();
    _waveController.repeat();
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isWaving = false;
          _waveController.stop();
        });
      }
    });
  }

  void _performPoint() {
    setState(() {
      _facingRight = true; // Face the form
    });
    _walkController.stop();
  }

  @override
  void dispose() {
    _actionTimer?.cancel();
    _laughTimer?.cancel();
    _walkController.dispose();
    _waveController.dispose();
    _blinkController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _walkController,
        _waveController,
        _blinkController,
        _positionController,
      ]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            _currentX * MediaQuery.of(context).size.width,
            0,
          ),
          child: Transform.scale(
            scaleX: _facingRight ? 1 : -1,
            child: SizedBox(
              width: 200,
              height: 400,
              child: CustomPaint(
                painter: AnimeGirlPainter(
                  walkProgress: _walkController.value,
                  waveProgress: _waveController.value,
                  blinkProgress: _blinkController.value,
                  isWaving: _isWaving,
                  currentAction: _currentAction,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AnimeGirlPainter extends CustomPainter {
  final double walkProgress;
  final double waveProgress;
  final double blinkProgress;
  final bool isWaving;
  final String currentAction;

  AnimeGirlPainter({
    required this.walkProgress,
    required this.waveProgress,
    required this.blinkProgress,
    required this.isWaving,
    required this.currentAction,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Body bounce when walking
    final bounce = currentAction == 'walk' 
        ? math.sin(walkProgress * 2 * math.pi) * 5 
        : 0.0;

    // Draw shadow
    _drawShadow(canvas, centerX, size.height - 10);

    // Draw legs
    _drawLegs(canvas, centerX, centerY + 80 + bounce);

    // Draw skirt
    _drawSkirt(canvas, centerX, centerY + 50 + bounce);

    // Draw body/torso
    _drawTorso(canvas, centerX, centerY + bounce);

    // Draw arms
    if (currentAction == 'point') {
      _drawPointingArm(canvas, centerX, centerY + 10 + bounce);
    } else if (isWaving) {
      _drawWavingArm(canvas, centerX, centerY + 10 + bounce);
    } else {
      _drawArms(canvas, centerX, centerY + 10 + bounce);
    }

    // Draw head
    _drawHead(canvas, centerX, centerY - 60 + bounce);

    // Draw hair
    _drawHair(canvas, centerX, centerY - 60 + bounce);

    // Draw face
    _drawFace(canvas, centerX, centerY - 60 + bounce);

    // Draw accessories
    _drawAccessories(canvas, centerX, centerY - 60 + bounce);
  }

  void _drawShadow(Canvas canvas, double x, double y) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x, y), width: 80, height: 20),
      paint,
    );
  }

  void _drawLegs(Canvas canvas, double x, double y) {
    final legPaint = Paint()
      ..color = const Color(0xFFFFDBCC)
      ..style = PaintingStyle.fill;

    final legSwing = currentAction == 'walk' 
        ? math.sin(walkProgress * 2 * math.pi) * 0.2 
        : 0.0;

    // Left leg
    final leftLegPath = Path();
    leftLegPath.moveTo(x - 15, y);
    leftLegPath.quadraticBezierTo(
      x - 12, y + 40,
      x - 10 + (legSwing * 10), y + 80,
    );
    canvas.drawPath(leftLegPath, legPaint..strokeWidth = 12..style = PaintingStyle.stroke);

    // Right leg
    final rightLegPath = Path();
    rightLegPath.moveTo(x + 15, y);
    rightLegPath.quadraticBezierTo(
      x + 12, y + 40,
      x + 10 - (legSwing * 10), y + 80,
    );
    canvas.drawPath(rightLegPath, legPaint..strokeWidth = 12);

    // Shoes
    final shoePaint = Paint()
      ..color = const Color(0xFF8B4513)
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(x - 10 + (legSwing * 10), y + 82),
        width: 20,
        height: 10,
      ),
      shoePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(x + 10 - (legSwing * 10), y + 82),
        width: 20,
        height: 10,
      ),
      shoePaint,
    );
  }

  void _drawSkirt(Canvas canvas, double x, double y) {
    final skirtPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF7c3aed),
          const Color(0xFF6366f1),
        ],
      ).createShader(Rect.fromLTWH(x - 50, y, 100, 40));

    final skirtPath = Path();
    skirtPath.moveTo(x, y);
    skirtPath.quadraticBezierTo(x - 40, y + 10, x - 50, y + 30);
    skirtPath.lineTo(x + 50, y + 30);
    skirtPath.quadraticBezierTo(x + 40, y + 10, x, y);
    
    canvas.drawPath(skirtPath, skirtPaint);

    // Skirt highlights
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawArc(
      Rect.fromCenter(center: Offset(x, y + 15), width: 60, height: 20),
      -0.5,
      1.0,
      false,
      highlightPaint,
    );
  }

  void _drawTorso(Canvas canvas, double x, double y) {
    final bodyPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Blouse
    final blousePath = Path();
    blousePath.moveTo(x, y - 20);
    blousePath.quadraticBezierTo(x - 30, y, x - 25, y + 30);
    blousePath.lineTo(x + 25, y + 30);
    blousePath.quadraticBezierTo(x + 30, y, x, y - 20);
    
    canvas.drawPath(blousePath, bodyPaint);

    // Collar
    final collarPaint = Paint()
      ..color = const Color(0xFF7c3aed)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(x, y - 15), 8, collarPaint);
  }

  void _drawArms(Canvas canvas, double x, double y) {
    final armPaint = Paint()
      ..color = const Color(0xFFFFDBCC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final armSwing = currentAction == 'walk' 
        ? math.sin(walkProgress * 2 * math.pi) * 0.3 
        : 0.0;

    // Left arm
    final leftArmPath = Path();
    leftArmPath.moveTo(x - 25, y);
    leftArmPath.quadraticBezierTo(
      x - 35, y + 20,
      x - 30 + (armSwing * 15), y + 40,
    );
    canvas.drawPath(leftArmPath, armPaint);

    // Right arm
    final rightArmPath = Path();
    rightArmPath.moveTo(x + 25, y);
    rightArmPath.quadraticBezierTo(
      x + 35, y + 20,
      x + 30 - (armSwing * 15), y + 40,
    );
    canvas.drawPath(rightArmPath, armPaint);

    // Hands
    canvas.drawCircle(Offset(x - 30 + (armSwing * 15), y + 42), 6, armPaint..style = PaintingStyle.fill);
    canvas.drawCircle(Offset(x + 30 - (armSwing * 15), y + 42), 6, armPaint);
  }

  void _drawWavingArm(Canvas canvas, double x, double y) {
    final armPaint = Paint()
      ..color = const Color(0xFFFFDBCC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final waveAngle = math.sin(waveProgress * 2 * math.pi) * 0.5;

    // Waving arm (right)
    final armPath = Path();
    armPath.moveTo(x + 25, y);
    armPath.quadraticBezierTo(
      x + 40, y - 20,
      x + 35 + (math.cos(waveAngle) * 10), y - 40 + (math.sin(waveAngle) * 10),
    );
    canvas.drawPath(armPath, armPaint);

    // Hand
    canvas.drawCircle(
      Offset(x + 35 + (math.cos(waveAngle) * 10), y - 38 + (math.sin(waveAngle) * 10)),
      6,
      armPaint..style = PaintingStyle.fill,
    );

    // Other arm normal
    final leftArmPath = Path();
    leftArmPath.moveTo(x - 25, y);
    leftArmPath.quadraticBezierTo(x - 35, y + 20, x - 30, y + 40);
    canvas.drawPath(leftArmPath, armPaint..style = PaintingStyle.stroke);
    canvas.drawCircle(Offset(x - 30, y + 42), 6, armPaint..style = PaintingStyle.fill);
  }

  void _drawPointingArm(Canvas canvas, double x, double y) {
    final armPaint = Paint()
      ..color = const Color(0xFFFFDBCC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    // Pointing arm (right)
    final armPath = Path();
    armPath.moveTo(x + 25, y);
    armPath.lineTo(x + 60, y - 10);
    canvas.drawPath(armPath, armPaint);

    // Pointing finger
    canvas.drawCircle(Offset(x + 65, y - 10), 5, armPaint..style = PaintingStyle.fill);

    // Other arm
    final leftArmPath = Path();
    leftArmPath.moveTo(x - 25, y);
    leftArmPath.quadraticBezierTo(x - 35, y + 20, x - 30, y + 40);
    canvas.drawPath(leftArmPath, armPaint..style = PaintingStyle.stroke);
    canvas.drawCircle(Offset(x - 30, y + 42), 6, armPaint..style = PaintingStyle.fill);
  }

  void _drawHead(Canvas canvas, double x, double y) {
    final headPaint = Paint()
      ..color = const Color(0xFFFFDBCC)
      ..style = PaintingStyle.fill;

    // Head
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x, y), width: 50, height: 60),
      headPaint,
    );

    // Neck
    canvas.drawRect(
      Rect.fromCenter(center: Offset(x, y + 35), width: 15, height: 20),
      headPaint,
    );
  }

  void _drawHair(Canvas canvas, double x, double y) {
    final hairPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF8B4513),
          const Color(0xFF654321),
        ],
      ).createShader(Rect.fromLTWH(x - 35, y - 40, 70, 80))
      ..style = PaintingStyle.fill;

    // Hair back
    final hairPath = Path();
    hairPath.moveTo(x, y - 30);
    hairPath.quadraticBezierTo(x - 35, y - 25, x - 30, y + 20);
    hairPath.quadraticBezierTo(x - 20, y + 40, x, y + 35);
    hairPath.quadraticBezierTo(x + 20, y + 40, x + 30, y + 20);
    hairPath.quadraticBezierTo(x + 35, y - 25, x, y - 30);
    
    canvas.drawPath(hairPath, hairPaint);

    // Bangs
    for (int i = 0; i < 5; i++) {
      final bangX = x - 20 + (i * 10);
      final bangPath = Path();
      bangPath.moveTo(bangX, y - 25);
      bangPath.quadraticBezierTo(
        bangX + 3,
        y - 10,
        bangX,
        y + 5,
      );
      canvas.drawPath(bangPath, hairPaint..style = PaintingStyle.stroke..strokeWidth = 8);
    }
  }

  void _drawFace(Canvas canvas, double x, double y) {
    final eyePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final eyeHeight = blinkProgress < 0.5 ? 8.0 : 8.0 * (1 - blinkProgress);

    // Eyes
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x - 12, y - 5), width: 10, height: eyeHeight),
      eyePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x + 12, y - 5), width: 10, height: eyeHeight),
      eyePaint,
    );

    // Eye shine
    if (eyeHeight > 4) {
      final shinePaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(x - 10, y - 7), 3, shinePaint);
      canvas.drawCircle(Offset(x + 14, y - 7), 3, shinePaint);
    }

    // Eyebrows
    final eyebrowPaint = Paint()
      ..color = const Color(0xFF654321)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(x - 18, y - 15), Offset(x - 6, y - 13), eyebrowPaint);
    canvas.drawLine(Offset(x + 6, y - 13), Offset(x + 18, y - 15), eyebrowPaint);

    // Nose
    final nosePaint = Paint()
      ..color = const Color(0xFFFFB4A2)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(x, y + 5), 2, nosePaint);

    // Mouth (smile)
    final mouthPaint = Paint()
      ..color = const Color(0xFFFF6B9D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final mouthPath = Path();
    mouthPath.moveTo(x - 10, y + 15);
    mouthPath.quadraticBezierTo(x, y + 20, x + 10, y + 15);
    canvas.drawPath(mouthPath, mouthPaint);

    // Blush
    final blushPaint = Paint()
      ..color = const Color(0xFFFFB4A2).withOpacity(0.5)
      ..style = PaintingStyle.fill;
    
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x - 20, y + 8), width: 12, height: 8),
      blushPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x + 20, y + 8), width: 12, height: 8),
      blushPaint,
    );
  }

  void _drawAccessories(Canvas canvas, double x, double y) {
    // Hair bow
    final bowPaint = Paint()
      ..color = const Color(0xFF7c3aed)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(x - 25, y - 20), 8, bowPaint);
    canvas.drawCircle(Offset(x - 35, y - 22), 8, bowPaint);
    canvas.drawCircle(Offset(x - 30, y - 21), 5, Paint()..color = const Color(0xFF6366f1));
  }

  @override
  bool shouldRepaint(AnimeGirlPainter oldDelegate) {
    return oldDelegate.walkProgress != walkProgress ||
        oldDelegate.waveProgress != waveProgress ||
        oldDelegate.blinkProgress != blinkProgress ||
        oldDelegate.isWaving != isWaving ||
        oldDelegate.currentAction != currentAction;
  }
}
