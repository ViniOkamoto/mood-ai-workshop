import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary_500 = Color(0xFF7E93FF);
  static const Color primary_400 = Color(0xFF9EAFFF);
  static const Color primary_300 = Color(0xFFD9DFFD);
  static const Color primary_200 = Color(0xFFE4E8FD);
  static const Color primary_100 = Color(0xFFEFF5FF);

  // Secondary colors
  static const Color secondary_500 = Color(0xFF03DAC6);
  static const Color secondary_400 = Color(0xFF018786);

  // Background colors
  static const Color surface = Colors.white;

  // Text colors
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Colors.black;
  static const Color onSurface = Colors.black;

  // Error colors
  static const Color error = Color(0xFFB00020);
  static const Color onError = Colors.white;

  static const Color dark_900 = Color(0xFF121212);
  static const Color dark_800 = Color(0xFF1E1E1E);
  static const Color dark_700 = Color(0xFF262626);
  static const Color dark_600 = Color(0xFF333333);
  static const Color dark_500 = Color(0xFF404040);
  static const Color dark_400 = Color(0xFF525252);
  static const Color dark_300 = Color(0xFFB8B8B8);
  static const Color dark_200 = Color(0xFFA3A3A3);
  static const Color dark_100 = Color(0xFFD4D4D4);
  static const Color dark_50 = Color(0xFFF5F5F5);
}

class AppTextStyles {
  // Headings
  static const TextStyle h1 = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
    height: 1.0,
  );

  // Body text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16.0,
    height: 1.2,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14.0,
    height: 1.2,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12.0,
    height: 1.2,
  );

  // Button/Label text
  static const TextStyle button = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static const TextStyle label = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );
}
