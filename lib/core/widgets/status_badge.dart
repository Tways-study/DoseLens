import 'package:flutter/material.dart';
import '../../features/medications/models/adherence_log.dart';
import '../theme/color_tokens.dart';
import 'pill_chip.dart';

export '../../features/medications/models/adherence_log.dart' show AdherenceStatus;

/// 21n Semantic Status Badge
/// Taken  → Emerald Pulse icon/text, Emerald bg, Emerald border
/// Missed → Graphite icon/text, Mist bg, Silver border
/// Pending → Ash icon/text, Fog bg, Silver border
/// Skipped → Ash icon/text, Fog bg, Silver border
class StatusBadge extends StatelessWidget {
  final AdherenceStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case AdherenceStatus.taken:
        return const PillChip(
          label: 'Taken',
          backgroundColor: ColorTokens.emeraldPulseBg,
          textColor: ColorTokens.emeraldPulse,
          borderColor: ColorTokens.emeraldPulseBorder,
          icon: Icon(Icons.check_circle_rounded, size: 13, color: ColorTokens.emeraldPulse),
        );
      case AdherenceStatus.missed:
        return const PillChip(
          label: 'Missed',
          backgroundColor: ColorTokens.mist,
          textColor: ColorTokens.graphite,
          borderColor: ColorTokens.silver,
          icon: Icon(Icons.cancel_outlined, size: 13, color: ColorTokens.graphite),
        );
      case AdherenceStatus.pending:
        return const PillChip(
          label: 'Pending',
          backgroundColor: ColorTokens.fog,
          textColor: ColorTokens.ash,
          borderColor: ColorTokens.silver,
          icon: Icon(Icons.schedule_rounded, size: 13, color: ColorTokens.ash),
        );
      case AdherenceStatus.skipped:
        return const PillChip(
          label: 'Skipped',
          backgroundColor: ColorTokens.fog,
          textColor: ColorTokens.ash,
          borderColor: ColorTokens.silver,
          icon: Icon(Icons.remove_rounded, size: 13, color: ColorTokens.ash),
        );
    }
  }
}
