/// API endpoints and network configuration constants
class ApiConstants {
  ApiConstants._();

  // Google Gemini Vision API
  static const String geminiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  static const String geminiFlashModel = 'gemini-2.0-flash';
  static const String geminiVisionEndpoint = '$geminiBaseUrl/models/$geminiFlashModel:generateContent';

  // OpenFDA Public Drug Label API (Keyless public endpoints)
  static const String openFdaBaseUrl = 'https://api.fda.gov/drug/label.json';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
