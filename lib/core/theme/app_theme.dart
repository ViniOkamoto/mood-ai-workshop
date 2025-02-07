import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: GoogleFonts.poppins().fontFamily,
      colorScheme: ColorScheme(
        primary: AppColors.primary_500,
        primaryContainer: AppColors.primary_400,
        secondary: AppColors.dark_900,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.onPrimary,
        onSecondary: AppColors.onSecondary,
        onSurface: AppColors.onSurface,
        onError: AppColors.onError,
        brightness: Brightness.light,
      ),
      textTheme: TextTheme(
        // Headings
        displayLarge: AppTextStyles.h1,
        headlineLarge: AppTextStyles.h2,
        headlineMedium: AppTextStyles.h3,

        // Body text
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,

        // Button/Label
        labelLarge: AppTextStyles.button,
        labelMedium: AppTextStyles.label,
      ),
      splashColor: AppColors.primary_100,
      highlightColor: AppColors.primary_100,
      useMaterial3: true,
    );
  }
}
