import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/color_tokens.dart';

/// Craftwork Styled Card: 14px corner radius, crisp #DEE0E3 hairline border, subtle paper shadow
class NeoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final bool showBorder;

  const NeoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppConstants.space20),
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = AppConstants.radiusCard,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg = isDark ? ColorTokens.surfaceDark : ColorTokens.snow;
    final defaultBorder = isDark ? ColorTokens.borderDark : ColorTokens.hairline;

    Widget card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: showBorder
            ? Border.all(
                color: borderColor ?? defaultBorder,
                width: 1.0,
              )
            : null,
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
