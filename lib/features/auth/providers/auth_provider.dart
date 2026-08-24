import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/firestore_service.dart';
import '../models/app_user.dart';

export '../models/app_user.dart' show UserRole, AppUser;

// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final firestoreServiceProvider = Provider<FirestoreService>((ref) => FirestoreService());

// Raw Firebase auth state stream
final firebaseAuthStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

// Resolved AppUser stream (includes Firestore role)
final appUserProvider = StreamProvider<AppUser?>((ref) async* {
  final authState = ref.watch(firebaseAuthStateProvider);
  final firestore = ref.watch(firestoreServiceProvider);

  final firebaseUser = authState.valueOrNull;
  if (firebaseUser == null) {
    yield null;
    return;
  }

  yield* firestore.usersCollection
      .doc(firebaseUser.uid)
      .snapshots()
      .map((snap) {
    if (!snap.exists || snap.data() == null) return null;
    return AppUser.fromFirestore(snap.data()!, snap.id);
  });
});

// Auth actions notifier
class AuthNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final auth = ref.read(authServiceProvider);
      await auth.signInWithEmailPassword(email: email, password: password);
    });
    if (state.hasError) throw state.error!;
  }

  Future<void> signUpWithEmail(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final auth = ref.read(authServiceProvider);
      final cred = await auth.signUpWithEmailPassword(email: email, password: password);
      if (cred.user != null) {
        final firestore = ref.read(firestoreServiceProvider);
        await firestore.usersCollection.doc(cred.user!.uid).set({
          'uid': cred.user!.uid,
          'email': email,
          'role': UserRole.patient.name,
          'createdAt': DateTime.now(),
        });
      }
    });
    if (state.hasError) throw state.error!;
  }

  Future<void> signInAnonymously() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final auth = ref.read(authServiceProvider);
      await auth.signInAnonymously();
    });
    if (state.hasError) throw state.error!;
  }

  Future<void> signOut() async {
    await ref.read(authServiceProvider).signOut();
  }
}

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, void>(AuthNotifier.new);

// User role notifier
class UserRoleNotifier extends Notifier<UserRole> {
  @override
  UserRole build() => UserRole.patient;

  Future<void> setRole(UserRole role) async {
    state = role;
    final user = ref.read(firebaseAuthStateProvider).valueOrNull;
    if (user != null) {
      final firestore = ref.read(firestoreServiceProvider);
      await firestore.usersCollection.doc(user.uid).set(
        {'role': role.name},
        SetOptions(merge: true),
      );
    }
  }
}

final userRoleProvider = NotifierProvider<UserRoleNotifier, UserRole>(UserRoleNotifier.new);
