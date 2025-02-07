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
        secondary: AppColors.secondary_500,
        secondaryContainer: AppColors.secondary_400,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.onPrimary,
        onSecondary: AppColors.onSecondary,
        onSurface: AppColors.onSurface,
        onError: AppColors.onError,
        brightness: Brightness.light,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: AppTextStyles.displayLarge,
          fontWeight: FontWeight.w600,
        ),
        displayMedium: TextStyle(
          fontSize: AppTextStyles.displayMedium,
          fontWeight: FontWeight.w600,
        ),
        displaySmall: TextStyle(fontSize: AppTextStyles.displaySmall),
        headlineLarge: TextStyle(
          fontSize: AppTextStyles.headlineLarge,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          fontSize: AppTextStyles.headlineMedium,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          fontSize: AppTextStyles.headlineSmall,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          fontSize: AppTextStyles.titleLarge,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          fontSize: AppTextStyles.titleMedium,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          fontSize: AppTextStyles.titleSmall,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          fontSize: AppTextStyles.bodyLarge,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: TextStyle(
          fontSize: AppTextStyles.bodyMedium,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          fontSize: AppTextStyles.bodySmall,
          fontWeight: FontWeight.w400,
        ),
      ),
      useMaterial3: true,
    );
  }
}
