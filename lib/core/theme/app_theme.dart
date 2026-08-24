import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_tokens.dart';
import '../constants/app_constants.dart';

/// DoseLens Neo-Utility Theme Configuration
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: ColorTokens.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: ColorTokens.primaryTeal,
        onPrimary: Colors.white,
        secondary: ColorTokens.primarySlate,
        onSecondary: Colors.white,
        surface: ColorTokens.surfaceLight,
        onSurface: ColorTokens.textPrimaryLight,
        error: ColorTokens.alertCoral,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      cardTheme: CardThemeData(
        color: ColorTokens.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusCard),
          side: const BorderSide(color: ColorTokens.borderLight, width: 1.0),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorTokens.backgroundLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: ColorTokens.textPrimaryLight),
        titleTextStyle: TextStyle(
          color: ColorTokens.textPrimaryLight,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: ColorTokens.borderLight,
        thickness: 1.0,
        space: 1.0,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: ColorTokens.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: ColorTokens.primaryTeal,
        onPrimary: Colors.white,
        secondary: ColorTokens.surfaceLight,
        onSecondary: ColorTokens.textPrimaryLight,
        surface: ColorTokens.surfaceDark,
        onSurface: ColorTokens.textPrimaryDark,
        error: ColorTokens.alertCoral,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme),
      cardTheme: CardThemeData(
        color: ColorTokens.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusCard),
          side: const BorderSide(color: ColorTokens.borderDark, width: 1.0),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorTokens.backgroundDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: ColorTokens.textPrimaryDark),
        titleTextStyle: TextStyle(
          color: ColorTokens.textPrimaryDark,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: ColorTokens.borderDark,
        thickness: 1.0,
        space: 1.0,
      ),
    );
  }
}
