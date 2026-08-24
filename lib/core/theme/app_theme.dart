import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_tokens.dart';
import '../constants/app_constants.dart';

/// DoseLens Theme strictly following the Refero Design Architecture
/// (Apple España Style Reference)
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: ColorTokens.canvas,
      colorScheme: const ColorScheme.light(
        primary: ColorTokens.electricBlue,
        onPrimary: Colors.white,
        secondary: ColorTokens.primaryInk,
        onSecondary: Colors.white,
        surface: ColorTokens.paper,
        onSurface: ColorTokens.primaryInk,
        error: ColorTokens.ember,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme(),
      cardTheme: CardThemeData(
        color: ColorTokens.paper,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusCard),
          side: const BorderSide(color: ColorTokens.hairline, width: 0.5),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorTokens.canvas,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: ColorTokens.primaryInk),
        titleTextStyle: TextStyle(
          color: ColorTokens.primaryInk,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: ColorTokens.hairline,
        thickness: 0.5,
        space: 1.0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorTokens.electricBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusPill),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.2,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorTokens.paper,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        hintStyle: const TextStyle(color: ColorTokens.midGray, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: const BorderSide(color: ColorTokens.hairline, width: 0.8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: const BorderSide(color: ColorTokens.hairline, width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: const BorderSide(color: ColorTokens.electricBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: const BorderSide(color: ColorTokens.ember, width: 1.0),
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
        primary: ColorTokens.electricBlue,
        onPrimary: Colors.white,
        secondary: ColorTokens.paper,
        onSecondary: ColorTokens.primaryInk,
        surface: ColorTokens.surfaceDark,
        onSurface: ColorTokens.textPrimaryDark,
        error: ColorTokens.ember,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      cardTheme: CardThemeData(
        color: ColorTokens.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusCard),
          side: const BorderSide(color: ColorTokens.borderDark, width: 0.5),
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
          letterSpacing: -0.3,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: ColorTokens.borderDark,
        thickness: 0.5,
        space: 1.0,
      ),
    );
  }
}
