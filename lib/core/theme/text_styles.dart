import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_tokens.dart';

/// Typography hierarchy strictly following the Refero Design Architecture
/// (Apple España SF Pro / Inter typographic scale)
class TextStyles {
  TextStyles._();

  // ── Display & Hero Headlines (Inter / SF Pro Display) ──────────────────
  /// 36px Display Headline with tight tracking (-1.0px)
  static TextStyle displayLarge = GoogleFonts.inter(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: ColorTokens.primaryInk,
    letterSpacing: -1.0,
    height: 1.1,
  );

  /// 28px Section Display with warm, approachable tracking (+0.007em)
  static TextStyle displayMedium = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: ColorTokens.primaryInk,
    letterSpacing: 0.2,
    height: 1.2,
  );

  /// 22px Subsection Title
  static TextStyle headingLarge = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: ColorTokens.primaryInk,
    letterSpacing: -0.2,
    height: 1.25,
  );

  /// 18px Card Title / Group Label
  static TextStyle headingMedium = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: ColorTokens.primaryInk,
    letterSpacing: -0.15,
    height: 1.3,
  );

  // ── Body & Informational Text (Inter / SF Pro Text) ─────────────────────
  /// 17px Workhorse Body with signature negative tracking (-0.37px)
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: ColorTokens.primaryInk,
    letterSpacing: -0.37,
    height: 1.47,
  );

  /// 15px Standard Body
  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: ColorTokens.primaryInk,
    letterSpacing: -0.25,
    height: 1.4,
  );

  /// 15px Secondary / Muted Body
  static TextStyle bodySecondary = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: ColorTokens.midGray,
    letterSpacing: -0.2,
    height: 1.4,
  );

  /// 13px Label / Button Text
  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: ColorTokens.primaryInk,
    letterSpacing: -0.15,
  );

  /// 12px Caption / Subtitle
  static TextStyle caption = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: ColorTokens.midGray,
    letterSpacing: -0.12,
    height: 1.33,
  );

  /// "Nuevo" / Pill Badge Text (12px, weight 500)
  static TextStyle badge = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  /// Tabular Figures for Metrics (e.g. 94% Adherence)
  static TextStyle metricNumber = GoogleFonts.inter(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    color: ColorTokens.primaryInk,
    letterSpacing: -1.2,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}
