import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_tokens.dart';

/// Typography hierarchy using Plus Jakarta Sans
class TextStyles {
  TextStyles._();

  // Display & Headings (Obsidian Slate with heavy weights)
  static TextStyle displayLarge = GoogleFonts.plusJakartaSans(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: ColorTokens.textPrimaryLight,
    letterSpacing: -0.5,
  );

  static TextStyle displayMedium = GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: ColorTokens.textPrimaryLight,
    letterSpacing: -0.3,
  );

  static TextStyle headingLarge = GoogleFonts.plusJakartaSans(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: ColorTokens.textPrimaryLight,
    letterSpacing: -0.2,
  );

  static TextStyle headingMedium = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: ColorTokens.textPrimaryLight,
  );

  // Body & Labels
  static TextStyle bodyMedium = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: ColorTokens.textPrimaryLight,
  );

  static TextStyle bodySecondary = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: ColorTokens.textSecondaryLight,
  );

  static TextStyle labelLarge = GoogleFonts.plusJakartaSans(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: ColorTokens.textPrimaryLight,
  );

  static TextStyle caption = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: ColorTokens.textMutedLight,
  );

  // Tabular Numbers for Metrics (Adherence %, Counts)
  static TextStyle metricNumber = GoogleFonts.plusJakartaSans(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: ColorTokens.textPrimaryLight,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}
