/// Structured data model extracted from medication label OCR by Gemini
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

  Map<String, dynamic> toJson() => {
        'brandName': brandName,
        'genericName': genericName,
        'dosage': dosage,
        'frequency': frequency,
        'instructions': instructions,
        'confidenceScore': confidence,
      };
}
