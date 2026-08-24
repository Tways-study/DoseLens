import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../firebase_options.dart';

/// Central initialization service for Firebase
class FirebaseService {
  FirebaseService._();

  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
