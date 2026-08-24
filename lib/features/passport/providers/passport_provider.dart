import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/pdf_service.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../features/medications/models/adherence_log.dart';
import '../../../features/medications/providers/medications_provider.dart';

final pdfServiceProvider = Provider<PdfService>((ref) => PdfService());

// 30-day adherence logs
final thirtyDayLogsProvider = FutureProvider<List<AdherenceLog>>((ref) async {
  final user = ref.watch(firebaseAuthStateProvider).valueOrNull;
  if (user == null) return [];
  final firestore = ref.watch(firestoreServiceProvider);
  final since = DateTime.now().subtract(const Duration(days: 30));
  final snap = await firestore
      .adherenceLogsCollection(user.uid)
      .where('scheduledTime', isGreaterThanOrEqualTo: Timestamp.fromDate(since))
      .orderBy('scheduledTime', descending: true)
      .get();
  return snap.docs.map(AdherenceLog.fromFirestore).toList();
});

// PDF generation notifier
class PassportNotifier extends AsyncNotifier<Uint8List?> {
  @override
  Future<Uint8List?> build() async => null;

  Future<void> generatePdf() async {
    final user = ref.read(firebaseAuthStateProvider).valueOrNull;
    if (user == null) throw Exception('Not authenticated');

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final meds = ref.read(medicationsStreamProvider).valueOrNull ?? [];
      final logs = await ref.read(thirtyDayLogsProvider.future);
      final rate = await ref.read(adherenceRateProvider.future);

      final pdfService = ref.read(pdfServiceProvider);
      return pdfService.generateAdherencePassport(
        patientName: user.displayName ?? user.email ?? 'Patient',
        adherenceRate: rate,
        activeMedications: meds
            .map((m) => {'name': m.name, 'dosage': m.dosage, 'frequency': m.frequencyLabel, 'instructions': m.instructions ?? ''})
            .toList(),
        adherenceHistory: logs
            .map((l) => {
                  'time': '${l.scheduledTime.month}/${l.scheduledTime.day} ${l.scheduledTime.hour}:${l.scheduledTime.minute.toString().padLeft(2, '0')}',
                  'name': l.medicationName,
                  'status': l.status.name[0].toUpperCase() + l.status.name.substring(1),
                })
            .toList(),
      );
    });
  }
}

final passportProvider = AsyncNotifierProvider<PassportNotifier, Uint8List?>(PassportNotifier.new);
