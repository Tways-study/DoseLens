import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/gemini_service.dart';

final geminiServiceProvider = Provider<GeminiService>((ref) => GeminiService());

// Holds OCR result state
class OcrResult {
  final String? brandName;
  final String? genericName;
  final String? dosage;
  final String? frequency;
  final String? instructions;
  final double? confidence;

  const OcrResult({
    this.brandName,
    this.genericName,
    this.dosage,
    this.frequency,
    this.instructions,
    this.confidence,
  });

  factory OcrResult.fromGemini(Map<String, dynamic> data) {
    return OcrResult(
      brandName: data['brandName'] as String?,
      genericName: data['genericName'] as String?,
      dosage: data['dosage'] as String?,
      frequency: data['frequency'] as String?,
      instructions: data['instructions'] as String?,
      confidence: (data['confidenceScore'] as num?)?.toDouble(),
    );
  }
}

class ScannerNotifier extends AsyncNotifier<OcrResult?> {
  @override
  Future<OcrResult?> build() async => null;

  Future<void> scanImage(Uint8List imageBytes) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final gemini = ref.read(geminiServiceProvider);
      final result = await gemini.scanMedicationLabel(imageBytes);
      return OcrResult.fromGemini(result);
    });
  }

  void reset() {
    state = const AsyncData(null);
  }
}

final scannerProvider = AsyncNotifierProvider<ScannerNotifier, OcrResult?>(ScannerNotifier.new);
