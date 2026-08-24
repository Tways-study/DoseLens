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
    _pulse = Tween<double>(begin: 0.95, end: 1.0).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
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
          SnackBar(content: Text('Scan failed: ${e.toString()}'), backgroundColor: ColorTokens.vermillion),
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
          SnackBar(content: Text('Processing failed: ${e.toString()}'), backgroundColor: ColorTokens.vermillion),
        );
      }
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTokens.obsidian,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Multimodal OCR Lens',
          style: TextStyles.headingMedium.copyWith(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          // Reticle Viewfinder
          Center(
            child: ScaleTransition(
              scale: _pulse,
              child: CustomPaint(
                size: const Size(270, 270),
                painter: _CraftworkScannerFramePainter(),
                child: SizedBox(
                  width: 270,
                  height: 270,
                  child: _processing
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: ColorTokens.acidGreen, strokeWidth: 3.0),
                              SizedBox(height: 16),
                              Text(
                                'Extracting packaging metadata...',
                                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
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
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                                  border: Border.all(color: ColorTokens.acidGreen.withValues(alpha: 0.5)),
                                ),
                                child: const Icon(Icons.qr_code_scanner_rounded, color: ColorTokens.acidGreen, size: 28),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Align drug label inside frame',
                                style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ),

          // Bottom Control Panel (Snow Surface)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(AppConstants.space24, AppConstants.space20, AppConstants.space24, 36),
              decoration: const BoxDecoration(
                color: ColorTokens.snow,
                borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.radiusCard)),
                border: Border(top: BorderSide(color: ColorTokens.hairline)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: ColorTokens.acidGreen, shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      Text('Gemini 2.0 Flash Vision', style: TextStyles.headingMedium.copyWith(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Extracts brand, active generic ingredient, dosage, and frequency.',
                    style: TextStyles.caption,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.space16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.photo_library_outlined, size: 18, color: ColorTokens.inkBlack),
                          label: const Text('Gallery', style: TextStyle(color: ColorTokens.inkBlack, fontWeight: FontWeight.w700)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: ColorTokens.hairline, width: 1.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusButton)),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                          ),
                          onPressed: _processing ? null : _pickFromGallery,
                        ),
                      ),
                      const SizedBox(width: AppConstants.space12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.camera_alt_rounded, size: 18, color: ColorTokens.inkBlack),
                          label: const Text('Scan Label', style: TextStyle(color: ColorTokens.inkBlack, fontWeight: FontWeight.w800)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorTokens.acidGreen,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusButton)),
                            padding: const EdgeInsets.symmetric(vertical: 13),
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

class _CraftworkScannerFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorTokens.acidGreen
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLength = 24.0;
    const r = 14.0;

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
  bool shouldRepaint(_CraftworkScannerFramePainter old) => false;
}
