import 'package:flutter/material.dart';

class PhoneContainer extends StatelessWidget {
  final Widget child;

  const PhoneContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      constraints: const BoxConstraints(
        maxWidth: 380,
        minHeight: 600,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(38),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF17243f),
            Color(0xFF111b33),
            Color(0xFF0b1329),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.55),
            blurRadius: 80,
            offset: const Offset(0, 30),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Top sensor notch
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 128,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 60, 28, 40),
            child: child,
          ),
        ],
      ),
    );
  }
}