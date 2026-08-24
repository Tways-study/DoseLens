import 'package:flutter/material.dart';
import '../../features/medications/models/adherence_log.dart';
import '../theme/color_tokens.dart';
import 'pill_chip.dart';

export '../../features/medications/models/adherence_log.dart' show AdherenceStatus;

/// Semantic status badge with Craftwork Acid Green, Vermillion & Fog palette
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
          backgroundColor: ColorTokens.acidGreen,
          textColor: ColorTokens.inkBlack,
          borderColor: ColorTokens.acidGreen,
          icon: Icon(Icons.check_rounded, size: 13, color: ColorTokens.inkBlack),
        );
      case AdherenceStatus.missed:
        return const PillChip(
          label: 'Missed',
          backgroundColor: ColorTokens.vermillionBg,
          textColor: ColorTokens.vermillion,
          borderColor: ColorTokens.vermillionBorder,
          icon: Icon(Icons.close_rounded, size: 13, color: ColorTokens.vermillion),
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
          backgroundColor: ColorTokens.fog,
          textColor: ColorTokens.graphite,
          borderColor: ColorTokens.hairline,
          icon: Icon(Icons.remove_rounded, size: 13, color: ColorTokens.graphite),
        );
    }
  }
}
