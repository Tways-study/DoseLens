import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/pill_chip.dart';
import '../../../core/widgets/primary_action_button.dart';
import '../../../core/utils/validators.dart';
import '../../medications/models/medication.dart';
import '../../medications/providers/medications_provider.dart';
import '../models/ocr_result.dart';
import '../providers/scanner_provider.dart';

class OcrVerificationSheet extends ConsumerStatefulWidget {
  final OcrResult result;

  const OcrVerificationSheet({super.key, required this.result});

  @override
  ConsumerState<OcrVerificationSheet> createState() => _OcrVerificationSheetState();
}

class _OcrVerificationSheetState extends ConsumerState<OcrVerificationSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _genericCtrl;
  late final TextEditingController _dosageCtrl;
  late final TextEditingController _instructionsCtrl;
  MedicationFrequency _frequency = MedicationFrequency.onceDaity;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final r = widget.result;
    _nameCtrl = TextEditingController(text: r.brandName ?? '');
    _genericCtrl = TextEditingController(text: r.genericName ?? '');
    _dosageCtrl = TextEditingController(text: r.dosage ?? '');
    _instructionsCtrl = TextEditingController(text: r.instructions ?? '');
    _frequency = _parseFrequency(r.frequency);
  }

  MedicationFrequency _parseFrequency(String? f) {
    if (f == null) return MedicationFrequency.onceDaity;
    final lower = f.toLowerCase();
    if (lower.contains('twice') || lower.contains('two') || lower.contains('2')) return MedicationFrequency.twiceDaily;
    if (lower.contains('three') || lower.contains('3')) return MedicationFrequency.threeTimesDaily;
    if (lower.contains('week')) return MedicationFrequency.weekly;
    if (lower.contains('needed') || lower.contains('prn')) return MedicationFrequency.asNeeded;
    return MedicationFrequency.onceDaity;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _genericCtrl.dispose();
    _dosageCtrl.dispose();
    _instructionsCtrl.dispose();
    super.dispose();
  }

  Future<void> _confirmAndSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final med = Medication(
        id: '',
        name: _nameCtrl.text.trim(),
        genericName: _genericCtrl.text.trim().isEmpty ? null : _genericCtrl.text.trim(),
        dosage: _dosageCtrl.text.trim(),
        frequency: _frequency,
        times: _frequency == MedicationFrequency.twiceDaily
            ? ['08:00', '20:00']
            : _frequency == MedicationFrequency.threeTimesDaily
                ? ['08:00', '14:00', '20:00']
                : ['08:00'],
        instructions: _instructionsCtrl.text.trim().isEmpty ? null : _instructionsCtrl.text.trim(),
        startDate: DateTime.now(),
      );
      await ref.read(medicationsNotifierProvider.notifier).addMedication(med);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text('${_nameCtrl.text} added to schedule!'),
            ]),
            backgroundColor: ColorTokens.mintSuccess,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusMedium)),
          ),
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e'), backgroundColor: ColorTokens.crimsonAlert));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final confidence = widget.result.confidence;
    return DraggableScrollableSheet(
      initialChildSize: 0.90,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollCtrl) {
        return Container(
          decoration: const BoxDecoration(
            color: ColorTokens.icePaper,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.radiusCard)),
          ),
          padding: const EdgeInsets.fromLTRB(AppConstants.space24, AppConstants.space16, AppConstants.space24, 24),
          child: Form(
            key: _formKey,
            child: ListView(
              controller: scrollCtrl,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: ColorTokens.coolHairline,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.space16),

                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Verify OCR Label', style: TextStyles.headingLarge),
                        const SizedBox(height: 2),
                        Text('Review AI-extracted prescription metadata', style: TextStyles.caption),
                      ],
                    ),
                    if (confidence != null)
                      PillChip(
                        label: '${(confidence * 100).round()}% match',
                        backgroundColor: ColorTokens.mintSuccessBg,
                        textColor: ColorTokens.mintSuccess,
                        borderColor: ColorTokens.mintSuccessBorder,
                      ),
                  ],
                ),
                const SizedBox(height: AppConstants.space20),

                // Form card
                Container(
                  padding: const EdgeInsets.all(AppConstants.space20),
                  decoration: BoxDecoration(
                    color: ColorTokens.snow,
                    borderRadius: BorderRadius.circular(AppConstants.radiusCard),
                    border: Border.all(color: ColorTokens.coolHairline, width: 1.0),
                    boxShadow: const [ColorTokens.cardShadow],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _Label('Brand Name'),
                      _SheetField(controller: _nameCtrl, hint: 'e.g. Lipitor', validator: (v) => Validators.requiredField(v, 'Name')),
                      const SizedBox(height: AppConstants.space16),
                      const _Label('Generic Ingredient'),
                      _SheetField(controller: _genericCtrl, hint: 'e.g. Atorvastatin'),
                      const SizedBox(height: AppConstants.space16),
                      const _Label('Dosage Strength'),
                      _SheetField(controller: _dosageCtrl, hint: 'e.g. 20mg', validator: (v) => Validators.requiredField(v, 'Dosage')),
                      const SizedBox(height: AppConstants.space16),
                      const _Label('Frequency'),
                      _FrequencySelector(
                        selected: _frequency,
                        onChanged: (f) => setState(() => _frequency = f),
                      ),
                      const SizedBox(height: AppConstants.space16),
                      const _Label('Special Instructions'),
                      _SheetField(controller: _instructionsCtrl, hint: 'e.g. Take 1 tablet daily at bedtime', maxLines: 2),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.space24),

                PrimaryActionButton(
                  title: 'Confirm & Save Schedule',
                  isLoading: _loading,
                  onPressed: _confirmAndSave,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: ColorTokens.midnightObsidian, letterSpacing: -0.1),
        ),
      );
}

class _SheetField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final String? Function(String?)? validator;

  const _SheetField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        style: const TextStyle(fontSize: 14, color: ColorTokens.midnightObsidian, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: ColorTokens.mutedMist, fontSize: 13),
          filled: true,
          fillColor: ColorTokens.iceSlate,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppConstants.radiusButton), borderSide: const BorderSide(color: ColorTokens.coolHairline)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppConstants.radiusButton), borderSide: const BorderSide(color: ColorTokens.coolHairline)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusButton),
            borderSide: const BorderSide(color: ColorTokens.electricCerulean, width: 1.5),
          ),
        ),
      );
}

class _FrequencySelector extends StatelessWidget {
  final MedicationFrequency selected;
  final ValueChanged<MedicationFrequency> onChanged;

  const _FrequencySelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final opts = [
      (MedicationFrequency.onceDaity, 'Once daily'),
      (MedicationFrequency.twiceDaily, 'Twice daily'),
      (MedicationFrequency.threeTimesDaily, '3× daily'),
      (MedicationFrequency.asNeeded, 'As needed'),
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: opts.map((opt) {
        final isSelected = selected == opt.$1;
        return GestureDetector(
          onTap: () => onChanged(opt.$1),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: isSelected ? ColorTokens.electricCerulean : ColorTokens.iceSlate,
              borderRadius: BorderRadius.circular(AppConstants.radiusButton),
              border: Border.all(color: isSelected ? ColorTokens.electricCerulean : ColorTokens.coolHairline),
            ),
            child: Text(
              opt.$2,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : ColorTokens.midnightObsidian,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
