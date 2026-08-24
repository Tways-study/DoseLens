import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/firebase_constants.dart';

/// Cloud Firestore database service wrapper
class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get usersCollection =>
      _firestore.collection(FirebaseCollections.users);

  CollectionReference<Map<String, dynamic>> medicationsCollection(String userId) =>
      usersCollection.doc(userId).collection(FirebaseCollections.medications);

  CollectionReference<Map<String, dynamic>> adherenceLogsCollection(String userId) =>
      usersCollection.doc(userId).collection(FirebaseCollections.adherenceLogs);

  CollectionReference<Map<String, dynamic>> get caregiverLinksCollection =>
      _firestore.collection(FirebaseCollections.caregiverLinks);
}
