import 'package:flutter/material.dart';

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

  // Legacy compatibility
  static const Color primary = primaryBlue;
  static const Color secondary = Color(0xFF388E3C);
  static const Color secondaryLight = Color(0xFF66BB6A);
  static const Color secondaryDark = Color(0xFF1B5E20);
  static const Color background = backgroundGrey;
  static const Color surface = backgroundWhite;
  static const Color surfaceVariant = Color(0xFFF8F9FA);
  static const Color onPrimary = textWhite;
  static const Color onSecondary = textWhite;
  static const Color onBackground = textPrimary;
  static const Color onSurface = textPrimary;
  
  // Neutral Colors
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFF0F0F0);
  static const Color borderDark = Color(0xFFBDBDBD);
  
  // Shadow Colors
  static const Color shadow = Color(0x1A000000);
  static const Color shadowLight = Color(0x0D000000);
  static const Color shadowDark = Color(0x26000000);
  
  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);
}
