import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/neo_card.dart';
import '../../../core/widgets/pill_chip.dart';
import '../../../core/widgets/primary_action_button.dart';
import '../../../core/widgets/section_header.dart';
import '../../../features/medications/models/adherence_log.dart';
import '../../../features/medications/providers/medications_provider.dart';
import '../providers/passport_provider.dart';

class PassportScreen extends ConsumerWidget {
  const PassportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medsAsync = ref.watch(medicationsStreamProvider);
    final rateAsync = ref.watch(adherenceRateProvider);
    final logsAsync = ref.watch(thirtyDayLogsProvider);
    final passportState = ref.watch(passportProvider);

    return Scaffold(
      backgroundColor: ColorTokens.backgroundLight,
      appBar: AppBar(
        title: const Text('Health Passport', style: TextStyle(fontWeight: FontWeight.w700, color: ColorTokens.textPrimaryLight)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Adherence Score Card
            rateAsync.when(
              loading: () => const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator(color: ColorTokens.primaryTeal))),
              error: (_, __) => const SizedBox.shrink(),
              data: (rate) => _AdherenceScoreCard(rate: rate),
            ),
            const SizedBox(height: 24),

            // Active Medications
            SectionHeader(title: 'Active Medications', subtitle: 'Included in your passport'),
            const SizedBox(height: 12),
            medsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (meds) {
                if (meds.isEmpty) return const _EmptyMeds();
                return Column(
                  children: meds.map((med) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: NeoCard(
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(color: ColorTokens.primaryTeal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.medication_liquid_rounded, color: ColorTokens.primaryTeal, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(med.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ColorTokens.textPrimaryLight)),
                                Text('${med.dosage} · ${med.frequencyLabel}', style: const TextStyle(fontSize: 12, color: ColorTokens.textSecondaryLight)),
                              ],
                            ),
                          ),
                          if (med.instructions != null)
                            PillChip(label: 'Instructions', backgroundColor: ColorTokens.backgroundSecondaryLight, textColor: ColorTokens.textSecondaryLight, borderColor: ColorTokens.borderLight),
                        ],
                      ),
                    ),
                  )).toList(),
                );
              },
            ),
            const SizedBox(height: 24),

            // Recent adherence log preview
            SectionHeader(title: '30-Day Log Preview', subtitle: 'Last 5 dose events'),
            const SizedBox(height: 12),
            logsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (logs) {
                final preview = logs.take(5).toList();
                if (preview.isEmpty) return const SizedBox.shrink();
                return NeoCard(
                  child: Column(
                    children: preview.asMap().entries.map((e) {
                      final log = e.value;
                      final isLast = e.key == preview.length - 1;
                      return Column(
                        children: [
                          _LogRow(log: log),
                          if (!isLast) const Divider(color: ColorTokens.borderLight, height: 1),
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            // Export PDF
            passportState.isLoading
                ? const Center(child: CircularProgressIndicator(color: ColorTokens.primaryTeal))
                : PrimaryActionButton(
                    title: 'Export PDF Passport',
                    icon: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white, size: 20),
                    onPressed: () async {
                      await ref.read(passportProvider.notifier).generatePdf();
                      final pdfBytes = ref.read(passportProvider).valueOrNull;
                      if (pdfBytes != null && context.mounted) {
                        await Printing.layoutPdf(onLayout: (_) => pdfBytes);
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

class _AdherenceScoreCard extends StatelessWidget {
  final double rate;
  const _AdherenceScoreCard({required this.rate});

  @override
  Widget build(BuildContext context) {
    final pct = (rate * 100).round();
    final isGood = pct >= 80;
    return NeoCard(
      child: Row(
        children: [
          // Donut chart
          SizedBox(
            width: 90,
            height: 90,
            child: CustomPaint(
              painter: _LargeDonutPainter(rate: rate),
              child: Center(
                child: Text('$pct%', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: ColorTokens.textPrimaryLight)),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('30-Day Adherence', style: TextStyle(fontSize: 13, color: ColorTokens.textSecondaryLight, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                PillChip(
                  label: isGood ? '✓ Clinical Goal Met' : '⚠ Needs Improvement',
                  backgroundColor: isGood ? ColorTokens.mintSuccessBg : ColorTokens.warningAmberBg,
                  textColor: isGood ? ColorTokens.mintSuccess : ColorTokens.warningAmber,
                  borderColor: isGood ? ColorTokens.mintSuccessBorder : ColorTokens.warningAmberBorder,
                ),
                const SizedBox(height: 8),
                Text(
                  isGood ? 'Excellent adherence. Ready for your doctor visit.' : 'Try to improve consistency before your appointment.',
                  style: const TextStyle(fontSize: 12, color: ColorTokens.textMutedLight, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LargeDonutPainter extends CustomPainter {
  final double rate;
  _LargeDonutPainter({required this.rate});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 9.0;

    canvas.drawCircle(center, radius,
        Paint()..style = PaintingStyle.stroke..strokeWidth = strokeWidth..color = const Color(0xFFE5E7EB));

    final sweepAngle = rate.clamp(0.0, 1.0) * 2 * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
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
  bool shouldRepaint(_LargeDonutPainter old) => old.rate != rate;
}

class _LogRow extends StatelessWidget {
  final AdherenceLog log;
  const _LogRow({required this.log});

  @override
  Widget build(BuildContext context) {
    final isTaken = log.status == AdherenceStatus.taken;
    final isMissed = log.status == AdherenceStatus.missed;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(
            isTaken ? Icons.check_circle_rounded : isMissed ? Icons.cancel_rounded : Icons.remove_circle_rounded,
            color: isTaken ? ColorTokens.mintSuccess : isMissed ? ColorTokens.alertCoral : ColorTokens.textMutedLight,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(log.medicationName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: ColorTokens.textPrimaryLight))),
          Text(DateFormatters.formatShortDate(log.scheduledTime), style: const TextStyle(fontSize: 12, color: ColorTokens.textMutedLight)),
        ],
      ),
    );
  }
}

class _EmptyMeds extends StatelessWidget {
  const _EmptyMeds();
  @override
  Widget build(BuildContext context) {
    return const NeoCard(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: Text('No active medications tracked yet', style: TextStyle(fontSize: 13, color: ColorTokens.textSecondaryLight))),
      ),
    );
  }
}
