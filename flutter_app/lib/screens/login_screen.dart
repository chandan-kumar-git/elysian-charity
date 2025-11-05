import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/auth_service.dart';
import 'dart:math' as math;
import 'dart:ui';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  late AnimationController _animController;
  late AnimationController _floatingController;
  late AnimationController _particleController;
  bool _isEmailMode = false;
  bool _otpSent = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    // Clear any previous error messages when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authService = Provider.of<AuthService>(context, listen: false);
      if (authService.errorMessage != null) {
        authService.clearError();
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _animController.dispose();
    _floatingController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0A0E27),
                  Color(0xFF1A1F3A),
                  Color(0xFF2D1B4E),
                ],
              ),
            ),
          ),

          // Animated Particles Background
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlesPainter(_particleController.value),
                size: Size.infinite,
              );
            },
          ),

          // Floating Orbs
          ..._buildFloatingOrbs(),

          // Close Button
          Positioned(
            top: 40,
            right: 40,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white.withOpacity(0.8), size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Main Content
          Center(
            child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        _buildLogo(),

                        const SizedBox(height: 48),

                        // Title
                        Text(
                          'Welcome to Elysian',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn().slideY(begin: 0.2),

                      const SizedBox(height: 16),

                      Text(
                        'Join thousands making a difference through blockchain',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 200.ms).slideY(
                            begin: 0.2,
                            delay: 200.ms,
                          ),

                      const SizedBox(height: 64),

                      // Glassmorphic Login Card
                      ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            padding: const EdgeInsets.all(40),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.15),
                                  Colors.white.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF7B3FF2).withOpacity(0.3),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                            if (!_isEmailMode) ...[
                              // Google Sign In Button
                              _buildGoogleButton(authService),

                              const SizedBox(height: 24),

                              // Divider
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Text(
                                      'OR',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Email OTP Button
                              _buildEmailButton(),
                            ] else ...[
                              // Email Input Form
                              _buildEmailForm(authService),

                              const SizedBox(height: 16),

                              TextButton(
                                onPressed: () {
                                  setState(() => _isEmailMode = false);
                                },
                                child: const Text(
                                  'Back to login options',
                                  style: TextStyle(color: Color(0xFF7B3FF2)),
                                ),
                              ),
                            ],

                            if (authService.errorMessage != null) ...[
                              const SizedBox(height: 24),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.red.withOpacity(0.5),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.error_outline,
                                        color: Colors.red),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Authentication error. Please try again.',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 400.ms)
                          .slideY(begin: 0.3, delay: 400.ms)
                          .scale(delay: 400.ms),

                      const SizedBox(height: 32),

                      // Terms
                      Text(
                        'By continuing, you agree to our Terms of Service\nand Privacy Policy',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 600.ms),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Loading Overlay
          if (authService.isLoading)
              Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0E27),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF7B3FF2),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          color: Color(0xFF7B3FF2),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Authenticating...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF7B3FF2),
                Color(0xFFB65FFF),
                Color(0xFF00D9FF),
              ],
              transform: GradientRotation(_animController.value * 2 * math.pi),
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF7B3FF2).withOpacity(0.6),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Icon(
            Icons.account_balance_wallet,
            color: Colors.white,
            size: 50,
          ),
        );
      },
    ).animate(onPlay: (controller) => controller.repeat()).shimmer(
          duration: 2000.ms,
          color: Colors.white.withOpacity(0.5),
        );
  }

  Widget _buildGoogleButton(AuthService authService) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          print('🔵 Google Sign-In button clicked!');
          print('🔵 Auth service loading: ${authService.isLoading}');
          print('🔵 Auth service user: ${authService.user}');
          
          // Prevent multiple clicks
          if (authService.isLoading) {
            print('⚠️ Already loading, ignoring click');
            return;
          }
          
          try {
            final success = await authService.signInWithGoogle();
            print('🔵 Sign-in result: $success');
            
            if (success && mounted) {
              print('✅ Sign-in successful! Navigating to home...');
              await Future.delayed(const Duration(milliseconds: 500));
              Navigator.pushReplacementNamed(context, '/');
            } else if (!success && mounted) {
              print('❌ Sign-in failed!');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Firebase not configured yet. The login feature will work once Firebase is set up!',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.orange,
                  duration: const Duration(seconds: 4),
                  action: SnackBarAction(
                    label: 'OK',
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
                ),
              );
            }
          } catch (e) {
            print('❌ Error in button click handler: $e');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('An error occurred: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.9),
                Colors.white.withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7B3FF2), Color(0xFFB65FFF)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.g_mobiledata,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Continue with Google',
                style: TextStyle(
                  color: Color(0xFF1A1F3A),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() => _isEmailMode = true);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7B3FF2), Color(0xFFB65FFF)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7B3FF2).withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.email, color: Colors.white),
              SizedBox(width: 12),
              Text(
                'Continue with Email OTP',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailForm(AuthService authService) {
    return Column(
      children: [
        // Email input field
        TextField(
          controller: _emailController,
          enabled: !_otpSent,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter your email',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
            prefixIcon: const Icon(Icons.email, color: Color(0xFF7B3FF2)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFF7B3FF2),
                width: 2,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Show OTP input field after OTP is sent
        if (_otpSent) ...[
          TextField(
            controller: _otpController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: InputDecoration(
              hintText: 'Enter 6-digit OTP',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
              prefixIcon: const Icon(Icons.lock, color: Color(0xFF00FF88)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF00FF88),
                  width: 2,
                ),
              ),
              counterText: '',
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Check the console for your OTP code (Development Mode)',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
        ],
        
        // Send OTP or Verify OTP button
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () async {
              if (!_otpSent) {
                // Send OTP
                if (_emailController.text.isNotEmpty) {
                  final success =
                      await authService.sendOTPToEmail(_emailController.text);
                  if (success && mounted) {
                    setState(() {
                      _otpSent = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('OTP generated! Check the console above for your code.'),
                        backgroundColor: Color(0xFF00FF88),
                        duration: Duration(seconds: 5),
                      ),
                    );
                  }
                }
              } else {
                // Verify OTP
                if (_otpController.text.length == 6) {
                  final success = await authService.verifyOTPAndSignIn(
                    _emailController.text,
                    _otpController.text,
                  );
                  if (success && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Login successful!'),
                        backgroundColor: Color(0xFF00FF88),
                      ),
                    );
                    Navigator.of(context).pushReplacementNamed('/');
                  } else if (mounted && authService.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(authService.errorMessage!),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _otpSent 
                      ? [const Color(0xFF00FF88), const Color(0xFF00CC6A)]
                      : [const Color(0xFF7B3FF2), const Color(0xFFB65FFF)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  _otpSent ? 'Verify OTP' : 'Send OTP',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        
        // Back to email button (if OTP sent)
        if (_otpSent) ...[
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              setState(() {
                _otpSent = false;
                _otpController.clear();
              });
            },
            child: Text(
              'Change email',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // Build floating orbs in background
  List<Widget> _buildFloatingOrbs() {
    return List.generate(5, (index) {
      final double size = 100 + (index * 50);
      final double left = (index * 0.2) * MediaQuery.of(context).size.width;
      final double top = (index * 0.15) * MediaQuery.of(context).size.height;
      
      return Positioned(
        left: left,
        top: top,
        child: AnimatedBuilder(
          animation: _floatingController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                math.sin(_floatingController.value * 2 * math.pi + index) * 20,
                math.cos(_floatingController.value * 2 * math.pi + index) * 20,
              ),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFF7B3FF2).withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

// Custom Painter for Particles
class ParticlesPainter extends CustomPainter {
  final double animationValue;

  ParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final random = math.Random(42);
    
    // Draw floating particles
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = (random.nextDouble() * size.height + animationValue * size.height) % size.height;
      final radius = random.nextDouble() * 3 + 1;
      final opacity = random.nextDouble() * 0.5 + 0.1;

      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Draw connecting lines between nearby particles
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;
    
    for (int i = 0; i < 20; i++) {
      final x1 = random.nextDouble() * size.width;
      final y1 = random.nextDouble() * size.height;
      final x2 = x1 + (random.nextDouble() - 0.5) * 100;
      final y2 = y1 + (random.nextDouble() - 0.5) * 100;

      paint.color = Color(0xFF7B3FF2).withOpacity(0.1);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) => true;
}
