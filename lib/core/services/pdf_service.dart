import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Service to generate Doctor's Visit Clinical Summary & Adherence Passport PDF
class PdfService {
  Future<Uint8List> generateAdherencePassport({
    required String patientName,
    required double adherenceRate,
    required List<Map<String, dynamic>> activeMedications,
    required List<Map<String, dynamic>> adherenceHistory,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'DOSELENS CLINICAL PASSPORT',
                        style: const pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blueGrey900,
                        ),
                      ),
                      pw.Text(
                        'Patient: $patientName',
                        style: const pw.TextStyle(
                          fontSize: 14,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: pw.BoxDecoration(
                      color: adherenceRate >= 0.8
                          ? PdfColors.green50
                          : PdfColors.amber50,
                      borderRadius: pw.BorderRadius.circular(12),
                    ),
                    child: pw.Text(
                      '${(adherenceRate * 100).toStringAsFixed(0)}% Adherence',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: adherenceRate >= 0.8
                            ? PdfColors.green800
                            : PdfColors.amber800,
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 24),
              pw.Divider(color: PdfColors.grey300),
              pw.SizedBox(height: 16),

              // Active Medications Section
              pw.Text(
                'Active Medications',
                style: const pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blueGrey800,
                ),
              ),
              pw.SizedBox(height: 8),

              pw.TableHelper.fromTextArray(
                headers: ['Medication', 'Dosage', 'Frequency', 'Instructions'],
                data: activeMedications
                    .map((med) => [
                          med['name'] ?? '',
                          med['dosage'] ?? '',
                          med['frequency'] ?? '',
                          med['instructions'] ?? '',
                        ])
                    .toList(),
                headerStyle: const pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.grey100),
                cellHeight: 30,
              ),

              pw.SizedBox(height: 24),
              pw.Text(
                'Recent Adherence Log (30 Days)',
                style: const pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blueGrey800,
                ),
              ),
              pw.SizedBox(height: 8),

              pw.TableHelper.fromTextArray(
                headers: ['Date & Time', 'Medication', 'Status'],
                data: adherenceHistory
                    .take(15)
                    .map((log) => [
                          log['time'] ?? '',
                          log['name'] ?? '',
                          log['status'] ?? '',
                        ])
                    .toList(),
                headerStyle: const pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.grey100),
                cellHeight: 28,
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> printPassport(Uint8List pdfData) async {
    await Printing.layoutPdf(onLayout: (_) => pdfData);
  }
}
