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
import '../../../core/widgets/status_badge.dart';
import '../../medications/providers/medications_provider.dart';
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
      backgroundColor: ColorTokens.paper,
      appBar: AppBar(
        backgroundColor: ColorTokens.paper,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: ColorTokens.acidGreen,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Clinical Passport',
              style: TextStyles.displayMedium.copyWith(fontSize: 24),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(AppConstants.space20, AppConstants.space8, AppConstants.space20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Passport Certification Card with 3D Seal Artwork
            NeoCard(
              padding: const EdgeInsets.all(AppConstants.space20),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                    child: SizedBox(
                      width: 72,
                      height: 72,
                      child: Image.asset(
                        'assets/images/craftwork_passport_seal.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.space16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const PillChip(
                          label: '30-Day Clinical Summary',
                          backgroundColor: ColorTokens.acidGreen,
                          textColor: ColorTokens.inkBlack,
                          borderColor: ColorTokens.inkBlack,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Doctor\'s Visit Passport',
                          style: TextStyles.headingMedium.copyWith(fontSize: 17),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Comprehensive adherence dossier ready for doctor review.',
                          style: TextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.space20),

            // Adherence Metric Card
            rateAsync.when(
              data: (rate) {
                final pct = (rate * 100).round();
                return NeoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Overall Adherence', style: TextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
                          PillChip(
                            label: pct >= 80 ? 'Optimal' : 'Needs Review',
                            backgroundColor: pct >= 80 ? ColorTokens.mintSuccessBg : ColorTokens.vermillionBg,
                            textColor: pct >= 80 ? ColorTokens.mintSuccess : ColorTokens.vermillion,
                            borderColor: pct >= 80 ? ColorTokens.mintSuccessBorder : ColorTokens.vermillionBorder,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '$pct%',
                            style: TextStyles.metricNumber.copyWith(fontSize: 48),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'last 30 days',
                            style: TextStyles.caption,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                        child: LinearProgressIndicator(
                          value: rate.clamp(0.0, 1.0),
                          backgroundColor: ColorTokens.fog,
                          valueColor: const AlwaysStoppedAnimation<Color>(ColorTokens.acidGreen),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox(height: 100),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: AppConstants.space24),

            // Active Medications List
            const SectionHeader(
              title: 'Active Regimen',
              subtitle: 'Current prescribed dosages and instructions',
            ),
            medsAsync.when(
              data: (meds) {
                if (meds.isEmpty) {
                  return const NeoCard(
                    child: Center(
                      child: Text('No active prescriptions', style: TextStyle(color: ColorTokens.graphite)),
                    ),
                  );
                }
                return Column(
                  children: meds.map((m) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: NeoCard(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(m.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                                Text('${m.dosage} · ${m.frequencyLabel}', style: TextStyles.caption),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: ColorTokens.fog,
                                borderRadius: BorderRadius.circular(AppConstants.radiusButton),
                                border: Border.all(color: ColorTokens.hairline),
                              ),
                              child: Text(
                                m.times.join(', '),
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ColorTokens.inkBlack),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const SizedBox(height: 80),
              error: (e, _) => Text('Error: $e'),
            ),
            const SizedBox(height: AppConstants.space24),

            // 30-Day History Section
            const SectionHeader(
              title: 'Adherence Feed',
              subtitle: 'Recent dose confirmations and logs',
            ),
            logsAsync.when(
              data: (logs) {
                if (logs.isEmpty) {
                  return const NeoCard(
                    child: Center(child: Text('No logs recorded yet', style: TextStyle(color: ColorTokens.graphite))),
                  );
                }
                return Column(
                  children: logs.take(8).map((log) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: NeoCard(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          children: [
                            StatusBadge(status: log.status),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(log.medicationName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                                  Text(DateFormatters.formatDateTime(log.scheduledTime), style: TextStyles.caption),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const SizedBox(height: 80),
              error: (e, _) => Text('Error: $e'),
            ),
            const SizedBox(height: AppConstants.space28),

            // 1-Tap Export Button (Acid Green Pill)
            PrimaryActionButton(
              title: 'Generate Clinical Passport PDF',
              icon: const Icon(Icons.picture_as_pdf_rounded, size: 18, color: ColorTokens.inkBlack),
              isLoading: passportState.isLoading,
              isPill: true,
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
