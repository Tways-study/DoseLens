import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_tokens.dart';
import '../constants/app_constants.dart';

/// DoseLens Theme strictly following Palette 2: "Precision Digital Rx"
/// (Electric Cerulean, Midnight Obsidian, Ice Paper Canvas, Cool Hairlines)
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: ColorTokens.icePaper,
      colorScheme: const ColorScheme.light(
        primary: ColorTokens.electricCerulean,
        onPrimary: Colors.white,
        secondary: ColorTokens.midnightObsidian,
        onSecondary: Colors.white,
        surface: ColorTokens.snow,
        onSurface: ColorTokens.midnightObsidian,
        error: ColorTokens.crimsonAlert,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      cardTheme: CardThemeData(
        color: ColorTokens.snow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusCard),
          side: const BorderSide(color: ColorTokens.coolHairline, width: 1.0),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorTokens.icePaper,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: ColorTokens.midnightObsidian),
        titleTextStyle: TextStyle(
          color: ColorTokens.midnightObsidian,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: ColorTokens.coolHairline,
        thickness: 1.0,
        space: 1.0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorTokens.electricCerulean,
          foregroundColor: Colors.white,
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: ColorTokens.mutedMist, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusButton),
          borderSide:
              const BorderSide(color: ColorTokens.coolHairline, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusButton),
          borderSide:
              const BorderSide(color: ColorTokens.coolHairline, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusButton),
          borderSide:
              const BorderSide(color: ColorTokens.electricCerulean, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusButton),
          borderSide:
              const BorderSide(color: ColorTokens.crimsonAlert, width: 1.0),
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
        primary: ColorTokens.electricCerulean,
        onPrimary: Colors.white,
        secondary: ColorTokens.snow,
        onSecondary: ColorTokens.midnightObsidian,
        surface: ColorTokens.surfaceDark,
        onSurface: ColorTokens.textPrimaryDark,
        error: ColorTokens.crimsonAlert,
        onError: Colors.white,
      ),
      textTheme:
          GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme),
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
