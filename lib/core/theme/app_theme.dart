import 'package:flutter/material.dart';

class AppTheme {
  static const Color obsidianDark = Color(0xFF121212);
  static const Color obsidianSurface = Color(0xFF1E1E1E);
  static const Color goldPrimary = Color(0xFFD4AF37);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFFA0A0A0);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: obsidianDark,
      primaryColor: goldPrimary,
      appBarTheme: const AppBarTheme(
        backgroundColor: obsidianSurface,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: goldPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}