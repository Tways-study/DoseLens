import 'package:flutter/material.dart';

/// Semantic color tokens strictly following Palette 2: "Precision Digital Rx"
/// (Electric Cerulean, Cyan Laser, Midnight Obsidian, Ice Slate Canvas)
class ColorTokens {
  ColorTokens._();

  // ── Precision Digital Rx Accents ───────────────────────────────────────
  /// #0284C7 — Electric Cerulean: The signature digital pharmacy CTA & active state
  static const Color electricCerulean = Color(0xFF0284C7);
  static const Color ceruleanDark = Color(0xFF0369A1);
  static const Color ceruleanBg = Color(0xFFEFF6FF);
  static const Color ceruleanBorder = Color(0xFFBFDBFE);

  /// #00D8F6 — Cyan Laser: Optic vision highlights, reticle brackets & scan telemetry
  static const Color cyanLaser = Color(0xFF00D8F6);
  static const Color cyanLaserGlow = Color(0x3300D8F6);

  /// #EF4444 — Crimson Alert: Missed dose alerts and warnings
  static const Color crimsonAlert = Color(0xFFEF4444);
  static const Color crimsonAlertBg = Color(0xFFFEF2F2);
  static const Color crimsonAlertBorder = Color(0xFFFCA5A5);

  /// #10B981 — Clinical Mint Success: Taken status and optimal adherence
  static const Color mintSuccess = Color(0xFF10B981);
  static const Color mintSuccessBg = Color(0xFFECFDF5);
  static const Color mintSuccessBorder = Color(0xFFA7F3D0);

  /// #F59E0B — Amber Gold: Pending and warning statuses
  static const Color warningAmber = Color(0xFFF59E0B);
  static const Color warningAmberBg = Color(0xFFFFFBEB);
  static const Color warningAmberBorder = Color(0xFFFDE68A);

  // ── Neutrals & Grayscale ───────────────────────────────────────────────
  /// #0B132B — Midnight Obsidian: Primary headlines, high-contrast labels
  static const Color midnightObsidian = Color(0xFF0B132B);
  static const Color slateInk = Color(0xFF0F172A);
  static const Color inkBlack = midnightObsidian;
  static const Color obsidian = Color(0xFF0F172A);

  /// #64748B — Cool Slate: Secondary text, body copy, muted icons
  static const Color coolSlate = Color(0xFF64748B);
  static const Color graphite = coolSlate;

  /// #94A3B8 — Muted Mist: Tertiary text, placeholders, inactive states
  static const Color mutedMist = Color(0xFF94A3B8);
  static const Color ashGray = mutedMist;

  // ── Surfaces & Canvas ──────────────────────────────────────────────────
  /// #F8FAFC — Ice Paper: Page canvas background
  static const Color icePaper = Color(0xFFF8FAFC);
  static const Color paper = icePaper;

  /// #F1F5F9 — Ice Slate / Fog: Secondary surface, segmented controls, table headers
  static const Color iceSlate = Color(0xFFF1F5F9);
  static const Color fog = iceSlate;

  /// #FFFFFF — Snow: Pure white card surfaces
  static const Color snow = Color(0xFFFFFFFF);

  /// #E2E8F0 — Cool Hairline: Structural borders and dividers
  static const Color coolHairline = Color(0xFFE2E8F0);
  static const Color hairline = coolHairline;

  // ── Semantic Aliases & Compatibility ───────────────────────────────────
  static const Color backgroundLight = icePaper;
  static const Color surfaceLight = snow;
  static const Color borderLight = coolHairline;

  static const Color backgroundDark = Color(0xFF0B132B);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color borderDark = Color(0xFF334155);

  static const Color textPrimaryLight = midnightObsidian;
  static const Color textSecondaryLight = coolSlate;
  static const Color textMutedLight = mutedMist;

  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textMutedDark = Color(0xFF64748B);

  // Active CTA aliases
  static const Color primaryAction = electricCerulean;
  static const Color primaryTeal = electricCerulean;
  static const Color primarySlate = midnightObsidian;
  static const Color acidGreen = electricCerulean;
  static const Color electricBlue = electricCerulean;
  static const Color linkBlue = electricCerulean;
  static const Color vermillion = crimsonAlert;
  static const Color vermillionBg = crimsonAlertBg;
  static const Color vermillionBorder = crimsonAlertBorder;
  static const Color alertCoral = crimsonAlert;
  static const Color alertCoralBg = crimsonAlertBg;
  static const Color alertCoralBorder = crimsonAlertBorder;

  // Subtle Clinical Paper Shadow
  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x060F172A),
    blurRadius: 6,
    offset: Offset(0, 2),
  );
}
