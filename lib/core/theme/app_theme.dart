import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_tokens.dart';
import '../constants/app_constants.dart';

/// 21n Design System Theme
/// Flat, border-driven, near-monochrome light-mode only.
/// Zero elevation. Zero shadows. Structure from Silver (#E5E7EB) hairlines.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final senTextTheme = GoogleFonts.senTextTheme();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: ColorTokens.fog,
      colorScheme: const ColorScheme.light(
        primary: ColorTokens.charcoal,
        onPrimary: Colors.white,
        secondary: ColorTokens.cobaltSignal,
        onSecondary: Colors.white,
        surface: ColorTokens.snow,
        onSurface: ColorTokens.ink,
        error: ColorTokens.error,
        onError: Colors.white,
      ),
      textTheme: senTextTheme,
      cardTheme: CardThemeData(
        color: ColorTokens.snow,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusCard),
          side: const BorderSide(color: ColorTokens.silver, width: 1.0),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: ColorTokens.snow,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        iconTheme: const IconThemeData(color: ColorTokens.ink),
        titleTextStyle: GoogleFonts.sen(
          color: ColorTokens.ink,
          fontSize: 19,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        shape: const Border(
          bottom: BorderSide(color: ColorTokens.silver, width: 1.0),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: ColorTokens.silver,
        thickness: 1.0,
        space: 1.0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorTokens.charcoal,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusButton),
          ),
          textStyle: GoogleFonts.sen(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ColorTokens.ink,
          side: const BorderSide(color: ColorTokens.silver, width: 1.0),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusButton),
          ),
          textStyle: GoogleFonts.sen(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorTokens.fog,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        hintStyle: GoogleFonts.sen(color: ColorTokens.ash, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusButton),
          borderSide: const BorderSide(color: ColorTokens.silver, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusButton),
          borderSide: const BorderSide(color: ColorTokens.silver, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusButton),
          borderSide: const BorderSide(color: ColorTokens.cobaltSignal, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusButton),
          borderSide: const BorderSide(color: ColorTokens.error, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusButton),
          borderSide: const BorderSide(color: ColorTokens.error, width: 1.5),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: ColorTokens.charcoal,
        contentTextStyle: GoogleFonts.sen(color: Colors.white, fontSize: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusButton),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: ColorTokens.snow,
        elevation: 0,
        selectedItemColor: ColorTokens.charcoal,
        unselectedItemColor: ColorTokens.ash,
      ),
    );
  }

  /// 21n is light-mode only. Dark theme is a minimal fallback.
  static ThemeData get darkTheme => lightTheme;
}
