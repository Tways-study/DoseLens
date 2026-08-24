import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// Firebase Storage wrapper service
class StorageService {
  final FirebaseStorage _storage;

  StorageService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  Future<String> uploadFile({
    required String path,
    required File file,
    SettableMetadata? metadata,
  }) async {
    final ref = _storage.ref().child(path);
    final uploadTask = await ref.putFile(file, metadata);
    return await uploadTask.ref.getDownloadURL();
  }

  Future<void> deleteFile(String path) async {
    final ref = _storage.ref().child(path);
    await ref.delete();
  }
}
