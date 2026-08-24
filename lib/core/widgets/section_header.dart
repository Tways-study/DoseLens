import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/text_styles.dart';

/// Section Header with title, optional subtitle, and optional trailing action
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.space8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyles.headingMedium,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppConstants.space4),
                Text(
                  subtitle!,
                  style: TextStyles.caption,
                ),
              ],
            ],
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
