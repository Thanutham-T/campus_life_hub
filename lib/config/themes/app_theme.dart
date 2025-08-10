import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color primaryLight = Color(0xFFBBDEFB);
  
  // Background Colors
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color backgroundGrey = Color(0xFFF5F5F5);
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textWhite = Color(0xFFFFFFFF);
  
  // Tool Card Colors
  static const Color orangeGradientStart = Color(0xFFFF8A00);
  static const Color orangeGradientEnd = Color(0xFFFF6B00);
  static const Color redGradientStart = Color(0xFFFF5252);
  static const Color redGradientEnd = Color(0xFFE53935);
  static const Color greenGradientStart = Color(0xFF4CAF50);
  static const Color greenGradientEnd = Color(0xFF2E7D32);
  
  // Navigation Colors
  static const Color navigationActive = Color(0xFF1B4B87);
  static const Color navigationInactive = Color(0xFF9E9E9E);
  
  // Icon Colors
  static const Color iconWhite = Color(0xFFFFFFFF);
  static const Color iconGrey = Color(0xFF757575);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.navigationActive,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.backgroundGrey,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.navigationActive,
        foregroundColor: AppColors.textWhite,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.notoSansThai(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textWhite,
        ),
      ),
      textTheme: GoogleFonts.notoSansThaiTextTheme(
        TextTheme(
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.navigationActive,
          foregroundColor: AppColors.textWhite,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: AppColors.cardBackground,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.navigationActive,
        selectedItemColor: AppColors.textWhite,
        unselectedItemColor: AppColors.navigationInactive,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
