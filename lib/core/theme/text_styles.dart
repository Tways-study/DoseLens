import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_tokens.dart';

/// 21n Design System Typography — Sen, Major Second scale from 17px base
/// https://styles.refero.design/style/68d18deb-bb09-4258-8024-001af9c844c0
class TextStyles {
  TextStyles._();

  // ── Display ───────────────────────────────────────────────────────────────
  /// 56px · 700 · 1.07 — Hero / page-level display (atlas-scale presence)
  static TextStyle displayLarge = GoogleFonts.sen(
    fontSize: 56,
    fontWeight: FontWeight.w700,
    color: ColorTokens.ink,
    height: 1.07,
    letterSpacing: -0.5,
  );

  /// 44px · 500 · 1.5 — Section display / top-of-screen heading
  static TextStyle displayMedium = GoogleFonts.sen(
    fontSize: 44,
    fontWeight: FontWeight.w500,
    color: ColorTokens.ink,
    height: 1.5,
    letterSpacing: -0.3,
  );

  // ── Headings ──────────────────────────────────────────────────────────────
  /// 36px · 500 · 1.5 — Page headings
  static TextStyle headingLarge = GoogleFonts.sen(
    fontSize: 36,
    fontWeight: FontWeight.w500,
    color: ColorTokens.ink,
    height: 1.5,
    letterSpacing: -0.2,
  );

  /// 22px · 400 · 1.5 — Card titles, screen titles (heading-sm in 21n scale)
  static TextStyle headingMedium = GoogleFonts.sen(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    color: ColorTokens.ink,
    height: 1.5,
  );

  /// 19px · 600 · 1.5 — Subheadings, section labels
  static TextStyle subheading = GoogleFonts.sen(
    fontSize: 19,
    fontWeight: FontWeight.w600,
    color: ColorTokens.ink,
    height: 1.5,
  );

  // ── Body ──────────────────────────────────────────────────────────────────
  /// 17px · 400 · 1.5 — Base body (body-lg)
  static TextStyle bodyLarge = GoogleFonts.sen(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: ColorTokens.ink,
    height: 1.5,
  );

  /// 16px · 400 · 1.5 — Compact body
  static TextStyle bodyMedium = GoogleFonts.sen(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: ColorTokens.ink,
    height: 1.5,
  );

  /// 16px · 400 · 1.5 — Graphite secondary body copy
  static TextStyle bodySecondary = GoogleFonts.sen(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: ColorTokens.graphite,
    height: 1.5,
  );

  // ── Labels & Captions ─────────────────────────────────────────────────────
  /// 15px · 500 · 1.5 — Labels, button text, interactive items
  static TextStyle labelLarge = GoogleFonts.sen(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: ColorTokens.ink,
    height: 1.5,
  );

  /// 13px · 400 · 1.5 — Captions, metadata, helper text
  static TextStyle caption = GoogleFonts.sen(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: ColorTokens.graphite,
    height: 1.5,
  );

  /// 12px · 400 · 1.5 — Micro labels, timestamps
  static TextStyle micro = GoogleFonts.sen(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: ColorTokens.ash,
    height: 1.5,
  );

  // ── Metric ────────────────────────────────────────────────────────────────
  /// 44px · 700 · 1.0 — Tabular figures for adherence metrics
  static TextStyle metricNumber = GoogleFonts.sen(
    fontSize: 44,
    fontWeight: FontWeight.w700,
    color: ColorTokens.ink,
    height: 1.0,
    letterSpacing: -1.0,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  /// 11px badge text
  static TextStyle badge = GoogleFonts.sen(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: ColorTokens.ink,
    letterSpacing: 0.2,
  );
}
