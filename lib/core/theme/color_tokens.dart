import 'package:flutter/material.dart';

/// Semantic color tokens strictly following the Craftwork Design Architecture
/// (Refero Style Reference: https://styles.refero.design/style/47c9e353-bed3-4d6c-8316-63a2db5cc377)
class ColorTokens {
  ColorTokens._();

  // ── Brand & Signature Accents ──────────────────────────────────────────
  /// #CAFC00 — Acid Green: The singular chromatic highlight for primary CTAs, Pro pills, and active states
  static const Color acidGreen = Color(0xFFCAFC00);

  /// #F54911 — Vermillion: Warm red-orange for missed alerts, warnings, and small brand moments
  static const Color vermillion = Color(0xFFF54911);
  static const Color vermillionBg = Color(0xFFFEF1EC);
  static const Color vermillionBorder = Color(0xFFFFD4C4);

  /// #C42DF9 — Magenta Pop: Vivid pink for icons, decorative strokes, and tertiary tags
  static const Color magentaPop = Color(0xFFC42DF9);
  static const Color magentaBg = Color(0xFFFAF0FE);

  // ── Neutrals & Grayscale ───────────────────────────────────────────────
  /// #000000 — Ink Black: Primary text, heading strokes, and high-contrast UI
  static const Color inkBlack = Color(0xFF000000);

  /// #0D0D0D — Obsidian: Dark surface fill for active states, dark pill buttons, and inverted sections
  static const Color obsidian = Color(0xFF0D0D0D);

  /// #1E1E1E — Charcoal: Secondary dark surface
  static const Color charcoal = Color(0xFF1E1E1E);

  /// #14151A — Slate Ink: Near-black for UI borders and crisp text
  static const Color slateInk = Color(0xFF14151A);

  /// #606060 — Graphite: Secondary text, muted icons, and body copy
  static const Color graphite = Color(0xFF606060);

  /// #999999 — Ash Gray: Tertiary text, placeholder copy, disabled states
  static const Color ashGray = Color(0xFF999999);

  /// #9EA0A8 — Mist: Cool-leaning gray for helper text and subtle borders
  static const Color mist = Color(0xFF9EA0A8);

  // ── Surfaces & Canvas ──────────────────────────────────────────────────
  /// #F9F9F9 — Paper: Page canvas background across the entire app
  static const Color paper = Color(0xFFF9F9F9);

  /// #F2F2F2 — Fog: Secondary surface for inset panels, section dividers, soft washes
  static const Color fog = Color(0xFFF2F2F2);

  /// #FFFFFF — Snow: Pure white card surfaces, button text on dark fills
  static const Color snow = Color(0xFFFFFFFF);

  /// #DEE0E3 — Hairline: Structural borders, dividers, input outlines
  static const Color hairline = Color(0xFFDEE0E3);

  // ── Semantic Aliases ───────────────────────────────────────────────────
  static const Color backgroundLight = paper;
  static const Color backgroundSecondaryLight = fog;
  static const Color surfaceLight = snow;
  static const Color borderLight = hairline;

  static const Color backgroundDark = obsidian;
  static const Color backgroundSecondaryDark = charcoal;
  static const Color surfaceDark = charcoal;
  static const Color borderDark = Color(0xFF2E2E2E);

  static const Color textPrimaryLight = inkBlack;
  static const Color textSecondaryLight = graphite;
  static const Color textMutedLight = ashGray;

  static const Color textPrimaryDark = snow;
  static const Color textSecondaryDark = mist;
  static const Color textMutedDark = ashGray;

  // Active CTA accents
  static const Color primaryAction = acidGreen;
  static const Color primaryTeal = acidGreen; // Alias for riverpod/services
  static const Color primarySlate = obsidian;
  static const Color electricBlue = acidGreen;
  static const Color linkBlue = Color(0xFF0055D4);

  // Status & Adherence Mappings
  static const Color mintSuccess = Color(0xFF15803D);
  static const Color mintSuccessBg = Color(0xFFF0FDF4);
  static const Color mintSuccessBorder = Color(0xFFDCFCE7);

  static const Color alertCoral = vermillion;
  static const Color alertCoralBg = vermillionBg;
  static const Color alertCoralBorder = vermillionBorder;

  static const Color warningAmber = Color(0xFFD97706);
  static const Color warningAmberBg = Color(0xFFFFFBEB);
  static const Color warningAmberBorder = Color(0xFFFEF3C7);

  // Subtle Craftwork Paper Shadow
  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x082F2B43),
    blurRadius: 4,
    offset: Offset(0, 1),
  );
}
