import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Color palette extracted directly from Figma CSS specifications.
class AppColors {
  AppColors._();

  // Primary brand colors
  static const Color primaryGreen = Color(0xFF105B48);
  static const Color navActiveGreen = Color(0xFF4F7A1F);
  static const Color accentGreen = Color(0xFFA8DC66);

  // Neutral text colors
  static const Color darkText = Color(0xFF1A1A1A);
  static const Color bodyText = Color(0xFF434343);
  static const Color mutedText = Color(0xFF7C7C7C);
  static const Color dotSeparator = Color(0x807C7C7C);

  // Surface & background
  static const Color surface = Color(0xFFFFFFFF);
  static const Color feedBackground = Color(0xFFF4F4F4);
  static const Color inputBackground = Color(0x05000000);
  static const Color iconButtonBackground = Color(0x05000000);
  static const Color borderLight = Color(0x1A000000);
  static const Color dividerLight = Color(0x1A000000);

  // Tag Badge Colors
  static const Color tagBuyBackground = Color(0xFFF7F3FF);
  static const Color tagBuyForeground = Color(0xFF5B21B6);

  static const Color tagRentBackground = Color(0xFFFFF9E5);
  static const Color tagRentForeground = Color(0xFFB07800);

  static const Color tagForRentBackground = Color(0xFFF6FBEF);
  static const Color tagForRentForeground = Color(0xFF4F7A1F);

  static const Color tagForSaleBackground = Color(0xFFF3F8FF);
  static const Color tagForSaleForeground = Color(0xFF1257B0);

  // Media overlays
  static const Color mediaOverlay = Color(0xB3000000);
  static const Color playIconBackground = Color(0x66000000);
}

/// App Typography and Theme configuration.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryGreen,
      scaffoldBackgroundColor: AppColors.surface,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryGreen,
        secondary: AppColors.accentGreen,
        surface: AppColors.surface,
        onSurface: AppColors.darkText,
        outline: AppColors.borderLight,
      ),
      textTheme: baseTextTheme.copyWith(
        titleLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
          height: 1.2,
          letterSpacing: -0.1,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.darkText,
          height: 1.2,
          letterSpacing: -0.1,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.darkText,
          height: 1.25,
          letterSpacing: -0.1,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.bodyText,
          height: 1.2,
          letterSpacing: -0.08,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.bodyText,
          height: 1.2,
          letterSpacing: -0.08,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.bodyText,
          height: 1.2,
          letterSpacing: -0.07,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: AppColors.mutedText,
          height: 1.2,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerLight,
        thickness: 0.5,
        space: 0,
      ),
    );
  }
}
