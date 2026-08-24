import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/theme/text_styles.dart';
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
      backgroundColor: ColorTokens.canvas,
      appBar: AppBar(
        title: Text('Passport.', style: TextStyles.displayMedium),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(AppConstants.space20, AppConstants.space8, AppConstants.space20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Adherence Score Card (28px radius)
            rateAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(color: ColorTokens.electricBlue, strokeWidth: 2),
                ),
              ),
              error: (_, __) => const SizedBox.shrink(),
              data: (rate) => _AdherenceScoreCard(rate: rate),
            ),
            const SizedBox(height: AppConstants.space28),

            // Active Medications Section
            SectionHeader(
              title: 'Prescribed Drugs',
              subtitle: 'Active regimens included in clinical report',
            ),
            const SizedBox(height: AppConstants.space8),
            medsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (meds) {
                if (meds.isEmpty) return const _EmptyMeds();
                return Column(
                  children: meds.map((med) => Padding(
                    padding: const EdgeInsets.only(bottom: AppConstants.space12),
                    child: NeoCard(
                      borderRadius: AppConstants.radiusCard,
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F7FF),
                              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                            ),
                            child: const Icon(Icons.medication_liquid_rounded, color: ColorTokens.electricBlue, size: 20),
                          ),
                          const SizedBox(width: AppConstants.space16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  med.name,
                                  style: TextStyles.headingMedium.copyWith(fontSize: 16),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${med.dosage} · ${med.frequencyLabel}',
                                  style: TextStyles.caption,
                                ),
                              ],
                            ),
                          ),
                          if (med.instructions != null)
                            PillChip(
                              label: 'Instructions',
                              backgroundColor: ColorTokens.coolWash,
                              textColor: ColorTokens.midGray,
                            ),
                        ],
                      ),
                    ),
                  )).toList(),
                );
              },
            ),
            const SizedBox(height: AppConstants.space28),

            // 30-Day Log Preview Section
            SectionHeader(
              title: 'Recent Activity',
              subtitle: 'Latest verification events',
            ),
            const SizedBox(height: AppConstants.space8),
            logsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (logs) {
                final preview = logs.take(5).toList();
                if (preview.isEmpty) return const SizedBox.shrink();
                return NeoCard(
                  borderRadius: AppConstants.radiusCard,
                  child: Column(
                    children: preview.asMap().entries.map((e) {
                      final log = e.value;
                      final isLast = e.key == preview.length - 1;
                      return Column(
                        children: [
                          _LogRow(log: log),
                          if (!isLast) const Divider(color: ColorTokens.hairline, height: 16),
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            const SizedBox(height: AppConstants.space32),

            // 1-Tap Export Button
            PrimaryActionButton(
              title: 'Generate Clinical Passport PDF',
              icon: const Icon(Icons.print_rounded, size: 18, color: Colors.white),
              isLoading: passportState.isLoading,
              onPressed: () async {
                await ref.read(passportProvider.notifier).generatePdf();
                final pdfBytes = ref.read(passportProvider).valueOrNull;
                if (pdfBytes != null) {
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
      borderRadius: AppConstants.radiusCard,
      padding: const EdgeInsets.all(AppConstants.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Clinical Summary',
                style: TextStyles.caption.copyWith(fontWeight: FontWeight.w500),
              ),
              PillChip(
                label: isGood ? 'High Adherence' : 'Needs Review',
                backgroundColor: isGood ? ColorTokens.mintSuccessBg : ColorTokens.emberBg,
                textColor: isGood ? ColorTokens.mintSuccess : ColorTokens.ember,
                borderColor: isGood ? ColorTokens.mintSuccessBorder : ColorTokens.emberBorder,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.space16),
          Row(
            children: [
              Text(
                '$pct%',
                style: TextStyles.metricNumber.copyWith(fontSize: 48),
              ),
              const SizedBox(width: AppConstants.space20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '30-Day Index',
                      style: TextStyles.headingMedium.copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Aggregated adherence score prepared for clinical doctor consultations.',
                      style: TextStyles.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.space20),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            child: LinearProgressIndicator(
              value: rate,
              minHeight: 8,
              backgroundColor: ColorTokens.coolWash,
              valueColor: AlwaysStoppedAnimation<Color>(
                isGood ? ColorTokens.electricBlue : ColorTokens.ember,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogRow extends StatelessWidget {
  final AdherenceLog log;
  const _LogRow({required this.log});

  @override
  Widget build(BuildContext context) {
    final isTaken = log.status == AdherenceStatus.taken;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isTaken ? ColorTokens.mintSuccessBg : ColorTokens.emberBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isTaken ? Icons.check_rounded : Icons.close_rounded,
              color: isTaken ? ColorTokens.mintSuccess : ColorTokens.ember,
              size: 16,
            ),
          ),
          const SizedBox(width: AppConstants.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.medicationName,
                  style: TextStyles.labelLarge,
                ),
                Text(
                  DateFormatters.formatDateTime(log.scheduledTime),
                  style: TextStyles.caption,
                ),
              ],
            ),
          ),
          PillChip(
            label: isTaken ? 'Taken' : (log.status == AdherenceStatus.missed ? 'Missed' : 'Skipped'),
            backgroundColor: isTaken ? ColorTokens.mintSuccessBg : ColorTokens.emberBg,
            textColor: isTaken ? ColorTokens.mintSuccess : ColorTokens.ember,
            borderColor: isTaken ? ColorTokens.mintSuccessBorder : ColorTokens.emberBorder,
          ),
        ],
      ),
    );
  }
}

class _EmptyMeds extends StatelessWidget {
  const _EmptyMeds();
  @override
  Widget build(BuildContext context) => NeoCard(
    borderRadius: AppConstants.radiusCard,
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Text(
          'No active medications to display in passport.',
          style: TextStyles.caption,
        ),
      ),
    ),
  );
}
