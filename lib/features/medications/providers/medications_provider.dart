import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../models/adherence_log.dart';
import '../models/medication.dart';

// Real-time stream of active medications for current user
final medicationsStreamProvider = StreamProvider<List<Medication>>((ref) {
  final user = ref.watch(firebaseAuthStateProvider).valueOrNull;
  if (user == null) return const Stream.empty();

  final firestore = ref.watch(firestoreServiceProvider);
  return firestore
      .medicationsCollection(user.uid)
      .where('active', isEqualTo: true)
      .orderBy('name')
      .snapshots()
      .map((snap) => snap.docs.map(Medication.fromFirestore).toList());
});

// Adherence logs for today
final todayLogsProvider = StreamProvider<List<AdherenceLog>>((ref) {
  final user = ref.watch(firebaseAuthStateProvider).valueOrNull;
  if (user == null) return const Stream.empty();

  final firestore = ref.watch(firestoreServiceProvider);
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));

  return firestore
      .adherenceLogsCollection(user.uid)
      .where('scheduledTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
      .where('scheduledTime', isLessThan: Timestamp.fromDate(endOfDay))
      .orderBy('scheduledTime')
      .snapshots()
      .map((snap) => snap.docs.map(AdherenceLog.fromFirestore).toList());
});

// 30-day adherence rate (0.0 – 1.0)
final adherenceRateProvider = FutureProvider<double>((ref) async {
  final user = ref.watch(firebaseAuthStateProvider).valueOrNull;
  if (user == null) return 0.0;

  final firestore = ref.watch(firestoreServiceProvider);
  final since = DateTime.now().subtract(const Duration(days: 30));

  final snap = await firestore
      .adherenceLogsCollection(user.uid)
      .where('scheduledTime', isGreaterThanOrEqualTo: Timestamp.fromDate(since))
      .get();

  if (snap.docs.isEmpty) return 1.0;

  final logs = snap.docs.map(AdherenceLog.fromFirestore).toList();
  final taken = logs.where((l) => l.status == AdherenceStatus.taken).length;
  return taken / logs.length;
});

// Medications CRUD notifier
class MedicationsNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addMedication(Medication med) async {
    final user = ref.read(firebaseAuthStateProvider).valueOrNull;
    if (user == null) throw Exception('Not authenticated');
    final firestore = ref.read(firestoreServiceProvider);
    await firestore.medicationsCollection(user.uid).add(med.toFirestore());
  }

  Future<void> deleteMedication(String medId) async {
    final user = ref.read(firebaseAuthStateProvider).valueOrNull;
    if (user == null) throw Exception('Not authenticated');
    final firestore = ref.read(firestoreServiceProvider);
    await firestore.medicationsCollection(user.uid).doc(medId).update({'active': false});
  }

  Future<void> logDose({
    required String userId,
    required AdherenceLog log,
  }) async {
    final firestore = ref.read(firestoreServiceProvider);
    await firestore.adherenceLogsCollection(userId).add(log.toFirestore());
  }
}

final medicationsNotifierProvider = AsyncNotifierProvider<MedicationsNotifier, void>(MedicationsNotifier.new);
