import 'package:flutter/material.dart';
import '../../features/medications/models/adherence_log.dart';
import '../theme/color_tokens.dart';
import 'pill_chip.dart';

export '../../features/medications/models/adherence_log.dart' show AdherenceStatus;

/// Semantic status badge with Precision Digital Rx Mint & Crimson palette
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
          icon: Icon(Icons.check_circle_rounded, size: 13, color: ColorTokens.mintSuccess),
        );
      case AdherenceStatus.missed:
        return const PillChip(
          label: 'Missed',
          backgroundColor: ColorTokens.crimsonAlertBg,
          textColor: ColorTokens.crimsonAlert,
          borderColor: ColorTokens.crimsonAlertBorder,
          icon: Icon(Icons.cancel_rounded, size: 13, color: ColorTokens.crimsonAlert),
        );
      case AdherenceStatus.pending:
        return const PillChip(
          label: 'Pending',
          backgroundColor: ColorTokens.warningAmberBg,
          textColor: ColorTokens.warningAmber,
          borderColor: ColorTokens.warningAmberBorder,
          icon: Icon(Icons.schedule_rounded, size: 13, color: ColorTokens.warningAmber),
        );
      case AdherenceStatus.skipped:
        return const PillChip(
          label: 'Skipped',
          backgroundColor: ColorTokens.iceSlate,
          textColor: ColorTokens.coolSlate,
          borderColor: ColorTokens.coolHairline,
          icon: Icon(Icons.remove_rounded, size: 13, color: ColorTokens.coolSlate),
        );
    }
  }
}
