import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/color_tokens.dart';

/// Neo-Utility styled card with 1px border stroke and subtle elevation
class NeoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;

  const NeoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppConstants.space16),
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = AppConstants.radiusCard,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg =
        isDark ? ColorTokens.surfaceDark : ColorTokens.surfaceLight;
    final defaultBorder =
        isDark ? ColorTokens.borderDark : ColorTokens.borderLight;

    Widget card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? defaultBorder,
          width: 1.0,
        ),
        boxShadow: const [ColorTokens.cardShadow],
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: card,
        ),
      );
    }

    return card;
  }
}
