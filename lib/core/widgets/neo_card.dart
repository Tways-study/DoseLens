import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/color_tokens.dart';

/// 21n Design System Card
/// Snow (#FFF) surface, 1px Silver (#E5E7EB) hairline border, 12px radius.
/// Zero shadows — structure comes from borders only.
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
    Widget card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? ColorTokens.snow,
        borderRadius: BorderRadius.circular(borderRadius),
        border: showBorder
            ? Border.all(color: borderColor ?? ColorTokens.silver, width: 1.0)
            : null,
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
