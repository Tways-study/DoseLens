import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/neo_card.dart';
import '../../../core/widgets/pill_chip.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/status_badge.dart' as sb;
import '../models/adherence_log.dart';
import '../models/medication.dart';
import '../providers/medications_provider.dart';
import 'add_medication_screen.dart';
import 'medication_detail_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medsAsync = ref.watch(medicationsStreamProvider);
    final logsAsync = ref.watch(todayLogsProvider);
    final rateAsync = ref.watch(adherenceRateProvider);

    return Scaffold(
      backgroundColor: ColorTokens.canvas,
      appBar: AppBar(
        backgroundColor: ColorTokens.canvas,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text(
          'Today.',
          style: TextStyles.displayMedium.copyWith(
            color: ColorTokens.primaryInk,
            fontWeight: FontWeight.w700,
            fontSize: 28,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: ColorTokens.electricBlue, size: 26),
            tooltip: 'Add Medication',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddMedicationScreen()),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: RefreshIndicator(
        color: ColorTokens.electricBlue,
        onRefresh: () async => ref.invalidate(medicationsStreamProvider),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(AppConstants.space20, AppConstants.space8, AppConstants.space20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting & Date Subtitle
              Text(
                _todayLabel(),
                style: TextStyles.bodySecondary.copyWith(fontSize: 14),
              ),
              const SizedBox(height: AppConstants.space20),

              // Adherence Metric Card
              rateAsync.when(
                loading: () => const _AdherenceCardSkeleton(),
                error: (_, __) => const SizedBox.shrink(),
                data: (rate) => _AdherenceCard(rate: rate),
              ),
              const SizedBox(height: AppConstants.space28),

              // Today's Doses Section Header
              SectionHeader(
                title: 'Schedule',
                subtitle: 'Swipe right to record taken, left to skip',
                trailing: PillChip(
                  label: _todayDoseLabel(logsAsync.valueOrNull ?? []),
                  backgroundColor: ColorTokens.coolWash,
                  textColor: ColorTokens.primaryInk,
                ),
              ),
              const SizedBox(height: AppConstants.space8),

              medsAsync.when(
                loading: () => Column(children: List.generate(3, (_) => const _MedCardSkeleton())),
                error: (e, _) => _ErrorCard(message: e.toString()),
                data: (meds) {
                  if (meds.isEmpty) return const _EmptyMedicationsCard();
                  return _TimelinedDoseList(
                    medications: meds,
                    logs: logsAsync.valueOrNull ?? [],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _todayLabel() {
    final now = DateTime.now();
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return '${days[now.weekday - 1]}, ${DateFormatters.formatDate(now)}';
  }

  String _todayDoseLabel(List<AdherenceLog> logs) {
    if (logs.isEmpty) return '0 logged';
    final taken = logs.where((l) => l.status == AdherenceStatus.taken).length;
    return '$taken of ${logs.length} taken';
  }
}

class _AdherenceCard extends StatelessWidget {
  final double rate;
  const _AdherenceCard({required this.rate});

  @override
  Widget build(BuildContext context) {
    final pct = (rate * 100).round();
    final isGood = pct >= 80;
    return NeoCard(
      borderRadius: AppConstants.radiusCard,
      padding: const EdgeInsets.all(AppConstants.space24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '30-Day Adherence',
                  style: TextStyles.caption.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$pct%',
                      style: TextStyles.metricNumber,
                    ),
                    const SizedBox(width: AppConstants.space12),
                    PillChip(
                      label: isGood ? 'Optimal' : 'Attention',
                      backgroundColor: isGood ? ColorTokens.mintSuccessBg : ColorTokens.emberBg,
                      textColor: isGood ? ColorTokens.mintSuccess : ColorTokens.ember,
                      borderColor: isGood ? ColorTokens.mintSuccessBorder : ColorTokens.emberBorder,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  isGood
                      ? 'Consistent schedule maintained over past 30 days.'
                      : 'Recommended to take doses according to prescribed times.',
                  style: TextStyles.bodySecondary.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppConstants.space16),
          _AdherenceDonut(rate: rate),
        ],
      ),
    );
  }
}

class _AdherenceDonut extends StatelessWidget {
  final double rate;
  const _AdherenceDonut({required this.rate});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      height: 68,
      child: CustomPaint(
        painter: _DonutPainter(rate: rate),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final double rate;
  _DonutPainter({required this.rate});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const strokeWidth = 7.0;

    // Background track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = ColorTokens.coolWash,
    );

    // Progress arc
    final sweepAngle = rate.clamp(0.0, 1.0) * 2 * 3.141592653589793;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592653589793 / 2,
      sweepAngle,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = rate >= 0.8 ? ColorTokens.electricBlue : ColorTokens.ember,
    );
  }

  @override
  bool shouldRepaint(_DonutPainter old) => old.rate != rate;
}

class _TimelinedDoseList extends ConsumerWidget {
  final List<Medication> medications;
  final List<AdherenceLog> logs;

  const _TimelinedDoseList({required this.medications, required this.logs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grouped = _groupByTimeOfDay(medications);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in grouped.entries) ...[
          if (entry.value.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(top: AppConstants.space16, bottom: AppConstants.space8),
              child: Row(
                children: [
                  Icon(_timeIcon(entry.key), size: 14, color: ColorTokens.midGray),
                  const SizedBox(width: 6),
                  Text(
                    entry.key.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: ColorTokens.midGray,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
            ...entry.value.map((med) => Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.space12),
              child: _DoseCard(
                medication: med,
                todayLogs: logs.where((l) => l.medicationId == med.id).toList(),
              ),
            )),
          ],
        ],
      ],
    );
  }

  Map<String, List<Medication>> _groupByTimeOfDay(List<Medication> meds) {
    final map = <String, List<Medication>>{
      'Morning': [],
      'Afternoon': [],
      'Evening': [],
      'Night': [],
    };
    for (final med in meds) {
      if (med.times.isEmpty) {
        map['Morning']!.add(med);
        continue;
      }
      final firstTime = med.times.first;
      final hour = int.tryParse(firstTime.split(':').first) ?? 8;
      if (hour < 12) {
        map['Morning']!.add(med);
      } else if (hour < 17) {
        map['Afternoon']!.add(med);
      } else if (hour < 21) {
        map['Evening']!.add(med);
      } else {
        map['Night']!.add(med);
      }
    }
    return map;
  }

  IconData _timeIcon(String slot) {
    switch (slot) {
      case 'Morning': return Icons.wb_sunny_outlined;
      case 'Afternoon': return Icons.wb_twilight_rounded;
      case 'Evening': return Icons.nights_stay_outlined;
      default: return Icons.bedtime_outlined;
    }
  }
}

class _DoseCard extends ConsumerWidget {
  final Medication medication;
  final List<AdherenceLog> todayLogs;

  const _DoseCard({required this.medication, required this.todayLogs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTaken = todayLogs.any((l) => l.status == AdherenceStatus.taken);
    final isSkipped = todayLogs.any((l) => l.status == AdherenceStatus.skipped);

    return Dismissible(
      key: Key(medication.id),
      direction: DismissDirection.horizontal,
      confirmDismiss: (dir) async {
        if (dir == DismissDirection.startToEnd) {
          await ref.read(medicationsNotifierProvider.notifier).logAdherence(
            medicationId: medication.id,
            medicationName: medication.name,
            status: AdherenceStatus.taken,
          );
        } else {
          await ref.read(medicationsNotifierProvider.notifier).logAdherence(
            medicationId: medication.id,
            medicationName: medication.name,
            status: AdherenceStatus.skipped,
          );
        }
        return false;
      },
      background: Container(
        decoration: BoxDecoration(
          color: ColorTokens.mintSuccessBg,
          borderRadius: BorderRadius.circular(AppConstants.radiusCard),
          border: Border.all(color: ColorTokens.mintSuccessBorder, width: 0.8),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 24),
        child: const Icon(Icons.check_rounded, color: ColorTokens.mintSuccess, size: 24),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          color: ColorTokens.coolWash,
          borderRadius: BorderRadius.circular(AppConstants.radiusCard),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.close_rounded, color: ColorTokens.midGray, size: 24),
      ),
      child: NeoCard(
        borderRadius: AppConstants.radiusCard,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MedicationDetailScreen(medication: medication)),
        ),
        child: Row(
          children: [
            // Pill Icon container with Refero Pastel Sky / Citrus swatch
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isTaken
                    ? ColorTokens.mintSuccessBg
                    : (isSkipped ? ColorTokens.coolWash : const Color(0xFFF0F7FF)),
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: Icon(
                Icons.medication_rounded,
                color: isTaken
                    ? ColorTokens.mintSuccess
                    : (isSkipped ? ColorTokens.midGray : ColorTokens.electricBlue),
                size: 22,
              ),
            ),
            const SizedBox(width: AppConstants.space16),

            // Drug Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medication.name,
                    style: TextStyles.headingMedium.copyWith(
                      decoration: isSkipped ? TextDecoration.lineThrough : null,
                      color: isSkipped ? ColorTokens.midGray : ColorTokens.primaryInk,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${medication.dosage} · ${medication.frequencyLabel}',
                    style: TextStyles.caption,
                  ),
                ],
              ),
            ),

            // Status chip
            if (isTaken)
              const sb.StatusBadge(status: sb.AdherenceStatus.taken)
            else if (isSkipped)
              const sb.StatusBadge(status: sb.AdherenceStatus.skipped)
            else
              PillChip(
                label: medication.times.isNotEmpty ? medication.times.first : 'Pending',
                backgroundColor: ColorTokens.coolWash,
                textColor: ColorTokens.primaryInk,
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyMedicationsCard extends StatelessWidget {
  const _EmptyMedicationsCard();

  @override
  Widget build(BuildContext context) {
    return NeoCard(
      borderRadius: AppConstants.radiusCard,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: ColorTokens.coolWash,
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: const Icon(Icons.document_scanner_rounded, size: 26, color: ColorTokens.midGray),
            ),
            const SizedBox(height: AppConstants.space16),
            Text(
              'No medications added yet.',
              style: TextStyles.headingMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Scan your prescription bottle or add one manually.',
              style: TextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return NeoCard(
      borderRadius: AppConstants.radiusCard,
      backgroundColor: ColorTokens.emberBg,
      borderColor: ColorTokens.emberBorder,
      child: Text(
        message,
        style: const TextStyle(color: ColorTokens.ember, fontSize: 13),
      ),
    );
  }
}

class _AdherenceCardSkeleton extends StatelessWidget {
  const _AdherenceCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return NeoCard(
      borderRadius: AppConstants.radiusCard,
      child: Container(
        height: 80,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(strokeWidth: 2, color: ColorTokens.electricBlue),
      ),
    );
  }
}

class _MedCardSkeleton extends StatelessWidget {
  const _MedCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.space12),
      child: NeoCard(
        borderRadius: AppConstants.radiusCard,
        child: Container(height: 50),
      ),
    );
  }
}
