import 'package:flutter/material.dart';

class GamingTheme {
  // Gaming Color Palette
  static const Color primaryDark = Color(0xFF0A0E27);
  static const Color secondaryDark = Color(0xFF1A1F3A);
  static const Color accentNeon = Color(0xFF00F5FF);
  static const Color accentPurple = Color(0xFF9D4EDD);
  static const Color accentPink = Color(0xFFFF006E);
  static const Color accentGreen = Color(0xFF00FF88);
  static const Color accentOrange = Color(0xFFFF6B35);
  static const Color accentYellow = Color(0xFFFFD60A);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0A0E27),
      Color(0xFF1A1F3A),
      Color(0xFF2D1B4E),
    ],
  );

  static const LinearGradient neonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00F5FF),
      Color(0xFF9D4EDD),
      Color(0xFFFF006E),
    ],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00FF88),
      Color(0xFF00D4AA),
    ],
  );

  static const LinearGradient errorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF006E),
      Color(0xFFFF6B35),
    ],
  );

  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFD60A),
      Color(0xFFFF6B35),
    ],
  );

  // Glassmorphism Box Decoration
  static BoxDecoration glassmorphism({
    Color? color,
    double opacity = 0.1,
    double blur = 10.0,
    double borderRadius = 20.0,
    Color borderColor = Colors.white,
    double borderWidth = 1.5,
  }) {
    return BoxDecoration(
      color: (color ?? Colors.white).withOpacity(opacity),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor.withOpacity(0.3),
        width: borderWidth,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: blur,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // Neon Glow Effect
  static List<BoxShadow> neonGlow({
    Color color = accentNeon,
    double blurRadius = 20.0,
    double spreadRadius = 0.0,
  }) {
    return [
      BoxShadow(
        color: color.withOpacity(0.5),
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
      ),
      BoxShadow(
        color: color.withOpacity(0.3),
        blurRadius: blurRadius * 2,
        spreadRadius: spreadRadius,
      ),
    ];
  }

  // Text Styles
  static TextStyle gamingTitle({double fontSize = 32.0, Color? color}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      color: color ?? Colors.white,
      letterSpacing: 2.0,
      shadows: [
        Shadow(
          color: Colors.black.withOpacity(0.5),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
        Shadow(
          color: accentNeon.withOpacity(0.3),
          blurRadius: 20,
          offset: const Offset(0, 0),
        ),
      ],
    );
  }

  static TextStyle gamingSubtitle({double fontSize = 18.0, Color? color}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color ?? Colors.white70,
      letterSpacing: 1.0,
    );
  }

  static TextStyle gamingBody({double fontSize = 16.0, Color? color}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: color ?? Colors.white,
      letterSpacing: 0.5,
    );
  }

  // Button Style
  static ButtonStyle gamingButton({
    Color? backgroundColor,
    Color? foregroundColor,
    double borderRadius = 16.0,
    double elevation = 8.0,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? accentNeon,
      foregroundColor: foregroundColor ?? primaryDark,
      elevation: elevation,
      shadowColor: (backgroundColor ?? accentNeon).withOpacity(0.5),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  // Input Decoration
  static InputDecoration gamingInput({
    required String hintText,
    IconData? prefixIcon,
    Color? iconColor,
    Color? borderColor,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.white.withOpacity(0.5),
        fontSize: 16,
      ),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: iconColor ?? accentNeon)
          : null,
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: (borderColor ?? accentNeon).withOpacity(0.3),
          width: 2,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: (borderColor ?? accentNeon).withOpacity(0.3),
          width: 2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: borderColor ?? accentNeon,
          width: 3,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    );
  }
}

