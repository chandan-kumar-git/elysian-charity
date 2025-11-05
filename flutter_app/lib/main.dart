import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/dashboard_screen.dart';
import 'screens/mobile_app_home.dart';
import 'screens/landing_page.dart';
import 'screens/login_screen.dart';
import 'screens/loading_screen.dart';
import 'screens/features_page.dart';
import 'screens/tokenomics_page.dart';
import 'screens/roadmap_page.dart';
import 'services/wallet_service.dart';
import 'services/contract_service.dart';
import 'services/auth_service.dart';
import 'services/sound_service.dart';
import 'config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized in main()');
  } catch (e) {
    print('⚠️ Firebase initialization failed in main(): $e');
  }
  
  // Initialize sound service globally
  final soundService = SoundService();
  await soundService.initialize();
  print('🔊 Sound service initialized');
  
  runApp(const ElysianApp());
}

class ElysianApp extends StatelessWidget {
  const ElysianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => WalletService()),
        ChangeNotifierProvider(create: (_) => ContractService()),
      ],
      child: MaterialApp(
        title: 'Elysian Chain',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF7c3aed),
            secondary: Color(0xFF6366f1),
            surface: Color(0xFF0c0c0c),
            background: Color(0xFF050816),
          ),
          fontFamily: 'Inter',
        ),
        initialRoute: '/loading',
        routes: {
          '/loading': (context) => const LoadingScreen(),
          '/': (context) => const LandingPage(),
          '/dashboard': (context) => const MobileAppHome(),
          '/old-dashboard': (context) => const DashboardScreen(),
          '/login': (context) => const LoginScreen(),
          '/features': (context) => const FeaturesPage(),
          '/tokenomics': (context) => const TokenomicsPage(),
          '/roadmap': (context) => const RoadmapPage(),
        },
      ).animate().fadeIn(duration: 500.ms),
    );
  }
}