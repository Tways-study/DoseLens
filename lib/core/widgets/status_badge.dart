import 'package:flutter/material.dart';
import '../theme/color_tokens.dart';
import 'pill_chip.dart';

enum AdherenceStatus {
  taken,
  missed,
  pending,
  skipped,
}

/// Semantic status badge for Taken, Missed, Pending, and Skipped doses
class StatusBadge extends StatelessWidget {
  final AdherenceStatus status;

  const StatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case AdherenceStatus.taken:
        return const PillChip(
          label: 'Taken',
          backgroundColor: ColorTokens.mintSuccessBg,
          textColor: ColorTokens.mintSuccess,
          borderColor: ColorTokens.mintSuccessBorder,
          icon: Icon(Icons.check_circle, size: 14, color: ColorTokens.mintSuccess),
        );
      case AdherenceStatus.missed:
        return const PillChip(
          label: 'Missed',
          backgroundColor: ColorTokens.alertCoralBg,
          textColor: ColorTokens.alertCoral,
          borderColor: ColorTokens.alertCoralBorder,
          icon: Icon(Icons.cancel, size: 14, color: ColorTokens.alertCoral),
        );
      case AdherenceStatus.pending:
        return const PillChip(
          label: 'Pending',
          backgroundColor: ColorTokens.warningAmberBg,
          textColor: ColorTokens.warningAmber,
          borderColor: ColorTokens.warningAmberBorder,
          icon: Icon(Icons.schedule, size: 14, color: ColorTokens.warningAmber),
        );
      case AdherenceStatus.skipped:
        return const PillChip(
          label: 'Skipped',
          backgroundColor: Color(0xFFF3F4F6),
          textColor: ColorTokens.textSecondaryLight,
          borderColor: ColorTokens.borderLight,
          icon: Icon(Icons.remove_circle_outline,
              size: 14, color: ColorTokens.textSecondaryLight),
        );
    }
  }
}
