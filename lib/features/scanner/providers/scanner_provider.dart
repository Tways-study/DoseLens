import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/gemini_service.dart';
import '../models/ocr_result.dart';

export '../models/ocr_result.dart';

final geminiServiceProvider = Provider<GeminiService>((ref) => GeminiService());

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
