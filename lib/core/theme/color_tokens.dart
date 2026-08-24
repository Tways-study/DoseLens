import 'package:flutter/material.dart';

/// Semantic color tokens strictly following the Refero Design Architecture
/// (Apple España Style Reference: https://styles.refero.design/style/c9cabb96-32fa-4896-837a-f2497ce1c856)
class ColorTokens {
  ColorTokens._();

  // ── Neutrals & Canvas Surfaces ──────────────────────────────────────────
  /// #1D1D1F — The dominant foreground tone for headlines, body text, button labels
  static const Color primaryInk = Color(0xFF1D1D1F);

  /// #474747 — Navigation text and iconography at medium emphasis
  static const Color deepGray = Color(0xFF474747);

  /// #707070 — Secondary text, nav inactive state, muted UI labels
  static const Color midGray = Color(0xFF707070);

  /// #777779 — Pagination indicator fills, tertiary quiet state
  static const Color quietDot = Color(0xFF777779);

  /// #D6D6D6 — Hairline borders between sections and UI elements
  static const Color hairline = Color(0xFFD6D6D6);

  /// #E8E8ED — Subtle button backgrounds, hovered surfaces, cool washes
  static const Color coolWash = Color(0xFFE8E8ED);

  /// #F5F5F7 — Alternating section backgrounds & canvas gray
  static const Color canvas = Color(0xFFF5F5F7);

  /// #FAFAFC — Global nav opened state, elevated panel surfaces
  static const Color fadedSurface = Color(0xFFFAFAFC);

  /// #FFFFFF — Card surfaces, primary page background, button text on dark fills
  static const Color paper = Color(0xFFFFFFFF);

  // ── Brand & Interactive Accents ────────────────────────────────────────
  /// #0071E3 — Filled action buttons; the signature chromatic accent for CTAs
  static const Color electricBlue = Color(0xFF0071E3);

  /// #0066CC — Inline body text links, arrow-link chevron text
  static const Color linkBlue = Color(0xFF0066CC);

  /// #B64400 — Warm ember accent for badges, missed alerts, and short status labels
  static const Color ember = Color(0xFFB64400);
  static const Color emberBg = Color(0xFFFFF3EC);
  static const Color emberBorder = Color(0xFFFFD8C4);

  // ── Pastel Product & Finish Swatches (for Medications & Chips) ─────────
  /// #C8D8E0 — Pastel blue swatch
  static const Color swatchSky = Color(0xFFC8D8E0);

  /// #DDDC8C — Pastel yellow-green swatch (Success / Taken)
  static const Color swatchCitrus = Color(0xFFDDDC8C);
  static const Color citrusBg = Color(0xFFF8F8E6);
  static const Color citrusDark = Color(0xFF5A6600);

  /// #F0E4D3 — Warm cream swatch
  static const Color swatchStarlight = Color(0xFFF0E4D3);

  /// #E3E4E5 — Cool gray swatch
  static const Color swatchSilver = Color(0xFFE3E4E5);

  /// #E8D0D0 — Soft pink swatch
  static const Color swatchBlush = Color(0xFFE8D0D0);
  static const Color blushBg = Color(0xFFFDF4F4);

  /// #596680 — Muted indigo swatch
  static const Color swatchIndigo = Color(0xFF596680);

  /// #2E3642 — Deep charcoal swatch
  static const Color swatchMidnight = Color(0xFF2E3642);

  // ── Semantic Aliases for App Consistency ───────────────────────────────
  static const Color backgroundLight = canvas;
  static const Color backgroundSecondaryLight = paper;
  static const Color surfaceLight = paper;
  static const Color borderLight = hairline;

  static const Color backgroundDark = Color(0xFF141416);
  static const Color backgroundSecondaryDark = Color(0xFF1D1D1F);
  static const Color surfaceDark = Color(0xFF1D1D1F);
  static const Color borderDark = Color(0xFF38383A);

  static const Color textPrimaryLight = primaryInk;
  static const Color textSecondaryLight = midGray;
  static const Color textMutedLight = quietDot;

  static const Color textPrimaryDark = Color(0xFFF5F5F7);
  static const Color textSecondaryDark = Color(0xFFA1A1A6);
  static const Color textMutedDark = Color(0xFF6E6E73);

  static const Color primaryTeal = electricBlue; // Alias for backward compatibility
  static const Color primarySlate = primaryInk;

  // Adherence Status mappings to Refero pastels
  static const Color mintSuccess = Color(0xFF2E7D32);
  static const Color mintSuccessBg = Color(0xFFF0FDF4);
  static const Color mintSuccessBorder = Color(0xFFDCFCE7);

  static const Color alertCoral = ember;
  static const Color alertCoralBg = emberBg;
  static const Color alertCoralBorder = emberBorder;

  static const Color warningAmber = Color(0xFFD97706);
  static const Color warningAmberBg = Color(0xFFFFFBEB);
  static const Color warningAmberBorder = Color(0xFFFEF3C7);

  // Refero Design specifies ZERO heavy drop shadows — pure flat or ultra-diffuse ambient
  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x05000000),
    blurRadius: 10,
    offset: Offset(0, 2),
  );
}
