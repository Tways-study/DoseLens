import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/color_tokens.dart';

/// Precision Digital Rx Action Button: Electric Cerulean (#0284C7) with white text, or Obsidian (#0F172A) fill
class PrimaryActionButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double height;
  final bool isGhost;
  final bool isObsidian;
  final bool isPill;

  const PrimaryActionButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.height = 48,
    this.isGhost = false,
    this.isObsidian = false,
    this.isPill = false,
  });

  @override
  Widget build(BuildContext context) {
    final radius = isPill ? AppConstants.radiusFull : AppConstants.radiusButton;

    if (isGhost) {
      return SizedBox(
        height: height,
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: ColorTokens.coolHairline, width: 1.0),
            backgroundColor: ColorTokens.snow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.space20),
          ),
          onPressed: isLoading ? null : onPressed,
          child: _buildContent(ColorTokens.midnightObsidian),
        ),
      );
    }

    final bg = backgroundColor ?? (isObsidian ? ColorTokens.midnightObsidian : ColorTokens.electricCerulean);
    final fg = textColor ?? Colors.white;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.space20),
        ),
        onPressed: isLoading ? null : onPressed,
        child: _buildContent(fg),
      ),
    );
  }

  Widget _buildContent(Color contentColor) {
    if (isLoading) {
      return SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2.2,
          valueColor: AlwaysStoppedAnimation<Color>(contentColor),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          icon!,
          const SizedBox(width: AppConstants.space8),
        ],
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: contentColor,
            letterSpacing: -0.1,
          ),
        ),
      ],
    );
  }
}
