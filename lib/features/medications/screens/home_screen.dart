import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/neo_card.dart';
import '../../../core/widgets/pill_chip.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/status_badge.dart' as sb;
import '../models/adherence_log.dart';
import '../models/medication.dart';
import '../providers/medications_provider.dart';
import '../../auth/providers/auth_provider.dart';
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
      backgroundColor: ColorTokens.backgroundLight,
      appBar: AppBar(
        title: const Text('DoseLens', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22, color: ColorTokens.textPrimaryLight)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline_rounded, color: ColorTokens.textSecondaryLight),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorTokens.primarySlate,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddMedicationScreen())),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: RefreshIndicator(
        color: ColorTokens.primaryTeal,
        onRefresh: () async => ref.invalidate(medicationsStreamProvider),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text(
                _greeting(),
                style: const TextStyle(fontSize: 14, color: ColorTokens.textSecondaryLight, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                _todayLabel(),
                style: const TextStyle(fontSize: 13, color: ColorTokens.textMutedLight),
              ),
              const SizedBox(height: 20),

              // Adherence Metric Card
              rateAsync.when(
                loading: () => _AdherenceCardSkeleton(),
                error: (_, __) => const SizedBox.shrink(),
                data: (rate) => _AdherenceCard(rate: rate),
              ),
              const SizedBox(height: 24),

              // Today's Doses
              SectionHeader(
                title: 'Today\'s Doses',
                subtitle: 'Swipe right to take, left to skip',
                trailing: PillChip(
                  label: _todayDoseLabel(logsAsync.valueOrNull ?? []),
                  backgroundColor: ColorTokens.mintSuccessBg,
                  textColor: ColorTokens.mintSuccess,
                  borderColor: ColorTokens.mintSuccessBorder,
                ),
              ),
              const SizedBox(height: 12),

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

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning 👋';
    if (hour < 17) return 'Good afternoon 👋';
    return 'Good evening 👋';
  }

  String _todayLabel() {
    final now = DateTime.now();
    const days = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
    return '${days[now.weekday - 1]}, ${DateFormatters.formatDate(now)}';
  }

  String _todayDoseLabel(List<AdherenceLog> logs) {
    if (logs.isEmpty) return '0 logged';
    final taken = logs.where((l) => l.status == AdherenceStatus.taken).length;
    return '$taken / ${logs.length} taken';
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('30-Day Adherence', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: ColorTokens.textSecondaryLight)),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$pct%',
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w800, color: ColorTokens.textPrimaryLight, height: 1),
                    ),
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: PillChip(
                        label: isGood ? 'On Track' : 'Needs Attention',
                        backgroundColor: isGood ? ColorTokens.mintSuccessBg : ColorTokens.warningAmberBg,
                        textColor: isGood ? ColorTokens.mintSuccess : ColorTokens.warningAmber,
                        borderColor: isGood ? ColorTokens.mintSuccessBorder : ColorTokens.warningAmberBorder,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  isGood ? 'Great job keeping up with your medications!' : 'Try to take your doses as scheduled.',
                  style: const TextStyle(fontSize: 12, color: ColorTokens.textMutedLight),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
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
      width: 64,
      height: 64,
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
    final radius = size.width / 2 - 5;
    const strokeWidth = 7.0;

    // Background track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = const Color(0xFFE5E7EB),
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
        ..color = rate >= 0.8 ? ColorTokens.mintSuccess : ColorTokens.warningAmber,
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
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(_timeIcon(entry.key), size: 14, color: ColorTokens.textMutedLight),
                  const SizedBox(width: 6),
                  Text(entry.key, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ColorTokens.textMutedLight, letterSpacing: 0.8)),
                ],
              ),
            ),
            ...entry.value.map((med) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _DoseCard(medication: med, logs: logs),
            )),
          ],
        ],
      ],
    );
  }

  Map<String, List<Medication>> _groupByTimeOfDay(List<Medication> meds) {
    final groups = <String, List<Medication>>{'MORNING': [], 'AFTERNOON': [], 'EVENING': []};
    for (final med in meds) {
      for (final t in med.times) {
        final hour = int.tryParse(t.split(':').first) ?? 8;
        if (hour < 12) { groups['MORNING']!.add(med); break; }
        else if (hour < 17) { groups['AFTERNOON']!.add(med); break; }
        else { groups['EVENING']!.add(med); break; }
      }
    }
    return groups;
  }

  IconData _timeIcon(String label) {
    switch (label) {
      case 'MORNING': return Icons.wb_sunny_outlined;
      case 'AFTERNOON': return Icons.wb_cloudy_outlined;
      default: return Icons.nights_stay_outlined;
    }
  }
}

class _DoseCard extends ConsumerWidget {
  final Medication medication;
  final List<AdherenceLog> logs;

  const _DoseCard({required this.medication, required this.logs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final log = logs.cast<AdherenceLog?>().firstWhere(
      (l) => l?.medicationId == medication.id,
      orElse: () => null,
    );
    final isTaken = log?.status == AdherenceStatus.taken;

    return Dismissible(
      key: Key('dose_${medication.id}'),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          await _logDose(ref, context, AdherenceStatus.taken);
        } else {
          await _logDose(ref, context, AdherenceStatus.skipped);
        }
        return false; // don't remove card
      },
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 24),
        decoration: BoxDecoration(
          color: ColorTokens.mintSuccessBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: ColorTokens.mintSuccessBorder),
        ),
        child: const Row(children: [Icon(Icons.check_rounded, color: ColorTokens.mintSuccess), SizedBox(width: 8), Text('Taken', style: TextStyle(color: ColorTokens.mintSuccess, fontWeight: FontWeight.w600))]),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: ColorTokens.borderLight),
        ),
        child: const Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text('Skip', style: TextStyle(color: ColorTokens.textSecondaryLight, fontWeight: FontWeight.w600)), SizedBox(width: 8), Icon(Icons.remove_circle_outline, color: ColorTokens.textSecondaryLight)]),
      ),
      child: NeoCard(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MedicationDetailScreen(medication: medication))),
        backgroundColor: isTaken ? ColorTokens.mintSuccessBg : Colors.white,
        borderColor: isTaken ? ColorTokens.mintSuccessBorder : ColorTokens.borderLight,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isTaken ? ColorTokens.mintSuccess.withValues(alpha: 0.15) : ColorTokens.backgroundSecondaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.medication_liquid_rounded, color: isTaken ? ColorTokens.mintSuccess : ColorTokens.primaryTeal, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(medication.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: ColorTokens.textPrimaryLight)),
                  const SizedBox(height: 3),
                  Text('${medication.dosage} · ${medication.frequencyLabel}', style: const TextStyle(fontSize: 12, color: ColorTokens.textSecondaryLight)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            sb.StatusBadge(
              status: log == null
                  ? sb.AdherenceStatus.pending
                  : log.status == AdherenceStatus.taken
                      ? sb.AdherenceStatus.taken
                      : log.status == AdherenceStatus.missed
                          ? sb.AdherenceStatus.missed
                          : sb.AdherenceStatus.skipped,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logDose(WidgetRef ref, BuildContext context, AdherenceStatus status) async {
    final user = ref.read(firebaseAuthStateProvider).valueOrNull;
    if (user == null) return;
    final log = AdherenceLog(
      id: '',
      medicationId: medication.id,
      medicationName: medication.name,
      scheduledTime: DateTime.now(),
      takenTime: status == AdherenceStatus.taken ? DateTime.now() : null,
      status: status,
    );
    try {
      await ref.read(medicationsNotifierProvider.notifier).logDose(userId: user.uid, log: log);
    } catch (_) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to log dose')));
    }
  }
}

class _AdherenceCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeoCard(child: Container(height: 80, color: ColorTokens.backgroundSecondaryLight));
  }
}

class _MedCardSkeleton extends StatelessWidget {
  const _MedCardSkeleton();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: NeoCard(child: Container(height: 68, color: ColorTokens.backgroundSecondaryLight)),
    );
  }
}

class _EmptyMedicationsCard extends StatelessWidget {
  const _EmptyMedicationsCard();
  @override
  Widget build(BuildContext context) {
    return NeoCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            const Icon(Icons.medication_outlined, size: 40, color: ColorTokens.textMutedLight),
            const SizedBox(height: 12),
            const Text('No medications yet', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: ColorTokens.textPrimaryLight)),
            const SizedBox(height: 4),
            const Text('Tap + to add your first medication.', style: TextStyle(fontSize: 13, color: ColorTokens.textSecondaryLight)),
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
      borderColor: ColorTokens.alertCoralBorder,
      backgroundColor: ColorTokens.alertCoralBg,
      child: Text(message, style: const TextStyle(color: ColorTokens.alertCoral, fontSize: 13)),
    );
  }
}
