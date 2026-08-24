import 'package:flutter/material.dart';

/// Semantic color tokens following the Refero-Inspired Neo-Utility design system
class ColorTokens {
  ColorTokens._();

  // Canvas / Background
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundSecondaryLight = Color(0xFFF4F5F7);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color backgroundSecondaryDark = Color(0xFF1E293B);

  // Surface / Cards
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF334155);

  // Text Hierarchy
  static const Color textPrimaryLight = Color(0xFF111827); // Obsidian Slate
  static const Color textSecondaryLight = Color(0xFF6B7280); // Muted Cool Gray
  static const Color textMutedLight = Color(0xFF9CA3AF); // Soft Graphite

  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textMutedDark = Color(0xFF64748B);

  // Accents & Actions
  static const Color primaryTeal = Color(0xFF0D9488);
  static const Color primarySlate = Color(0xFF0F172A);

  // Adherence / Success (Fresh Clinical Mint)
  static const Color mintSuccess = Color(0xFF10B981);
  static const Color mintSuccessBg = Color(0xFFECFDF5);
  static const Color mintSuccessBorder = Color(0xFFA7F3D0);

  // Missed / Urgent Alert (Coral Rose)
  static const Color alertCoral = Color(0xFFF43F5E);
  static const Color alertCoralBg = Color(0xFFFFF1F2);
  static const Color alertCoralBorder = Color(0xFFFECDD3);

  // Warning / Pending (Amber Gold)
  static const Color warningAmber = Color(0xFFF59E0B);
  static const Color warningAmberBg = Color(0xFFFEF3C7);
  static const Color warningAmberBorder = Color(0xFFFDE68A);

  // Subtle Shadow
  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 12,
    offset: Offset(0, 4),
  );
}
