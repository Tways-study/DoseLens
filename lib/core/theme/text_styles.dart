import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_tokens.dart';

/// Typography hierarchy strictly following the Craftwork Design Architecture
/// (Euclid Circular A / Plus Jakarta Sans geometric humanist scale)
class TextStyles {
  TextStyles._();

  // ── Display & Headings ─────────────────────────────────────────────────
  /// 36px Display Headline with signature Craftwork tight tracking (-1.08px)
  static TextStyle displayLarge = GoogleFonts.plusJakartaSans(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: ColorTokens.inkBlack,
    letterSpacing: -1.08,
    height: 1.13,
  );

  /// 28px Section Display with tight geometric tracking (-0.8px)
  static TextStyle displayMedium = GoogleFonts.plusJakartaSans(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: ColorTokens.inkBlack,
    letterSpacing: -0.8,
    height: 1.2,
  );

  /// 22px Heading with tight humanist tracking (-0.48px)
  static TextStyle headingLarge = GoogleFonts.plusJakartaSans(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: ColorTokens.inkBlack,
    letterSpacing: -0.48,
    height: 1.22,
  );

  /// 18px Card Title / Subheading (-0.32px)
  static TextStyle headingMedium = GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: ColorTokens.inkBlack,
    letterSpacing: -0.32,
    height: 1.3,
  );

  // ── Body & Informational Text ──────────────────────────────────────────
  /// 16px Editorial Body (-0.11px)
  static TextStyle bodyLarge = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: ColorTokens.inkBlack,
    letterSpacing: -0.11,
    height: 1.5,
  );

  /// 14px Standard Compact Body
  static TextStyle bodyMedium = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: ColorTokens.inkBlack,
    letterSpacing: -0.1,
    height: 1.5,
  );

  /// 14px Graphite Secondary Body
  static TextStyle bodySecondary = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: ColorTokens.graphite,
    letterSpacing: -0.1,
    height: 1.5,
  );

  /// 13px Label / Button Text
  static TextStyle labelLarge = GoogleFonts.plusJakartaSans(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: ColorTokens.inkBlack,
    letterSpacing: -0.1,
  );

  /// 11px Micro Caption
  static TextStyle caption = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: ColorTokens.graphite,
    letterSpacing: 0.0,
    height: 1.4,
  );

  /// Acid Green / Inset Tag Text (11px, weight 700)
  static TextStyle badge = GoogleFonts.plusJakartaSans(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: ColorTokens.inkBlack,
    letterSpacing: 0.2,
  );

  /// Tabular Figures for Metrics (e.g. 98% Adherence)
  static TextStyle metricNumber = GoogleFonts.plusJakartaSans(
    fontSize: 44,
    fontWeight: FontWeight.w800,
    color: ColorTokens.inkBlack,
    letterSpacing: -1.5,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}
