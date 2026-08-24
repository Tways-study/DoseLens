import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/firebase_constants.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../features/medications/models/adherence_log.dart';
import '../models/caregiver_link.dart';

// Links where current user is the caregiver
final myLinkedPatientsProvider = StreamProvider<List<CaregiverLink>>((ref) {
  final user = ref.watch(firebaseAuthStateProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  final firestore = ref.watch(firestoreServiceProvider);
  return firestore.caregiverLinksCollection
      .where('caregiverId', isEqualTo: user.uid)
      .where('status', isEqualTo: 'active')
      .snapshots()
      .map((s) => s.docs.map(CaregiverLink.fromFirestore).toList());
});

// Links where current user is the patient (who has caregivers)
final myCaregiversProvider = StreamProvider<List<CaregiverLink>>((ref) {
  final user = ref.watch(firebaseAuthStateProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  final firestore = ref.watch(firestoreServiceProvider);
  return firestore.caregiverLinksCollection
      .where('patientId', isEqualTo: user.uid)
      .snapshots()
      .map((s) => s.docs.map(CaregiverLink.fromFirestore).toList());
});

// Missed doses for a specific patient (last 24 hours) — used by caregiver
final patientMissedDosesProvider = StreamProvider.family<List<AdherenceLog>, String>((ref, patientId) {
  final firestore = ref.watch(firestoreServiceProvider);
  final since = DateTime.now().subtract(const Duration(hours: 24));
  return firestore
      .adherenceLogsCollection(patientId)
      .where('status', isEqualTo: 'missed')
      .where('scheduledTime', isGreaterThanOrEqualTo: Timestamp.fromDate(since))
      .orderBy('scheduledTime', descending: true)
      .snapshots()
      .map((s) => s.docs.map(AdherenceLog.fromFirestore).toList());
});

// Caregiver CRUD notifier
class CaregiverNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> inviteCaregiver({required String patientId, required String caregiverEmail}) async {
    // In a real app: look up caregiver by email, create link doc
    final firestore = ref.read(firestoreServiceProvider);
    await firestore.caregiverLinksCollection.add({
      'patientId': patientId,
      'caregiverId': '', // to be filled when caregiver accepts
      'caregiverEmail': caregiverEmail,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> revokeLink(String linkId) async {
    final firestore = ref.read(firestoreServiceProvider);
    await firestore.caregiverLinksCollection
        .doc(linkId)
        .update({'status': CaregiverLinkStatus.revoked.name});
  }
}

final caregiverNotifierProvider = AsyncNotifierProvider<CaregiverNotifier, void>(CaregiverNotifier.new);
