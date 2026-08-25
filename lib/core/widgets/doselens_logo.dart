import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/color_tokens.dart';

/// DoseLens Brand Mark — "The Optical Capsule"
/// Unifies the pharmaceutical capsule ("Dose") with the camera aperture iris ("Lens").
/// Rendered as a vector CustomPainter for resolution independence across all screen densities.
class DoseLensLogo extends StatelessWidget {
  final double size;
  final bool showWordmark;
  final TextStyle? wordmarkStyle;
  final Color? primaryColor;
  final Color? accentColor;

  const DoseLensLogo({
    super.key,
    this.size = 36.0,
    this.showWordmark = false,
    this.wordmarkStyle,
    this.primaryColor,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final mark = SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _OpticalCapsulePainter(
          charcoalColor: primaryColor ?? ColorTokens.charcoal,
          cobaltColor: accentColor ?? ColorTokens.cobaltSignal,
          silverColor: ColorTokens.silver,
        ),
      ),
    );

    if (!showWordmark) {
      return mark;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        mark,
        SizedBox(width: size * 0.28),
        RichText(
          text: TextSpan(
            style: wordmarkStyle ??
                GoogleFonts.sen(
                  fontSize: size * 0.65,
                  fontWeight: FontWeight.w700,
                  color: primaryColor ?? ColorTokens.ink,
                  letterSpacing: -0.5,
                ),
            children: [
              const TextSpan(text: 'Dose'),
              TextSpan(
                text: 'Lens',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: primaryColor ?? ColorTokens.graphite,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OpticalCapsulePainter extends CustomPainter {
  final Color charcoalColor;
  final Color cobaltColor;
  final Color silverColor;

  _OpticalCapsulePainter({
    required this.charcoalColor,
    required this.cobaltColor,
    required this.silverColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final w = size.width;
    final h = size.height;

    canvas.save();
    // Rotate canvas by -35 degrees for an energetic angled capsule stance
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-35 * math.pi / 180);
    canvas.translate(-center.dx, -center.dy);

    final capsuleW = w * 0.44;
    final capsuleH = h * 0.88;
    final capsuleRect = Rect.fromCenter(
      center: center,
      width: capsuleW,
      height: capsuleH,
    );
    final radius = capsuleW / 2;
    final rrect = RRect.fromRectAndRadius(capsuleRect, Radius.circular(radius));

    // Outer stroke
    final borderPaint = Paint()
      ..color = charcoalColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.055
      ..isAntiAlias = true;

    // Top half (Solid Dose Body)
    final topHalfPath = Path();
    topHalfPath.addRRect(rrect);

    final clipTopRect = Rect.fromLTRB(
      capsuleRect.left - 5,
      capsuleRect.top - 5,
      capsuleRect.right + 5,
      center.dy,
    );

    canvas.save();
    canvas.clipRect(clipTopRect);
    final solidFill = Paint()
      ..color = charcoalColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawRRect(rrect, solidFill);
    canvas.restore();

    // Dividing waist line
    final waistPaint = Paint()
      ..color = charcoalColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.045
      ..isAntiAlias = true;
    canvas.drawLine(
      Offset(capsuleRect.left, center.dy),
      Offset(capsuleRect.right, center.dy),
      waistPaint,
    );

    // Draw bottom half: Optical Aperture Iris
    final bottomCenter = Offset(center.dx, center.dy + (capsuleH * 0.22));
    final irisRadius = capsuleW * 0.38;

    // Iris circle background
    final irisBgPaint = Paint()
      ..color = ColorTokens.snow
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawCircle(bottomCenter, irisRadius, irisBgPaint);

    // Draw 6 geometric aperture blades around the iris
    final bladePaint = Paint()
      ..color = charcoalColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final bladeStroke = Paint()
      ..color = ColorTokens.snow
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.02
      ..isAntiAlias = true;

    const numBlades = 6;
    for (int i = 0; i < numBlades; i++) {
      final angle = (i * 2 * math.pi / numBlades);
      final p1 = Offset(
        bottomCenter.dx + irisRadius * 0.95 * math.cos(angle),
        bottomCenter.dy + irisRadius * 0.95 * math.sin(angle),
      );
      final p2 = Offset(
        bottomCenter.dx + irisRadius * 0.95 * math.cos(angle + math.pi / 3),
        bottomCenter.dy + irisRadius * 0.95 * math.sin(angle + math.pi / 3),
      );
      final p3 = Offset(
        bottomCenter.dx + irisRadius * 0.35 * math.cos(angle + math.pi / 6),
        bottomCenter.dy + irisRadius * 0.35 * math.sin(angle + math.pi / 6),
      );

      final bladePath = Path()
        ..moveTo(p1.dx, p1.dy)
        ..lineTo(p2.dx, p2.dy)
        ..lineTo(p3.dx, p3.dy)
        ..close();

      canvas.drawPath(bladePath, bladePaint);
      canvas.drawPath(bladePath, bladeStroke);
    }

    // Central Optical Sensor / AI Focus Dot (Cobalt Signal)
    final centerLensPaint = Paint()
      ..color = cobaltColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawCircle(bottomCenter, irisRadius * 0.32, centerLensPaint);

    // Inner optical reflection dot
    final glintPaint = Paint()
      ..color = ColorTokens.snow
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawCircle(
      Offset(bottomCenter.dx - irisRadius * 0.09, bottomCenter.dy - irisRadius * 0.09),
      irisRadius * 0.09,
      glintPaint,
    );

    // Outer Capsule Outline
    canvas.drawRRect(rrect, borderPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _OpticalCapsulePainter oldDelegate) =>
      oldDelegate.charcoalColor != charcoalColor ||
      oldDelegate.cobaltColor != cobaltColor ||
      oldDelegate.silverColor != silverColor;
}
