import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/color_tokens.dart';

/// Primary Action Button (Filled Pill Button) strictly following the Refero Design Architecture
/// Pill shape (980px radius), Electric Blue (#0071E3) fill, white text, 0 elevation.
class PrimaryActionButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double height;
  final bool isGhost;

  const PrimaryActionButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.height = 50,
    this.isGhost = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isGhost) {
      return SizedBox(
        height: height,
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: ColorTokens.hairline, width: 1.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusPill),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.space24),
          ),
          onPressed: isLoading ? null : onPressed,
          child: _buildContent(ColorTokens.primaryInk),
        ),
      );
    }

    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? ColorTokens.electricBlue,
          foregroundColor: textColor ?? Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusPill),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.space24),
        ),
        onPressed: isLoading ? null : onPressed,
        child: _buildContent(textColor ?? Colors.white),
      ),
    );
  }

  Widget _buildContent(Color contentColor) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
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
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: contentColor,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}
