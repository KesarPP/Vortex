import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VortexTheme {
  // Cyber-Noir / Tech-Forward colors
  static const Color background = Color(0xFF090D16);
  static const Color surface = Color(0xFF0D1117);
  static const Color neonCyan = Color(0xFF00F5FF);
  static const Color neonViolet = Color(0xFF7B2CBF);
  static const Color telemetryGreen = Color(0xFF10B981);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0AEC0);
  
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: neonCyan,
      canvasColor: surface,
      cardColor: surface,
      textTheme: GoogleFonts.rajdhaniTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.rajdhani(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 32),
        displayMedium: GoogleFonts.rajdhani(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 24),
        bodyLarge: GoogleFonts.inter(color: textPrimary, fontSize: 14),
        bodyMedium: GoogleFonts.inter(color: textSecondary, fontSize: 13),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        iconTheme: const IconThemeData(color: neonCyan),
        titleTextStyle: GoogleFonts.rajdhani(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: neonCyan,
        secondary: neonViolet,
        surface: surface,
        error: Colors.redAccent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: neonViolet,
          foregroundColor: textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.rajdhani(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }
}
