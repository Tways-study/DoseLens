import 'package:flutter/material.dart';
import '../theme/color_tokens.dart';
import 'pill_chip.dart';

enum AdherenceStatus {
  taken,
  missed,
  pending,
  skipped,
}

/// Semantic status badge with Refero pastel palette & pill capsule shape
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
          icon: Icon(Icons.check_rounded, size: 14, color: ColorTokens.mintSuccess),
        );
      case AdherenceStatus.missed:
        return const PillChip(
          label: 'Missed',
          backgroundColor: ColorTokens.emberBg,
          textColor: ColorTokens.ember,
          borderColor: ColorTokens.emberBorder,
          icon: Icon(Icons.close_rounded, size: 14, color: ColorTokens.ember),
        );
      case AdherenceStatus.pending:
        return const PillChip(
          label: 'Pending',
          backgroundColor: ColorTokens.warningAmberBg,
          textColor: ColorTokens.warningAmber,
          borderColor: ColorTokens.warningAmberBorder,
          icon: Icon(Icons.schedule_rounded, size: 14, color: ColorTokens.warningAmber),
        );
      case AdherenceStatus.skipped:
        return const PillChip(
          label: 'Skipped',
          backgroundColor: ColorTokens.coolWash,
          textColor: ColorTokens.midGray,
          borderColor: ColorTokens.hairline,
          icon: Icon(Icons.remove_rounded, size: 14, color: ColorTokens.midGray),
        );
    }
  }
}
