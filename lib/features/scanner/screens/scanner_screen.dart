import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/theme/text_styles.dart';
import '../providers/scanner_provider.dart';
import 'ocr_verification_sheet.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen>
    with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  bool _processing = false;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.94, end: 1.0).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  Future<void> _captureImage() async {
    try {
      final file = await _picker.pickImage(source: ImageSource.camera, imageQuality: 90, maxWidth: 1920);
      if (file == null) return;
      HapticFeedback.mediumImpact();
      setState(() => _processing = true);
      final bytes = await File(file.path).readAsBytes();
      await ref.read(scannerProvider.notifier).scanImage(bytes);

      if (mounted) {
        final result = ref.read(scannerProvider).valueOrNull;
        if (result != null) {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => OcrVerificationSheet(result: result),
          );
          ref.read(scannerProvider.notifier).reset();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Scan failed: ${e.toString()}'), backgroundColor: ColorTokens.ember),
        );
      }
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 90, maxWidth: 1920);
      if (file == null) return;
      setState(() => _processing = true);
      final bytes = await File(file.path).readAsBytes();
      await ref.read(scannerProvider.notifier).scanImage(bytes);

      if (mounted) {
        final result = ref.read(scannerProvider).valueOrNull;
        if (result != null) {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => OcrVerificationSheet(result: result),
          );
          ref.read(scannerProvider.notifier).reset();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Processing failed: ${e.toString()}'), backgroundColor: ColorTokens.ember),
        );
      }
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1012),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Scan Medication',
          style: TextStyles.headingMedium.copyWith(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          // Viewfinder Frame
          Center(
            child: ScaleTransition(
              scale: _pulse,
              child: CustomPaint(
                size: const Size(280, 280),
                painter: _ReferoScannerFramePainter(),
                child: SizedBox(
                  width: 280,
                  height: 280,
                  child: _processing
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: ColorTokens.electricBlue, strokeWidth: 2.5),
                              SizedBox(height: 16),
                              Text(
                                'Extracting drug data...',
                                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                                ),
                                child: const Icon(Icons.medication_rounded, color: Colors.white70, size: 28),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Align label inside the frame',
                                style: TextStyles.caption.copyWith(color: Colors.white70),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ),

          // Bottom Control Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(AppConstants.space28, AppConstants.space20, AppConstants.space28, 40),
              decoration: BoxDecoration(
                color: ColorTokens.paper,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppConstants.radiusCard)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Multimodal OCR Vision',
                    style: TextStyles.headingMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Extracts brand, generic name, strength, and frequency automatically.',
                    style: TextStyles.caption,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.space20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.photo_library_outlined, size: 18, color: ColorTokens.primaryInk),
                          label: const Text('Gallery', style: TextStyle(color: ColorTokens.primaryInk, fontWeight: FontWeight.w600)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: ColorTokens.hairline),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusPill)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _processing ? null : _pickFromGallery,
                        ),
                      ),
                      const SizedBox(width: AppConstants.space12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.camera_alt_rounded, size: 18, color: Colors.white),
                          label: const Text('Capture', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorTokens.electricBlue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusPill)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _processing ? null : _captureImage,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReferoScannerFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorTokens.electricBlue
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLength = 28.0;
    const r = 24.0;

    // Top-left
    canvas.drawPath(
      Path()
        ..moveTo(0, cornerLength)
        ..lineTo(0, r)
        ..arcToPoint(const Offset(r, 0), radius: const Radius.circular(r))
        ..lineTo(cornerLength, 0),
      paint,
    );

    // Top-right
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerLength, 0)
        ..lineTo(size.width - r, 0)
        ..arcToPoint(Offset(size.width, r), radius: const Radius.circular(r))
        ..lineTo(size.width, cornerLength),
      paint,
    );

    // Bottom-left
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height - cornerLength)
        ..lineTo(0, size.height - r)
        ..arcToPoint(Offset(r, size.height), radius: const Radius.circular(r))
        ..lineTo(cornerLength, size.height),
      paint,
    );

    // Bottom-right
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerLength, size.height)
        ..lineTo(size.width - r, size.height)
        ..arcToPoint(Offset(size.width, size.height - r), radius: const Radius.circular(r))
        ..lineTo(size.width, size.height - cornerLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(_ReferoScannerFramePainter old) => false;
}
