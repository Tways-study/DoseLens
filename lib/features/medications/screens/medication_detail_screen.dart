import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/widgets/neo_card.dart';
import '../../../core/widgets/pill_chip.dart';
import '../models/adherence_log.dart';
import '../models/medication.dart';
import '../providers/medications_provider.dart';

class MedicationDetailScreen extends ConsumerWidget {
  final Medication medication;

  const MedicationDetailScreen({super.key, required this.medication});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rateAsync = ref.watch(adherenceRateProvider);

    return Scaffold(
      backgroundColor: ColorTokens.backgroundLight,
      appBar: AppBar(
        title: const Text('Medication Detail', style: TextStyle(fontWeight: FontWeight.w700, color: ColorTokens.textPrimaryLight)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: ColorTokens.alertCoral),
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            NeoCard(
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: ColorTokens.primaryTeal.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.medication_liquid_rounded, color: ColorTokens.primaryTeal, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(medication.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: ColorTokens.textPrimaryLight)),
                        if (medication.genericName != null) ...[
                          const SizedBox(height: 3),
                          Text(medication.genericName!, style: const TextStyle(fontSize: 13, color: ColorTokens.textSecondaryLight)),
                        ],
                      ],
                    ),
                  ),
                  PillChip(
                    label: medication.active ? 'Active' : 'Inactive',
                    backgroundColor: medication.active ? ColorTokens.mintSuccessBg : const Color(0xFFF3F4F6),
                    textColor: medication.active ? ColorTokens.mintSuccess : ColorTokens.textSecondaryLight,
                    borderColor: medication.active ? ColorTokens.mintSuccessBorder : ColorTokens.borderLight,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Details
            NeoCard(
              child: Column(
                children: [
                  _DetailRow(icon: Icons.scale_rounded, label: 'Dosage', value: medication.dosage),
                  const Divider(color: ColorTokens.borderLight),
                  _DetailRow(icon: Icons.repeat_rounded, label: 'Frequency', value: medication.frequencyLabel),
                  const Divider(color: ColorTokens.borderLight),
                  _DetailRow(icon: Icons.access_time_rounded, label: 'Schedule', value: medication.times.join(' · ')),
                  if (medication.instructions != null) ...[
                    const Divider(color: ColorTokens.borderLight),
                    _DetailRow(icon: Icons.info_outline_rounded, label: 'Instructions', value: medication.instructions!),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Adherence
            rateAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (rate) => NeoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('30-Day Adherence', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: ColorTokens.textSecondaryLight)),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: rate,
                        minHeight: 10,
                        backgroundColor: ColorTokens.borderLight,
                        valueColor: AlwaysStoppedAnimation<Color>(rate >= 0.8 ? ColorTokens.mintSuccess : ColorTokens.warningAmber),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('${(rate * 100).round()}% of doses taken on schedule', style: const TextStyle(fontSize: 12, color: ColorTokens.textMutedLight)),
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
        title: const Text('Remove Medication?'),
        content: Text('${medication.name} will be removed from your active medications.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove', style: TextStyle(color: ColorTokens.alertCoral)),
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: ColorTokens.primaryTeal),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 13, color: ColorTokens.textSecondaryLight, fontWeight: FontWeight.w500)),
          const Spacer(),
          Flexible(child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ColorTokens.textPrimaryLight), textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
