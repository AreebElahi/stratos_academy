import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF0C0E12);
  static const Color primary = Color(0xFF9BA8FF);
  static const Color primaryDim = Color(0xFF4963FF);
  static const Color surfaceContainerHighest = Color(0xFF22262B);
  static const Color surfaceContainerHigh = Color(0xFF1C2025);
  static const Color surfaceContainerLow = Color(0xFF111417);
  static const Color surfaceContainerLowest = Color(0xFF000000);
  static const Color onSurface = Color(0xFFF8F9FE);
  static const Color onSurfaceVariant = Color(0xFFA9ABB0);
  static const Color errorColor = Color(0xFFFF6E84);
  static const Color outline = Color(0xFF73757A);
  static const Color outlineVariant = Color(0xFF46484C);
  static const Color tertiary = Color(0xFFFFA4E4);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        background: background,
        surface: background,
        error: errorColor,
        onSurface: onSurface,
      ),
      fontFamily: 'Manrope',
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Space Grotesk', color: onSurface, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(fontFamily: 'Space Grotesk', color: onSurface, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(fontFamily: 'Space Grotesk', color: onSurface, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontFamily: 'Space Grotesk', color: onSurface, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(fontFamily: 'Manrope', color: onSurface),
        bodyMedium: TextStyle(fontFamily: 'Manrope', color: onSurfaceVariant),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerHighest,
        hintStyle: TextStyle(color: outline.withOpacity(0.5)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: errorColor.withOpacity(0.5), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: errorColor, width: 1.5),
        ),
        errorStyle: const TextStyle(
          color: errorColor,
          fontFamily: 'Manrope',
          fontSize: 12,
        ),
      ),
    );
  }
}
