import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/neo_card.dart';
import '../../../core/widgets/primary_action_button.dart';
import '../models/medication.dart';
import '../providers/medications_provider.dart';

class AddMedicationScreen extends ConsumerStatefulWidget {
  final Medication? prefilled;

  const AddMedicationScreen({super.key, this.prefilled});

  @override
  ConsumerState<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends ConsumerState<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _genericCtrl;
  late final TextEditingController _dosageCtrl;
  late final TextEditingController _instructionsCtrl;
  MedicationFrequency _frequency = MedicationFrequency.onceDaity;
  final List<TimeOfDay> _times = [const TimeOfDay(hour: 8, minute: 0)];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final p = widget.prefilled;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _genericCtrl = TextEditingController(text: p?.genericName ?? '');
    _dosageCtrl = TextEditingController(text: p?.dosage ?? '');
    _instructionsCtrl = TextEditingController(text: p?.instructions ?? '');
    if (p != null) _frequency = p.frequency;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _genericCtrl.dispose();
    _dosageCtrl.dispose();
    _instructionsCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final med = Medication(
        id: '',
        name: _nameCtrl.text.trim(),
        genericName: _genericCtrl.text.trim().isEmpty ? null : _genericCtrl.text.trim(),
        dosage: _dosageCtrl.text.trim(),
        frequency: _frequency,
        times: _times
            .map((t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}')
            .toList(),
        instructions: _instructionsCtrl.text.trim().isEmpty ? null : _instructionsCtrl.text.trim(),
        startDate: DateTime.now(),
      );
      await ref.read(medicationsNotifierProvider.notifier).addMedication(med);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: ColorTokens.error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickTime(int index) async {
    final picked = await showTimePicker(context: context, initialTime: _times[index]);
    if (picked != null) setState(() => _times[index] = picked);
  }

  void _addTime() {
    setState(() => _times.add(const TimeOfDay(hour: 20, minute: 0)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTokens.fog,
      appBar: AppBar(
        backgroundColor: ColorTokens.snow,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text('New Medication', style: TextStyles.displayMedium.copyWith(fontSize: 22)),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, size: 20, color: ColorTokens.ink),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(AppConstants.space20, AppConstants.space16, AppConstants.space20, 100),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NeoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _Label('Brand / Product Name'),
                      _Field(
                        controller: _nameCtrl,
                        hint: 'e.g. Biogesic',
                        validator: (v) => Validators.requiredField(v, 'Name'),
                      ),
                      const SizedBox(height: AppConstants.space16),
                      const _Label('Generic Active Ingredient'),
                      _Field(
                        controller: _genericCtrl,
                        hint: 'e.g. Paracetamol (optional)',
                      ),
                      const SizedBox(height: AppConstants.space16),
                      const _Label('Dosage Strength'),
                      _Field(
                        controller: _dosageCtrl,
                        hint: 'e.g. 500mg',
                        validator: (v) => Validators.requiredField(v, 'Dosage'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.space16),

                NeoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _Label('Frequency'),
                      _FrequencyPicker(
                        selected: _frequency,
                        onChanged: (f) {
                          setState(() {
                            _frequency = f;
                            _times.clear();
                            switch (f) {
                              case MedicationFrequency.onceDaity:
                                _times.add(const TimeOfDay(hour: 8, minute: 0));
                                break;
                              case MedicationFrequency.twiceDaily:
                                _times.addAll([
                                  const TimeOfDay(hour: 8, minute: 0),
                                  const TimeOfDay(hour: 20, minute: 0),
                                ]);
                                break;
                              case MedicationFrequency.threeTimesDaily:
                                _times.addAll([
                                  const TimeOfDay(hour: 8, minute: 0),
                                  const TimeOfDay(hour: 14, minute: 0),
                                  const TimeOfDay(hour: 20, minute: 0),
                                ]);
                                break;
                              default:
                                _times.add(const TimeOfDay(hour: 8, minute: 0));
                            }
                          });
                        },
                      ),
                      const SizedBox(height: AppConstants.space20),
                      const _Label('Scheduled Times'),
                      ...List.generate(
                        _times.length,
                        (i) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: GestureDetector(
                            onTap: () => _pickTime(i),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: ColorTokens.fog,
                                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                                border: Border.all(color: ColorTokens.hairline),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.access_time_rounded, size: 18, color: ColorTokens.ash),
                                  const SizedBox(width: 12),
                                  Text(
                                    _times[i].format(context),
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ColorTokens.ink),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.chevron_right_rounded, size: 18, color: ColorTokens.ash),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _addTime,
                        icon: const Icon(Icons.add_rounded, size: 18, color: ColorTokens.cobaltSignal),
                        label: const Text('Add another time', style: TextStyle(color: ColorTokens.cobaltSignal, fontWeight: FontWeight.w600, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.space16),

                NeoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _Label('Special Instructions'),
                      _Field(
                        controller: _instructionsCtrl,
                        hint: 'e.g. Take with water after meals',
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.space24),

                PrimaryActionButton(
                  title: 'Save Prescription',
                  isLoading: _loading,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
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
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: ColorTokens.ink, letterSpacing: -0.1),
        ),
      );
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final String? Function(String?)? validator;

  const _Field({required this.controller, required this.hint, this.maxLines = 1, this.validator});

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        style: const TextStyle(fontSize: 14, color: ColorTokens.ink, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: ColorTokens.ashGray, fontSize: 13),
          filled: true,
          fillColor: ColorTokens.fog,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppConstants.radiusButton), borderSide: const BorderSide(color: ColorTokens.hairline)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppConstants.radiusButton), borderSide: const BorderSide(color: ColorTokens.hairline)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusButton),
            borderSide: const BorderSide(color: ColorTokens.inkBlack, width: 1.5),
          ),
        ),
      );
}

class _FrequencyPicker extends StatelessWidget {
  final MedicationFrequency selected;
  final ValueChanged<MedicationFrequency> onChanged;

  const _FrequencyPicker({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final opts = [
      (MedicationFrequency.onceDaity, 'Once daily'),
      (MedicationFrequency.twiceDaily, 'Twice daily'),
      (MedicationFrequency.threeTimesDaily, '3× daily'),
      (MedicationFrequency.weekly, 'Weekly'),
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
              color: isSelected ? ColorTokens.charcoal : ColorTokens.fog,
              borderRadius: BorderRadius.circular(AppConstants.radiusButton),
              border: Border.all(color: isSelected ? ColorTokens.charcoal : ColorTokens.silver),
            ),
            child: Text(
              opt.$2,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : ColorTokens.inkBlack,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
