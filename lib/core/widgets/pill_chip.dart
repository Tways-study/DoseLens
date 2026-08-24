import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/color_tokens.dart';

/// Pill-shaped badge / chip with capsule radius (999px) per Refero Design
class PillChip extends StatelessWidget {
  final String label;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  const PillChip({
    super.key,
    required this.label,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppConstants.space12,
      vertical: 6.0,
    ),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg = isDark
        ? ColorTokens.backgroundSecondaryDark
        : ColorTokens.coolWash;
    final defaultText =
        isDark ? ColorTokens.textPrimaryDark : ColorTokens.primaryInk;

    Widget chip = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBg,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 0.8)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: AppConstants.space4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor ?? defaultText,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: chip,
      );
    }

    return chip;
  }
}
