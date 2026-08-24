import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_tokens.dart';
import '../constants/app_constants.dart';

/// DoseLens Theme strictly following the Craftwork Design Architecture
/// (Refero Style 47c9e353: Acid Green, Paper Canvas, 10-14px Radii, Hairlines)
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: ColorTokens.paper,
      colorScheme: const ColorScheme.light(
        primary: ColorTokens.acidGreen,
        onPrimary: ColorTokens.inkBlack,
        secondary: ColorTokens.obsidian,
        onSecondary: Colors.white,
        surface: ColorTokens.snow,
        onSurface: ColorTokens.inkBlack,
        error: ColorTokens.vermillion,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      cardTheme: CardThemeData(
        color: ColorTokens.snow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusCard),
          side: const BorderSide(color: ColorTokens.hairline, width: 1.0),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorTokens.paper,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: ColorTokens.inkBlack),
        titleTextStyle: TextStyle(
          color: ColorTokens.inkBlack,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: ColorTokens.hairline,
        thickness: 1.0,
        space: 1.0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorTokens.acidGreen,
          foregroundColor: ColorTokens.inkBlack,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusButton),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.1,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorTokens.snow,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: ColorTokens.ashGray, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusButton),
          borderSide: const BorderSide(color: ColorTokens.hairline, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusButton),
          borderSide: const BorderSide(color: ColorTokens.hairline, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusButton),
          borderSide: const BorderSide(color: ColorTokens.inkBlack, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusButton),
          borderSide: const BorderSide(color: ColorTokens.vermillion, width: 1.0),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: ColorTokens.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: ColorTokens.acidGreen,
        onPrimary: ColorTokens.inkBlack,
        secondary: ColorTokens.snow,
        onSecondary: ColorTokens.inkBlack,
        surface: ColorTokens.surfaceDark,
        onSurface: ColorTokens.textPrimaryDark,
        error: ColorTokens.vermillion,
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
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
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
