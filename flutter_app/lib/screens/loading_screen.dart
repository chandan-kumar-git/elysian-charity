import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';
import '../services/sound_service.dart';
import 'dart:async';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _particleController;
  late AnimationController _progressController;
  late AnimationController _robotController;
  late AnimationController _coinController;
  late AnimationController _orbController;
  late AnimationController _robotArmController;
  late AnimationController _robotJumpController;
  late AnimationController _matrixController;
  late AnimationController _glitchController;
  late AnimationController _hudController;
  
  final SoundService _soundService = SoundService();
  double _progress = 0.0;
  bool _isComplete = false;
  bool _isLoading = false;
  List<FallingCoin> _coins = [];
  List<MatrixColumn> _matrixColumns = [];
  List<ParticleExplosion> _explosions = [];
  int _caughtCoins = 0;
  String _loadingMessage = 'INITIALIZING...';
  int _currentMilestone = 0;
  final List<String> _loadingMessages = [
    'INITIALIZING BLOCKCHAIN...',
    'DECRYPTING QUANTUM KEYS...',
    'SYNCING NODES...',
    'CONNECTING TO NETWORK...',
    'MINING GENESIS BLOCK...',
    'VERIFYING SMART CONTRACTS...',
    'ESTABLISHING CONSENSUS...',
    'LOADING WALLET DATA...',
    'FINALIZING SETUP...',
    'READY TO LAUNCH!',
  ];

  @override
  void initState() {
    super.initState();
    
    // Sound service is already initialized globally, just get instance
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _particleController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _progressController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _robotController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    _coinController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();

    _orbController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _robotArmController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _robotJumpController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Matrix rain animation
    _matrixController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    // Glitch effect animation
    _glitchController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // HUD animation
    _hudController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    // Initialize Matrix columns (more visible)
    for (int i = 0; i < 30; i++) {
      _matrixColumns.add(MatrixColumn(
        x: i * 40.0,
        speed: 2.0 + math.Random().nextDouble() * 3.0,
        startY: -math.Random().nextDouble() * 500,
      ));
    }
    
    // Don't auto-start - wait for user to click START button
  }

  void _startLoading() async {
    // Start background music
    _soundService.startBackgroundMusic();
    
    // Play button click sound
    _soundService.playButtonClick();
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 50);
    }
    
    // Navigate directly to dashboard
    Navigator.of(context).pushReplacementNamed('/');
  }

  void _catchCoin() async {
    setState(() {
      _caughtCoins++;
      // Each coin adds 10% progress
      _progress = (_caughtCoins * 0.1).clamp(0.0, 1.0);
      
      // Update loading message at milestones
      int milestone = (_progress * 10).toInt();
      if (milestone > _currentMilestone && milestone < _loadingMessages.length) {
        _currentMilestone = milestone;
        _loadingMessage = _loadingMessages[milestone];
        
        // Trigger glitch effect at milestones
        _glitchController.forward(from: 0.0);
        
        // Create particle explosion
        _explosions.add(ParticleExplosion(
          x: 0.5,
          y: 0.7,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ));
      }
    });
    
    // Haptic feedback
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 30);
    }
    _soundService.playButtonClick();
    
    // Check if loading is complete (10 coins caught)
    if (_caughtCoins >= 10 && !_isComplete) {
      _completeLoading();
    }
  }

  void _completeLoading() async {
    setState(() {
      _isComplete = true;
      _progress = 1.0;
      _loadingMessage = 'SYSTEM READY!';
    });
    
    // Completion feedback
    _soundService.playSuccess();
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 200);
    }
    
    // Big explosion
    _explosions.add(ParticleExplosion(
      x: 0.5,
      y: 0.5,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      scale: 3.0,
    ));
    
    // Robot victory animation
    _robotJumpController.forward(from: 0.0);
    
    // Wait before transitioning
    await Future.delayed(const Duration(milliseconds: 2000));
    
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  void _startCoinRain() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) { // Slower coin spawn
      if (!_isLoading || _isComplete) {
        timer.cancel();
        return;
      }
      
      if (mounted) {
        setState(() {
          _coins.add(FallingCoin(
            id: DateTime.now().millisecondsSinceEpoch,
            startX: 0.2 + math.Random().nextDouble() * 0.6,
          ));
          
          // Remove old coins
          _coins.removeWhere((coin) => 
            DateTime.now().millisecondsSinceEpoch - coin.id > 4000 // Longer life
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    _progressController.dispose();
    _robotController.dispose();
    _coinController.dispose();
    _orbController.dispose();
    _robotArmController.dispose();
    _robotJumpController.dispose();
    _matrixController.dispose();
    _glitchController.dispose();
    _hudController.dispose();
    _soundService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [
              const Color(0xFF1a1a2e),
              const Color(0xFF0a0a0f),
              Colors.black,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Matrix rain background (VERY VISIBLE)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _matrixController,
                builder: (context, child) {
                  // Update matrix columns
                  final size = MediaQuery.of(context).size;
                  for (var column in _matrixColumns) {
                    column.update(size.height);
                  }
                  return CustomPaint(
                    painter: MatrixRainPainter(
                      columns: _matrixColumns,
                      animationValue: _matrixController.value,
                    ),
                  );
                },
              ),
            ),
            
            // Animated particles background
            ...List.generate(30, (index) => _buildParticle(index)),
            
            // Floating orbs
            ...List.generate(5, (index) => _buildFloatingOrb(index)),
            
            // Grid background
            Positioned.fill(
              child: CustomPaint(
                painter: GridPainter(progress: _particleController.value),
              ),
            ),
            
            // Falling coins (hidden - not needed)
            // ..._coins.map((coin) => _buildFallingCoin(coin)),
            
            // Particle explosions (hidden - not needed)
            // ..._explosions.where((e) {
            //   final age = DateTime.now().millisecondsSinceEpoch - e.timestamp;
            //   return age < 2000; // Show for 2 seconds
            // }).map((explosion) => _buildExplosion(explosion)),
            
            // Robot catching coins (hidden - not needed)
            // if (_isLoading) _buildRobot(),
            
            // Glitch effect overlay (hidden - not needed)
            // if (_glitchController.value > 0)
            //   AnimatedBuilder(
            //     animation: _glitchController,
            //     builder: (context, child) {
            //       return _buildGlitchEffect();
            //     },
            //   ),
            
            // Holographic HUD overlay (hidden - not needed)
            // if (_isLoading)
            //   AnimatedBuilder(
            //     animation: _hudController,
            //     builder: (context, child) {
            //       return _buildHolographicHUD();
            //     },
            //   ),
            
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  
                  // 3D Rotating Cube/Blockchain Icon
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _rotationController,
                      _pulseController,
                    ]),
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateX(_rotationController.value * 2 * math.pi * 0.3)
                          ..rotateY(_rotationController.value * 2 * math.pi)
                          ..rotateZ(_rotationController.value * 2 * math.pi * 0.1),
                        child: Container(
                          width: 200 + (_pulseController.value * 20),
                          height: 200 + (_pulseController.value * 20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF7c3aed).withOpacity(0.8),
                                const Color(0xFF6366f1).withOpacity(0.8),
                                const Color(0xFF8b5cf6).withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF7c3aed).withOpacity(0.5),
                                blurRadius: 40 + (_pulseController.value * 20),
                                spreadRadius: 10 + (_pulseController.value * 10),
                              ),
                              BoxShadow(
                                color: const Color(0xFF6366f1).withOpacity(0.3),
                                blurRadius: 60 + (_pulseController.value * 30),
                                spreadRadius: 20 + (_pulseController.value * 15),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Blockchain grid pattern
                              Center(
                                child: CustomPaint(
                                  size: const Size(150, 150),
                                  painter: BlockchainGridPainter(
                                    progress: _rotationController.value,
                                  ),
                                ),
                              ),
                              // Center icon
                              Center(
                                child: Icon(
                                  Icons.hub_outlined,
                                  size: 80,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Brand Name with glow effect
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        const Color(0xFF7c3aed),
                        const Color(0xFF6366f1),
                        const Color(0xFF8b5cf6),
                      ],
                    ).createShader(bounds),
                    child: const Text(
                      'ELYSIAN CHAIN',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                        color: Colors.white,
                      ),
                    ),
                  ).animate(onPlay: (controller) => controller.repeat())
                    .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.3)),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    'Decentralized Future',
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 2,
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Coins caught counter
                  if (_isLoading)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFFFD700).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.monetization_on,
                            color: Color(0xFFFFD700),
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Coins Caught: $_caughtCoins',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn().scale(),
                  
                  const SizedBox(height: 20),
                  
                  // START Button
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: _startLoading,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical: 25,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF7c3aed),
                              Color(0xFF6366f1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(35),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7c3aed).withOpacity(0.6),
                              blurRadius: 25,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.rocket_launch,
                              color: Colors.white,
                              size: 32,
                            ),
                            const SizedBox(width: 15),
                            const Text(
                              'START',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3,
                              ),
                            ),
                          ],
                        ),
                      ).animate(onPlay: (controller) => controller.repeat())
                        .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.4))
                        .then()
                        .shake(duration: 1000.ms, hz: 2, curve: Curves.easeInOut),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
            
            // Bottom fade effect
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticle(int index) {
    final random = math.Random(index);
    final size = 2.0 + random.nextDouble() * 3;
    final startX = random.nextDouble();
    final startY = random.nextDouble();
    final duration = 3000 + random.nextInt(2000);
    
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _particleController,
        builder: (context, child) {
          final progress = (_particleController.value + (index * 0.1)) % 1.0;
          final opacity = (1 - progress) * 0.6;
          
          return Align(
            alignment: Alignment(
              (startX - 0.5) * 2,
              -1 + (progress * 2),
            ),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.lerp(
                  const Color(0xFF7c3aed),
                  const Color(0xFF6366f1),
                  random.nextDouble(),
                )!.withOpacity(opacity),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7c3aed).withOpacity(opacity * 0.5),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingOrb(int index) {
    final random = math.Random(index * 100);
    final size = 50.0 + random.nextDouble() * 100;
    
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _orbController,
        builder: (context, child) {
          final progress = (_orbController.value + (index * 0.2)) % 1.0;
          final angle = progress * 2 * math.pi;
          final radius = 0.3 + (index * 0.1);
          
          return Align(
            alignment: Alignment(
              math.cos(angle) * radius,
              math.sin(angle) * radius,
            ),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF7c3aed).withOpacity(0.1),
                    const Color(0xFF6366f1).withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRobot() {
    return Positioned(
      bottom: 100,
      right: 80, // Moved to right side
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _robotController,
          _robotArmController,
          _robotJumpController,
        ]),
        builder: (context, child) {
          // Smooth bounce with sine wave
          final bounce = math.sin(_robotController.value * math.pi) * 15;
          final tilt = math.sin(_robotController.value * math.pi) * 0.05;
          final armWave = math.sin(_robotArmController.value * math.pi);
          final jump = _robotJumpController.value * 30;
          
          return Transform.translate(
            offset: Offset(0, -bounce - jump),
            child: Transform.rotate(
              angle: tilt,
              child: Container(
                width: 160,
                height: 160,
                child: Stack(
                  children: [
                    // Shadow
                    Positioned(
                      bottom: -10,
                      left: 30,
                      child: Container(
                        width: 100,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Robot body
                    Positioned(
                      bottom: 20,
                      left: 30,
                      child: Container(
                        width: 100,
                        height: 90,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF7c3aed),
                              const Color(0xFF6366f1),
                              const Color(0xFF8b5cf6),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7c3aed).withOpacity(0.6),
                              blurRadius: 25,
                              spreadRadius: 5,
                            ),
                            BoxShadow(
                              color: const Color(0xFF6366f1).withOpacity(0.4),
                              blurRadius: 35,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Chest panel
                            Center(
                              child: Container(
                                width: 60,
                                height: 50,
                                margin: const EdgeInsets.only(top: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // LED indicators
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: List.generate(3, (i) {
                                        final delay = i * 0.3;
                                        final ledGlow = (math.sin(
                                          (_robotController.value + delay) * 2 * math.pi
                                        ) + 1) / 2;
                                        return Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: Color.lerp(
                                              Colors.white.withOpacity(0.3),
                                              Colors.white,
                                              ledGlow,
                                            ),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white.withOpacity(ledGlow * 0.8),
                                                blurRadius: 8,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            // Eyes
                            Positioned(
                              top: 15,
                              left: 20,
                              child: _buildEye(true),
                            ),
                            Positioned(
                              top: 15,
                              right: 20,
                              child: _buildEye(false),
                            ),
                            
                            // Mouth (happy when catching coins)
                            Positioned(
                              bottom: 15,
                              left: 25,
                              right: 25,
                              child: CustomPaint(
                                size: const Size(50, 10),
                                painter: SmilePainter(
                                  progress: _robotController.value,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Head antenna with pulsing light
                    Positioned(
                      top: 20,
                      left: 75,
                      child: Column(
                        children: [
                          // Antenna light
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD700),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFFD700).withOpacity(0.8),
                                  blurRadius: 15 + (bounce / 2),
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                          ),
                          // Antenna rod
                          Container(
                            width: 4,
                            height: 25,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(0xFF7c3aed),
                                  const Color(0xFF6366f1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Left arm (animated catching motion)
                    Positioned(
                      left: 10,
                      top: 60,
                      child: Transform.rotate(
                        angle: -0.5 - (armWave * 0.3),
                        child: Container(
                          width: 50,
                          height: 12,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF6366f1),
                                const Color(0xFF8b5cf6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6366f1).withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: const Color(0xFF7c3aed),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Right arm (animated catching motion)
                    Positioned(
                      right: 10,
                      top: 60,
                      child: Transform.rotate(
                        angle: 0.5 + (armWave * 0.3),
                        child: Container(
                          width: 50,
                          height: 12,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF6366f1),
                                const Color(0xFF8b5cf6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6366f1).withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: const Color(0xFF7c3aed),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Legs
                    Positioned(
                      bottom: 0,
                      left: 40,
                      child: Container(
                        width: 20,
                        height: 30,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366f1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 40,
                      child: Container(
                        width: 20,
                        height: 30,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366f1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEye(bool isLeft) {
    return AnimatedBuilder(
      animation: _robotController,
      builder: (context, child) {
        final blink = _robotController.value > 0.9 ? 0.0 : 1.0;
        return Container(
          width: 18,
          height: 18 * blink,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.8),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFF7c3aed),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFallingCoin(FallingCoin coin) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 3000), // Slower fall
      curve: Curves.easeIn,
      onEnd: () {
        // Remove coin after animation completes
        if (mounted) {
          setState(() {
            _coins.remove(coin);
          });
        }
      },
      builder: (context, progress, child) {
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;
        
        // Check if coin is caught by robot (now on right side)
        final robotY = screenHeight - 220;
        final coinY = progress * screenHeight;
        final coinX = coin.startX * screenWidth;
        final robotX = screenWidth - 80 - 80; // Right side position
        
        if (!coin.caught && 
            coinY >= robotY && 
            coinY <= robotY + 60 &&
            (coinX - robotX).abs() < 80) {
          coin.caught = true;
          
          // Schedule state update for next frame
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _catchCoin(); // Use the new catch coin method with milestone tracking
              
              // Robot jump animation
              _robotJumpController.forward(from: 0.0).then((_) {
                _robotJumpController.reverse();
              });
            }
          });
        }
        
        if (coin.caught && progress > 0.7) {
          return const SizedBox.shrink();
        }
        
        // Add some horizontal sway to the coin
        final sway = math.sin(progress * 4 * math.pi) * 20;
        
        return Positioned(
          left: coinX - 20 + sway,
          top: coinY,
          child: Transform.rotate(
            angle: progress * 6 * math.pi, // More rotations
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: Alignment.topLeft,
                  colors: [
                    const Color(0xFFFFD700),
                    const Color(0xFFFFA500),
                    const Color(0xFFFF8C00),
                  ],
                  stops: const [0.3, 0.7, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withOpacity(0.6),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                  BoxShadow(
                    color: const Color(0xFFFFA500).withOpacity(0.4),
                    blurRadius: 25,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Coin rim
                  Center(
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFFFE55C),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  // Ethereum symbol
                  Center(
                    child: Text(
                      'Ξ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 3,
                          ),
                        ],
                      ),
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

  Widget _buildExplosion(ParticleExplosion explosion) {
    final age = DateTime.now().millisecondsSinceEpoch - explosion.timestamp;
    final progress = age / 2000.0; // 2 second lifespan
    
    return Positioned.fill(
      child: CustomPaint(
        painter: ExplosionPainter(
          explosion: explosion,
          progress: progress,
        ),
      ),
    );
  }

  Widget _buildGlitchEffect() {
    final glitchOffset = (math.Random().nextDouble() - 0.5) * 20;
    final rgbSplit = _glitchController.value * 5;
    
    return Positioned.fill(
      child: Opacity(
        opacity: _glitchController.value,
        child: Stack(
          children: [
            // Red channel offset
            Transform.translate(
              offset: Offset(rgbSplit, 0),
              child: Container(
                color: Colors.red.withOpacity(0.2),
              ),
            ),
            // Cyan channel offset
            Transform.translate(
              offset: Offset(-rgbSplit, 0),
              child: Container(
                color: Colors.cyan.withOpacity(0.2),
              ),
            ),
            // Scan lines
            ...List.generate(20, (i) {
              if (math.Random().nextDouble() > 0.7) {
                return Positioned(
                  top: i * 40.0 + glitchOffset,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 2,
                    color: Colors.white.withOpacity(0.3),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHolographicHUD() {
    final hudOpacity = math.min(_hudController.value, 1.0);
    
    return Positioned.fill(
      child: Opacity(
        opacity: hudOpacity * 0.7,
        child: Stack(
          children: [
            // Top left corner brackets
            Positioned(
              top: 30,
              left: 30,
              child: _buildCornerBracket(true, true),
            ),
            // Top right corner brackets
            Positioned(
              top: 30,
              right: 30,
              child: _buildCornerBracket(true, false),
            ),
            // Bottom left corner brackets
            Positioned(
              bottom: 30,
              left: 30,
              child: _buildCornerBracket(false, true),
            ),
            // Bottom right corner brackets
            Positioned(
              bottom: 30,
              right: 30,
              child: _buildCornerBracket(false, false),
            ),
            // Top HUD info
            Positioned(
              top: 50,
              left: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHUDText('NODE 1: ${12 + (math.sin(_hudController.value * 4) * 3).toInt()}ms'),
                  const SizedBox(height: 5),
                  _buildHUDText('NODE 2: ${15 + (math.sin(_hudController.value * 5) * 4).toInt()}ms'),
                  const SizedBox(height: 5),
                  _buildHUDText('NODE 3: ${18 + (math.sin(_hudController.value * 6) * 5).toInt()}ms'),
                ],
              ),
            ),
            // Right side status
            Positioned(
              top: 50,
              right: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildHUDText('STATUS: ACTIVE'),
                  const SizedBox(height: 5),
                  _buildHUDText('SYNC: ${(_progress * 100).toInt()}%'),
                  const SizedBox(height: 5),
                  _buildHUDText(_loadingMessage),
                ],
              ),
            ),
            // Bottom center progress text
            if (_caughtCoins < 10)
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Center(
                  child: _buildHUDText('COINS CAUGHT: $_caughtCoins/10'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCornerBracket(bool isTop, bool isLeft) {
    return SizedBox(
      width: 40,
      height: 40,
      child: CustomPaint(
        painter: CornerBracketPainter(
          isTop: isTop,
          isLeft: isLeft,
          color: const Color(0xFF00F5FF),
        ),
      ),
    );
  }

  Widget _buildHUDText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF00F5FF),
        fontSize: 12,
        fontWeight: FontWeight.bold,
        fontFamily: 'monospace',
        shadows: [
          Shadow(
            color: Color(0xFF00F5FF),
            blurRadius: 5,
          ),
        ],
      ),
    );
  }
}

// Explosion particle painter
class ExplosionPainter extends CustomPainter {
  final ParticleExplosion explosion;
  final double progress;
  
  ExplosionPainter({required this.explosion, required this.progress});
  
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = explosion.x * size.width;
    final centerY = explosion.y * size.height;
    
    for (var particle in explosion.particles) {
      particle.update();
      if (particle.life <= 0) continue;
      
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.life)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        Offset(centerX + particle.x, centerY + particle.y),
        particle.size * particle.life,
        paint,
      );
      
      // Glow effect
      final glowPaint = Paint()
        ..color = particle.color.withOpacity(particle.life * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
      
      canvas.drawCircle(
        Offset(centerX + particle.x, centerY + particle.y),
        particle.size * particle.life * 2,
        glowPaint,
      );
    }
  }
  
  @override
  bool shouldRepaint(ExplosionPainter oldDelegate) => true;
}

// Corner bracket painter for HUD
class CornerBracketPainter extends CustomPainter {
  final bool isTop;
  final bool isLeft;
  final Color color;
  
  CornerBracketPainter({
    required this.isTop,
    required this.isLeft,
    required this.color,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    final path = Path();
    
    if (isTop && isLeft) {
      path.moveTo(size.width, 0);
      path.lineTo(0, 0);
      path.lineTo(0, size.height);
    } else if (isTop && !isLeft) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else if (!isTop && isLeft) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(CornerBracketPainter oldDelegate) => false;
}


// Matrix rain painter for visible green code
class MatrixRainPainter extends CustomPainter {
  final List<MatrixColumn> columns;
  final double animationValue;
  
  MatrixRainPainter({required this.columns, required this.animationValue});
  
  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    
    for (var column in columns) {
      for (int i = 0; i < column.characters.length; i++) {
        final y = column.y + (i * 20);
        if (y < -50 || y > size.height + 50) continue;
        
        // Calculate opacity - brighter at the head
        final opacity = i == 0 
            ? 1.0  // Head is fully visible
            : (1.0 - (i / column.characters.length)) * 0.9 + 0.1;
        
        textPainter.text = TextSpan(
          text: column.characters[i],
          style: TextStyle(
            color: const Color(0xFF00FF00).withOpacity(opacity), // Bright green
            fontSize: 18, // Larger for visibility
            fontWeight: i == 0 ? FontWeight.bold : FontWeight.normal,
            shadows: i == 0 ? [
              Shadow(
                color: const Color(0xFF00FF00),
                blurRadius: 10,
              ),
            ] : [],
          ),
        );
        
        textPainter.layout();
        textPainter.paint(canvas, Offset(column.x, y));
      }
    }
  }
  
  @override
  bool shouldRepaint(MatrixRainPainter oldDelegate) => true;
}

// Custom painter for blockchain grid
class BlockchainGridPainter extends CustomPainter {
  final double progress;

  BlockchainGridPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final gridSize = 30.0;
    final rows = 3;
    final cols = 3;

    // Draw interconnected grid
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        final x = center.dx + (j - 1) * gridSize;
        final y = center.dy + (i - 1) * gridSize;
        
        // Draw node
        final nodeOpacity = (0.5 + math.sin(progress * 2 * math.pi + i + j) * 0.5);
        paint.color = Colors.white.withOpacity(nodeOpacity * 0.6);
        canvas.drawCircle(Offset(x, y), 4, paint);
        
        // Draw connections
        if (j < cols - 1) {
          paint.color = Colors.white.withOpacity(0.2);
          canvas.drawLine(
            Offset(x, y),
            Offset(x + gridSize, y),
            paint,
          );
        }
        if (i < rows - 1) {
          paint.color = Colors.white.withOpacity(0.2);
          canvas.drawLine(
            Offset(x, y),
            Offset(x, y + gridSize),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(BlockchainGridPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// Grid painter for background
class GridPainter extends CustomPainter {
  final double progress;

  GridPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const gridSize = 50.0;
    
    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
    
    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) {
    return false;
  }
}

// Falling coin model
class FallingCoin {
  final int id;
  final double startX;
  bool caught;

  FallingCoin({
    required this.id,
    required this.startX,
    this.caught = false,
  });
}

// Smile painter for robot
class SmilePainter extends CustomPainter {
  final double progress;

  SmilePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final smileAmount = 0.5 + (math.sin(progress * 2 * math.pi) * 0.2);
    
    path.moveTo(0, size.height / 2);
    path.quadraticBezierTo(
      size.width / 2,
      size.height * smileAmount,
      size.width,
      size.height / 2,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(SmilePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// Matrix column data
class MatrixColumn {
  double x;
  double y;
  final double speed;
  final List<String> characters;
  static const String charSet = '01アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホ';
  
  MatrixColumn({
    required this.x,
    required this.speed,
    double? startY,
  }) : y = startY ?? 0.0,
       characters = List.generate(
         12,
         (index) => charSet[math.Random().nextInt(charSet.length)],
       );
  
  void update(double height) {
    y += speed;
    if (y > height + 200) {
      y = -200;
      // Refresh characters
      for (int i = 0; i < characters.length; i++) {
        if (math.Random().nextDouble() > 0.7) {
          characters[i] = charSet[math.Random().nextInt(charSet.length)];
        }
      }
    }
  }
}

// Particle explosion data
class ParticleExplosion {
  final double x;
  final double y;
  final int timestamp;
  final double scale;
  final List<ExplosionParticle> particles;
  
  ParticleExplosion({
    required this.x,
    required this.y,
    required this.timestamp,
    this.scale = 1.0,
  }) : particles = List.generate(
         (50 * scale).toInt(),
         (i) {
           final angle = (i / (50 * scale)) * 2 * math.pi;
           final speed = 2.0 + math.Random().nextDouble() * 3.0;
           return ExplosionParticle(
             vx: math.cos(angle) * speed,
             vy: math.sin(angle) * speed,
             color: [
               const Color(0xFF00F5FF),
               const Color(0xFFFF006E),
               const Color(0xFFB967FF),
               const Color(0xFF05FFA1),
             ][math.Random().nextInt(4)],
             size: 2.0 + math.Random().nextDouble() * 4.0,
             life: 1.0,
           );
         },
       );
}

class ExplosionParticle {
  double x;
  double y;
  final double vx;
  final double vy;
  final Color color;
  final double size;
  double life;
  
  ExplosionParticle({
    this.x = 0,
    this.y = 0,
    required this.vx,
    required this.vy,
    required this.color,
    required this.size,
    required this.life,
  });
  
  void update() {
    x += vx;
    y += vy;
    life -= 0.02;
  }
}
