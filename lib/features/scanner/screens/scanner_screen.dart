import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/color_tokens.dart';
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
    _pulse = Tween<double>(begin: 0.92, end: 1.0).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
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
          SnackBar(content: Text('Scan failed: ${e.toString()}'), backgroundColor: ColorTokens.alertCoral),
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
          SnackBar(content: Text('Processing failed: ${e.toString()}'), backgroundColor: ColorTokens.alertCoral),
        );
      }
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Dark background for scanner feel
          Container(
            color: const Color(0xFF0A0A0A),
          ),

          // Scanner frame overlay
          Center(
            child: ScaleTransition(
              scale: _pulse,
              child: CustomPaint(
                size: const Size(280, 280),
                painter: _ScannerFramePainter(),
                child: SizedBox(
                  width: 280,
                  height: 280,
                  child: _processing
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: ColorTokens.primaryTeal, strokeWidth: 2),
                              SizedBox(height: 16),
                              Text('Analyzing label...', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.medication_liquid_rounded, color: Colors.white38, size: 40),
                              SizedBox(height: 12),
                              Text('Point at medication label', style: TextStyle(color: Colors.white60, fontSize: 13), textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ),

          // Frosted info banner
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black87, Colors.transparent],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text('Medication Scanner', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(32, 32, 32, 48),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black87, Colors.transparent],
                ),
              ),
              child: Column(
                children: [
                  const Text('Position the label within the frame', style: TextStyle(color: Colors.white60, fontSize: 13)),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Gallery
                      GestureDetector(
                        onTap: _processing ? null : _pickFromGallery,
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Icon(Icons.photo_library_outlined, color: Colors.white, size: 22),
                        ),
                      ),

                      // Capture button
                      GestureDetector(
                        onTap: _processing ? null : _captureImage,
                        child: Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _processing ? Colors.white30 : Colors.white,
                            border: Border.all(color: Colors.white38, width: 4),
                          ),
                          child: _processing
                              ? const SizedBox.shrink()
                              : const Icon(Icons.camera_alt_rounded, color: ColorTokens.primarySlate, size: 32),
                        ),
                      ),

                      // Placeholder for symmetry
                      const SizedBox(width: 52),
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

/// Custom corner-bracket scanner frame painter
class _ScannerFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorTokens.primaryTeal
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLen = 28.0;
    const r = 8.0;

    final path = Path();

    // Top-left
    path.moveTo(r, cornerLen);
    path.lineTo(r, r);
    path.arcToPoint(Offset(r + r, 0), radius: const Radius.circular(r));
    path.lineTo(cornerLen, 0);

    // Top-right
    path.moveTo(size.width - cornerLen, 0);
    path.lineTo(size.width - r, 0);
    path.arcToPoint(Offset(size.width, r), radius: const Radius.circular(r));
    path.lineTo(size.width, cornerLen);

    // Bottom-right
    path.moveTo(size.width, size.height - cornerLen);
    path.lineTo(size.width, size.height - r);
    path.arcToPoint(Offset(size.width - r, size.height), radius: const Radius.circular(r));
    path.lineTo(size.width - cornerLen, size.height);

    // Bottom-left
    path.moveTo(cornerLen, size.height);
    path.lineTo(r, size.height);
    path.arcToPoint(Offset(0, size.height - r), radius: const Radius.circular(r));
    path.lineTo(0, size.height - cornerLen);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
