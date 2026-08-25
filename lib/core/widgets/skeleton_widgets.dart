import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/color_tokens.dart';

/// A single shimmer-animated rectangle using a Flutter-native gradient animation.
/// All skeleton composites in this file are built from [SkeletonBox].
class SkeletonBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonBox({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = AppConstants.radiusButton,
  });

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              ColorTokens.fog,
              Color.lerp(ColorTokens.fog, ColorTokens.mist, _anim.value)!,
              ColorTokens.fog,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }
}

// ─── Composed Skeletons ──────────────────────────────────────────────────────

/// Matches the hero adherence card on HomeScreen (110px image + metric row).
class SkeletonAdherenceCard extends StatelessWidget {
  const SkeletonAdherenceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorTokens.snow,
        borderRadius: BorderRadius.circular(AppConstants.radiusCard),
        border: Border.all(color: ColorTokens.coolHairline),
        boxShadow: const [ColorTokens.cardShadow],
      ),
      child: const Column(
        children: [
          // Image banner placeholder
          ClipRRect(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppConstants.radiusCard)),
            child: SkeletonBox(height: 110, borderRadius: 0),
          ),
          // Metric row
          Padding(
            padding: EdgeInsets.fromLTRB(
                AppConstants.space20, AppConstants.space12,
                AppConstants.space20, AppConstants.space16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(width: 120, height: 11),
                    SizedBox(height: 8),
                    SkeletonBox(width: 72, height: 42),
                  ],
                ),
                SkeletonBox(width: 56, height: 56, borderRadius: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Matches a single medication row card on HomeScreen timeline.
class SkeletonMedCard extends StatelessWidget {
  const SkeletonMedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.space20),
      decoration: BoxDecoration(
        color: ColorTokens.snow,
        borderRadius: BorderRadius.circular(AppConstants.radiusCard),
        border: Border.all(color: ColorTokens.coolHairline),
        boxShadow: const [ColorTokens.cardShadow],
      ),
      child: const Row(
        children: [
          // Icon box
          SkeletonBox(width: 46, height: 46, borderRadius: AppConstants.radiusMedium),
          SizedBox(width: AppConstants.space16),
          // Text lines
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(height: 13),
                SizedBox(height: 6),
                SkeletonBox(width: 140, height: 11),
              ],
            ),
          ),
          SizedBox(width: AppConstants.space12),
          // Badge
          SkeletonBox(width: 56, height: 22, borderRadius: AppConstants.radiusFull),
        ],
      ),
    );
  }
}

/// Matches a compact medication row in PassportScreen (Active Regimen list).
class SkeletonPassportMedRow extends StatelessWidget {
  const SkeletonPassportMedRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.space16, vertical: AppConstants.space12),
      decoration: BoxDecoration(
        color: ColorTokens.snow,
        borderRadius: BorderRadius.circular(AppConstants.radiusCard),
        border: Border.all(color: ColorTokens.coolHairline),
        boxShadow: const [ColorTokens.cardShadow],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(width: 110, height: 13),
              SizedBox(height: 5),
              SkeletonBox(width: 80, height: 10),
            ],
          ),
          SkeletonBox(width: 64, height: 24, borderRadius: AppConstants.radiusButton),
        ],
      ),
    );
  }
}

/// Matches an adherence log row in PassportScreen (Adherence Feed).
class SkeletonLogRow extends StatelessWidget {
  const SkeletonLogRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.space16, vertical: AppConstants.space10),
      decoration: BoxDecoration(
        color: ColorTokens.snow,
        borderRadius: BorderRadius.circular(AppConstants.radiusCard),
        border: Border.all(color: ColorTokens.coolHairline),
        boxShadow: const [ColorTokens.cardShadow],
      ),
      child: const Row(
        children: [
          // Status badge placeholder
          SkeletonBox(width: 54, height: 22, borderRadius: AppConstants.radiusFull),
          SizedBox(width: AppConstants.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(height: 12),
                SizedBox(height: 5),
                SkeletonBox(width: 100, height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Matches a patient monitor card in CaregiverDashboard.
class SkeletonPatientCard extends StatelessWidget {
  const SkeletonPatientCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.space20),
      decoration: BoxDecoration(
        color: ColorTokens.snow,
        borderRadius: BorderRadius.circular(AppConstants.radiusCard),
        border: Border.all(color: ColorTokens.coolHairline),
        boxShadow: const [ColorTokens.cardShadow],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonBox(width: 38, height: 38, borderRadius: AppConstants.radiusMedium),
              SizedBox(width: AppConstants.space10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(height: 13),
                    SizedBox(height: 5),
                    SkeletonBox(width: 100, height: 10),
                  ],
                ),
              ),
              SizedBox(width: AppConstants.space12),
              SkeletonBox(width: 80, height: 24, borderRadius: AppConstants.radiusFull),
            ],
          ),
          SizedBox(height: AppConstants.space16),
          SkeletonBox(height: 40, borderRadius: AppConstants.radiusMedium),
        ],
      ),
    );
  }
}

/// Generic full-width card skeleton of configurable height.
class SkeletonCard extends StatelessWidget {
  final double height;
  const SkeletonCard({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(height: height, borderRadius: AppConstants.radiusCard);
  }
}
