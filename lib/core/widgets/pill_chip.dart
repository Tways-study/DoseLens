import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/color_tokens.dart';

/// Pill-shaped badge / chip with capsule radius (9999px) per Craftwork Design
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
      vertical: 5.0,
    ),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg = isDark ? ColorTokens.charcoal : ColorTokens.fog;
    final defaultText = isDark ? ColorTokens.textPrimaryDark : ColorTokens.inkBlack;

    Widget chip = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBg,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        border: Border.all(
          color: borderColor ?? ColorTokens.hairline,
          width: 1.0,
        ),
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
              fontWeight: FontWeight.w700,
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
