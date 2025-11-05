import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/dashboard_screen.dart';
import 'services/wallet_service.dart';
import 'services/contract_service.dart';

void main() {
  runApp(const ElysianCharityApp());
}

class ElysianCharityApp extends StatelessWidget {
  const ElysianCharityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WalletService()),
        ChangeNotifierProvider(create: (_) => ContractService()),
      ],
      child: MaterialApp(
        title: 'Elysian Charity',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Inter',
          scaffoldBackgroundColor: const Color(0xFF050816),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
        home: const DashboardScreen(),
      ),
    );
  }
}