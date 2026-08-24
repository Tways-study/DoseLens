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
    return Scaffold(
      backgroundColor: ColorTokens.paper,
      appBar: AppBar(
        backgroundColor: ColorTokens.paper,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text('Prescription Details', style: TextStyles.displayMedium.copyWith(fontSize: 20)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 20, color: ColorTokens.inkBlack),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: ColorTokens.vermillion, size: 22),
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
            // Header card
            NeoCard(
              padding: const EdgeInsets.all(AppConstants.space20),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: ColorTokens.acidGreen,
                      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                      border: Border.all(color: ColorTokens.inkBlack, width: 1.0),
                    ),
                    child: const Icon(Icons.medication_rounded, color: ColorTokens.inkBlack, size: 28),
                  ),
                  const SizedBox(width: AppConstants.space16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medication.name,
                          style: TextStyles.headingMedium.copyWith(fontSize: 18),
                        ),
                        if (medication.genericName != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            medication.genericName!,
                            style: TextStyles.caption,
                          ),
                        ],
                        const SizedBox(height: 8),
                        PillChip(
                          label: medication.dosage,
                          backgroundColor: ColorTokens.fog,
                          textColor: ColorTokens.inkBlack,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.space16),

            // Clinical Details Grid Card
            NeoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow(
                    label: 'Frequency',
                    value: medication.frequencyLabel,
                    icon: Icons.repeat_rounded,
                  ),
                  const Divider(color: ColorTokens.hairline),
                  _DetailRow(
                    label: 'Dosing Times',
                    value: medication.times.join(' · '),
                    icon: Icons.access_time_rounded,
                  ),
                  if (medication.instructions != null) ...[
                    const Divider(color: ColorTokens.hairline),
                    _DetailRow(
                      label: 'Instructions',
                      value: medication.instructions!,
                      icon: Icons.info_outline_rounded,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppConstants.space24),

            // Delete prescription button
            OutlinedButton.icon(
              icon: const Icon(Icons.delete_outline_rounded, color: ColorTokens.vermillion, size: 18),
              label: const Text('Remove from Active Regimen', style: TextStyle(color: ColorTokens.vermillion, fontWeight: FontWeight.w700)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: ColorTokens.vermillionBorder),
                backgroundColor: ColorTokens.vermillionBg,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusButton)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () => _confirmDelete(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ColorTokens.snow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusCard),
          side: const BorderSide(color: ColorTokens.hairline),
        ),
        title: const Text('Delete Medication', style: TextStyle(fontWeight: FontWeight.w800, color: ColorTokens.inkBlack)),
        content: Text('Are you sure you want to remove ${medication.name} from your active schedule?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: ColorTokens.graphite)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorTokens.vermillion,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusButton)),
            ),
            onPressed: () async {
              await ref.read(medicationsNotifierProvider.notifier).deleteMedication(medication.id);
              if (ctx.mounted) {
                Navigator.pop(ctx);
                Navigator.pop(context);
              }
            },
            child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DetailRow({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: ColorTokens.graphite),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyles.caption),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: ColorTokens.inkBlack),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
