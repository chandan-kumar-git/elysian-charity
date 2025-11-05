import 'package:flutter/material.dart';

class CyberpunkTheme {
  // Cyberpunk Color Palette
  static const Color neonPink = Color(0xFFFF006E);
  static const Color neonCyan = Color(0xFF00F5FF);
  static const Color neonPurple = Color(0xFFB967FF);
  static const Color neonYellow = Color(0xFFFDFF00);
  static const Color neonGreen = Color(0xFF05FFA1);
  static const Color electricBlue = Color(0xFF00D9FF);
  static const Color deepPurple = Color(0xFF5B0DAE);
  
  // Dark Backgrounds
  static const Color darkBg = Color(0xFF0A0118);
  static const Color darkBg2 = Color(0xFF120229);
  static const Color darkBg3 = Color(0xFF1A0933);
  
  // Glow effects
  static List<BoxShadow> neonGlow(Color color, {double intensity = 0.6}) {
    return [
      BoxShadow(
        color: color.withOpacity(intensity),
        blurRadius: 20,
        spreadRadius: 2,
      ),
      BoxShadow(
        color: color.withOpacity(intensity * 0.5),
        blurRadius: 40,
        spreadRadius: 4,
      ),
    ];
  }

  static List<BoxShadow> multiColorGlow() {
    return [
      BoxShadow(
        color: neonPink.withOpacity(0.3),
        blurRadius: 20,
        spreadRadius: 1,
      ),
      BoxShadow(
        color: neonCyan.withOpacity(0.3),
        blurRadius: 30,
        spreadRadius: 2,
      ),
    ];
  }

  // Gradient styles
  static const LinearGradient cyberpunkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF006E),
      Color(0xFFB967FF),
      Color(0xFF00F5FF),
    ],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0A0118),
      Color(0xFF120229),
      Color(0xFF1A0933),
    ],
  );

  static const LinearGradient neonBorderGradient = LinearGradient(
    colors: [
      Color(0xFFFF006E),
      Color(0xFF00F5FF),
      Color(0xFFB967FF),
      Color(0xFF05FFA1),
    ],
    stops: [0.0, 0.33, 0.66, 1.0],
  );

  // Text styles
  static TextStyle neonText(Color color, {double fontSize = 24, FontWeight? fontWeight}) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.bold,
      shadows: [
        Shadow(
          color: color.withOpacity(0.8),
          blurRadius: 10,
        ),
        Shadow(
          color: color.withOpacity(0.5),
          blurRadius: 20,
        ),
      ],
    );
  }

  // Animated border painter
  static BoxDecoration glitchBorder({double borderWidth = 2}) {
    return BoxDecoration(
      border: Border.all(
        width: borderWidth,
        color: Colors.transparent,
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: neonCyan.withOpacity(0.5),
          blurRadius: 10,
          spreadRadius: 1,
        ),
      ],
    );
  }
}
