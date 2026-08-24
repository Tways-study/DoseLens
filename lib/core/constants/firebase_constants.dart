/// Firebase collection names and storage paths for DoseLens
class FirebaseCollections {
  FirebaseCollections._();

  static const String users = 'users';
  static const String medications = 'medications';
  static const String adherenceLogs = 'adherence_logs';
  static const String caregiverLinks = 'caregiver_links';
  static const String passports = 'passports';
}

class FirebaseStoragePaths {
  FirebaseStoragePaths._();

  static String medicationLabels(String userId, String medId) =>
      'users/$userId/medications/$medId/label.jpg';

  static String prescriptionScans(String userId, String scanId) =>
      'users/$userId/prescriptions/$scanId.jpg';

  static String passportPdf(String userId, String passportId) =>
      'users/$userId/passports/$passportId.pdf';
}
