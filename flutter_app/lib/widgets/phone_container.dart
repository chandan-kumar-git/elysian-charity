import 'package:flutter/material.dart';

class PhoneContainer extends StatelessWidget {
  final Widget child;

  const PhoneContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 430,
        minHeight: 800,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0a0f1e),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 60,
            spreadRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: child,
      ),
    );
  }
}