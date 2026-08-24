import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/firestore_service.dart';
import '../models/app_user.dart';

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

// Convenience: current user's role
final userRoleProvider = Provider<UserRole?>((ref) {
  return ref.watch(appUserProvider).valueOrNull?.role;
});
