import 'package:flutter/material.dart';

/// 21n Design System — Refero Style 68d18deb-bb09-4258-8024-001af9c844c0
/// Flat, border-driven, near-monochrome light-mode workspace.
/// Zero shadows. Zero gradients. Structure from 1px Silver hairlines only.
class ColorTokens {
  ColorTokens._();

  // ── Neutral Canvas Stack ──────────────────────────────────────────────────
  /// #FFFFFF — Snow: Primary canvas — page backgrounds, card surfaces, button text
  static const Color snow = Color(0xFFFFFFFF);

  /// #F9F9FB — Fog: First surface layer above canvas — alternating sections, cards
  static const Color fog = Color(0xFFF9F9FB);

  /// #EFF0F6 — Mist: Cool inset panels, secondary cards, field fill
  static const Color mist = Color(0xFFEFF0F6);

  /// #E5E7EB — Silver: ALL hairline borders, dividers, 1px structural lines
  static const Color silver = Color(0xFFE5E7EB);

  // ── Text Stack ───────────────────────────────────────────────────────────
  /// #1A1A1A — Ink: Primary headings and high-contrast labels (slightly softer than pure black)
  static const Color ink = Color(0xFF1A1A1A);

  /// #333333 — Charcoal: Primary CTA filled button — the single dark anchor
  static const Color charcoal = Color(0xFF333333);

  /// #545454 — Graphite: Secondary text, metadata, subdued button labels
  static const Color graphite = Color(0xFF545454);

  /// #767676 — Smoke: Supporting neutral — dividers, muted labels
  static const Color smoke = Color(0xFF767676);

  /// #808080 — Ash: Disabled / inactive states, de-emphasized text and icons
  static const Color ash = Color(0xFF808080);

  // ── Functional Accent Colors ─────────────────────────────────────────────
  /// #24B26D — Emerald Pulse: Success / "Taken" state — icons and text ONLY, never fill
  static const Color emeraldPulse = Color(0xFF24B26D);
  static const Color emeraldPulseBg = Color(0xFFF0FDF7);
  static const Color emeraldPulseBorder = Color(0xFFBBF7D0);

  /// #2C70DD — Cobalt Signal: Links, active nav, AI scan badge, focused inputs — never CTA bg
  static const Color cobaltSignal = Color(0xFF2C70DD);
  static const Color cobaltSignalBg = Color(0xFFEFF4FF);
  static const Color cobaltSignalBorder = Color(0xFFBFD4FE);

  /// Error / destructive — kept functional, not promoted to branding
  static const Color error = Color(0xFFDC2626);
  static const Color errorBg = Color(0xFFFEF2F2);
  static const Color errorBorder = Color(0xFFFCA5A5);

  /// Warning — kept functional only
  static const Color warning = Color(0xFFD97706);
  static const Color warningBg = Color(0xFFFFFBEB);
  static const Color warningBorder = Color(0xFFFDE68A);

  // ── Semantic Aliases (used by existing code) ─────────────────────────────
  // Surface / canvas
  static const Color icePaper = fog;
  static const Color paper = fog;
  static const Color iceSlate = mist;
  static const Color backgroundCanvas = fog;
  static const Color cardSurface = snow;

  // Borders
  static const Color coolHairline = silver;
  static const Color hairline = silver;
  static const Color border = silver;

  // Text
  static const Color inkBlack = ink;
  static const Color midnightObsidian = ink;
  static const Color coolSlate = graphite;
  static const Color mutedMist = ash;
  static const Color ashGray = ash;

  // CTA / action
  static const Color electricCerulean = cobaltSignal;
  static const Color primaryAction = charcoal;
  static const Color obsidian = charcoal;

  // Status aliases (kept for StatusBadge compatibility)
  static const Color mintSuccess = emeraldPulse;
  static const Color mintSuccessBg = emeraldPulseBg;
  static const Color mintSuccessBorder = emeraldPulseBorder;
  static const Color crimsonAlert = error;
  static const Color crimsonAlertBg = errorBg;
  static const Color crimsonAlertBorder = errorBorder;
  static const Color warningAmber = warning;
  static const Color warningAmberBg = warningBg;
  static const Color warningAmberBorder = warningBorder;

  // Misc aliases
  static const Color vermillion = error;
  static const Color vermillionBg = errorBg;
  static const Color vermillionBorder = errorBorder;
  static const Color acidGreen = emeraldPulse;
  static const Color ceruleanBg = cobaltSignalBg;
  static const Color ceruleanBorder = cobaltSignalBorder;
  static const Color cyanLaser = cobaltSignal;
  static const Color cyanLaserGlow = Color(0x332C70DD);
  static const Color linkBlue = cobaltSignal;

  // Dark mode surfaces (legacy — 21n is light-mode only, kept to avoid compile errors)
  static const Color backgroundDark = Color(0xFF111111);
  static const Color surfaceDark = Color(0xFF1C1C1C);
  static const Color borderDark = Color(0xFF2E2E2E);
  static const Color textPrimaryDark = Color(0xFFF5F5F5);
  static const Color textSecondaryDark = Color(0xFF9E9E9E);
  static const Color textMutedDark = Color(0xFF6E6E6E);

  /// 21n: No shadows. This stub exists for zero-effort migration of old cardShadow refs.
  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x00000000),
    blurRadius: 0,
    offset: Offset(0, 0),
  );
}
