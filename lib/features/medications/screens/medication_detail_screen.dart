import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/neo_card.dart';
import '../../../core/widgets/pill_chip.dart';
import '../models/medication.dart';
import '../providers/medications_provider.dart';

class MedicationDetailScreen extends ConsumerWidget {
  final Medication medication;

  const MedicationDetailScreen({super.key, required this.medication});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rateAsync = ref.watch(adherenceRateProvider);

    return Scaffold(
      backgroundColor: ColorTokens.canvas,
      appBar: AppBar(
        title: Text('Details.', style: TextStyles.displayMedium.copyWith(fontSize: 22)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: ColorTokens.primaryInk),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: ColorTokens.ember, size: 22),
            onPressed: () => _confirmDelete(context, ref),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.space20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card (28px radius)
            NeoCard(
              borderRadius: AppConstants.radiusCard,
              padding: const EdgeInsets.all(AppConstants.space24),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F7FF),
                      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                    ),
                    child: const Icon(Icons.medication_liquid_rounded, color: ColorTokens.electricBlue, size: 28),
                  ),
                  const SizedBox(width: AppConstants.space16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medication.name,
                          style: TextStyles.headingLarge,
                        ),
                        if (medication.genericName != null) ...[
                          const SizedBox(height: 3),
                          Text(
                            medication.genericName!,
                            style: TextStyles.caption,
                          ),
                        ],
                      ],
                    ),
                  ),
                  PillChip(
                    label: medication.active ? 'Active' : 'Inactive',
                    backgroundColor: medication.active ? ColorTokens.mintSuccessBg : ColorTokens.coolWash,
                    textColor: medication.active ? ColorTokens.mintSuccess : ColorTokens.midGray,
                    borderColor: medication.active ? ColorTokens.mintSuccessBorder : ColorTokens.hairline,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.space16),

            // Clinical Prescription Details Card
            NeoCard(
              borderRadius: AppConstants.radiusCard,
              child: Column(
                children: [
                  _DetailRow(icon: Icons.scale_rounded, label: 'Dosage', value: medication.dosage),
                  const Divider(color: ColorTokens.hairline),
                  _DetailRow(icon: Icons.repeat_rounded, label: 'Frequency', value: medication.frequencyLabel),
                  const Divider(color: ColorTokens.hairline),
                  _DetailRow(icon: Icons.access_time_rounded, label: 'Scheduled Times', value: medication.times.join(' · ')),
                  if (medication.instructions != null) ...[
                    const Divider(color: ColorTokens.hairline),
                    _DetailRow(icon: Icons.info_outline_rounded, label: 'Instructions', value: medication.instructions!),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppConstants.space16),

            // 30-Day Adherence Card
            rateAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (rate) => NeoCard(
                borderRadius: AppConstants.radiusCard,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '30-Day Adherence Rate',
                      style: TextStyles.caption.copyWith(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                      child: LinearProgressIndicator(
                        value: rate,
                        minHeight: 8,
                        backgroundColor: ColorTokens.coolWash,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          rate >= 0.8 ? ColorTokens.electricBlue : ColorTokens.ember,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(rate * 100).round()}% of scheduled doses taken on time.',
                      style: TextStyles.caption,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: ColorTokens.paper,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusCard)),
        title: Text('Remove Medication?', style: TextStyles.headingMedium),
        content: Text(
          '${medication.name} will be permanently removed from your active schedule.',
          style: TextStyles.bodySecondary,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: ColorTokens.midGray)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove', style: TextStyle(color: ColorTokens.ember, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(medicationsNotifierProvider.notifier).deleteMedication(medication.id);
      if (context.mounted) Navigator.pop(context);
    }
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.space12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: ColorTokens.electricBlue),
          const SizedBox(width: AppConstants.space12),
          Text(label, style: TextStyles.bodySecondary.copyWith(fontSize: 14)),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: TextStyles.labelLarge,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
