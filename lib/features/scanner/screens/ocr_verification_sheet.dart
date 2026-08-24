import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/widgets/primary_action_button.dart';
import '../../../core/utils/validators.dart';
import '../../medications/models/medication.dart';
import '../../medications/providers/medications_provider.dart';
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
            content: Row(children: [const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18), const SizedBox(width: 8), Text('${_nameCtrl.text} added!')]),
            backgroundColor: ColorTokens.mintSuccess,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e'), backgroundColor: ColorTokens.alertCoral));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final confidence = widget.result.confidence;
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: ColorTokens.backgroundLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Drag handle
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Container(width: 40, height: 4, decoration: BoxDecoration(color: ColorTokens.borderLight, borderRadius: BorderRadius.circular(99))),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: ColorTokens.mintSuccessBg, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.auto_fix_high_rounded, color: ColorTokens.mintSuccess, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('OCR Result', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ColorTokens.textPrimaryLight)),
                        if (confidence != null)
                          Text('${(confidence * 100).round()}% confidence', style: TextStyle(fontSize: 12, color: confidence >= 0.8 ? ColorTokens.mintSuccess : ColorTokens.warningAmber)),
                      ],
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.close_rounded, color: ColorTokens.textSecondaryLight), onPressed: () => Navigator.pop(context)),
                ],
              ),
            ),
            const Divider(color: ColorTokens.borderLight, height: 24),

            // Form (scrollable)
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Verify & edit before saving', style: TextStyle(fontSize: 13, color: ColorTokens.textSecondaryLight)),
                      const SizedBox(height: 20),

                      _SheetField(controller: _nameCtrl, label: 'Brand / Product Name', hint: 'e.g. Biogesic', validator: (v) => Validators.requiredField(v, 'Name')),
                      const SizedBox(height: 14),
                      _SheetField(controller: _genericCtrl, label: 'Generic Name', hint: 'e.g. Paracetamol'),
                      const SizedBox(height: 14),
                      _SheetField(controller: _dosageCtrl, label: 'Dosage', hint: 'e.g. 500mg', validator: (v) => Validators.requiredField(v, 'Dosage')),
                      const SizedBox(height: 14),
                      const Text('Frequency', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: ColorTokens.textPrimaryLight)),
                      const SizedBox(height: 8),
                      _FreqRow(selected: _frequency, onChanged: (f) => setState(() => _frequency = f)),
                      const SizedBox(height: 14),
                      _SheetField(controller: _instructionsCtrl, label: 'Instructions', hint: 'e.g. Take with food', maxLines: 2),
                      const SizedBox(height: 28),
                      PrimaryActionButton(title: 'Confirm & Save', isLoading: _loading, onPressed: _confirmAndSave, backgroundColor: ColorTokens.primaryTeal),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final String? Function(String?)? validator;

  const _SheetField({required this.controller, required this.label, required this.hint, this.maxLines = 1, this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: ColorTokens.textPrimaryLight)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(fontSize: 15, color: ColorTokens.textPrimaryLight),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: ColorTokens.textMutedLight),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ColorTokens.borderLight)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ColorTokens.borderLight)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ColorTokens.primaryTeal, width: 1.5)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ColorTokens.alertCoral)),
          ),
        ),
      ],
    );
  }
}

class _FreqRow extends StatelessWidget {
  final MedicationFrequency selected;
  final ValueChanged<MedicationFrequency> onChanged;

  const _FreqRow({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final opts = [(MedicationFrequency.onceDaity, 'Once'), (MedicationFrequency.twiceDaily, '2×'), (MedicationFrequency.threeTimesDaily, '3×'), (MedicationFrequency.weekly, 'Weekly'), (MedicationFrequency.asNeeded, 'PRN')];
    return Wrap(
      spacing: 8, runSpacing: 8,
      children: opts.map((o) {
        final sel = selected == o.$1;
        return GestureDetector(
          onTap: () => onChanged(o.$1),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: sel ? ColorTokens.primaryTeal : Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: sel ? ColorTokens.primaryTeal : ColorTokens.borderLight),
            ),
            child: Text(o.$2, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: sel ? Colors.white : ColorTokens.textSecondaryLight)),
          ),
        );
      }).toList(),
    );
  }
}
