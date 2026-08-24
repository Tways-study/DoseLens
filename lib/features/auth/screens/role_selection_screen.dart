import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/neo_card.dart';
import '../../../core/widgets/primary_action_button.dart';
import '../models/app_user.dart';
import '../providers/auth_provider.dart';

class RoleSelectionScreen extends ConsumerStatefulWidget {
  final String uid;
  final String email;
  final String displayName;

  const RoleSelectionScreen({
    super.key,
    required this.uid,
    required this.email,
    required this.displayName,
  });

  @override
  ConsumerState<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  UserRole? _selected;
  bool _loading = false;

  Future<void> _confirm() async {
    if (_selected == null) return;
    setState(() => _loading = true);
    try {
      final firestore = ref.read(firestoreServiceProvider);
      final user = AppUser(
        uid: widget.uid,
        email: widget.email,
        displayName: widget.displayName,
        role: _selected!,
        createdAt: DateTime.now(),
      );
      await firestore.usersCollection
          .doc(widget.uid)
          .set({...user.toFirestore(), 'createdAt': FieldValue.serverTimestamp()});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save role. Please try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTokens.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.space28, vertical: AppConstants.space32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Personalize.',
                style: TextStyles.displayLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Select your primary role to configure your daily experience.',
                style: TextStyles.bodySecondary,
              ),
              const SizedBox(height: 36),

              _RoleCard(
                role: UserRole.patient,
                selected: _selected == UserRole.patient,
                icon: Icons.medication_liquid_rounded,
                title: "I'm a Patient",
                description: 'Scan medication packaging, track daily adherence, and export 30-day health passports.',
                onTap: () => setState(() => _selected = UserRole.patient),
              ),
              const SizedBox(height: 16),

              _RoleCard(
                role: UserRole.caregiver,
                selected: _selected == UserRole.caregiver,
                icon: Icons.favorite_rounded,
                title: "I'm a Caregiver",
                description: 'Monitor family members remotely with real-time missed dose heartbeat alerts.',
                onTap: () => setState(() => _selected = UserRole.caregiver),
              ),

              const Spacer(),
              PrimaryActionButton(
                title: 'Continue',
                isLoading: _loading,
                onPressed: _selected != null ? _confirm : null,
                backgroundColor: _selected != null ? ColorTokens.electricBlue : ColorTokens.coolWash,
                textColor: _selected != null ? Colors.white : ColorTokens.midGray,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final UserRole role;
  final bool selected;
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.selected,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NeoCard(
      onTap: onTap,
      borderRadius: AppConstants.radiusCard,
      borderColor: selected ? ColorTokens.electricBlue : ColorTokens.hairline,
      backgroundColor: selected ? const Color(0xFFF0F7FF) : ColorTokens.paper,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: selected ? ColorTokens.electricBlue : ColorTokens.coolWash,
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            ),
            child: Icon(
              icon,
              color: selected ? Colors.white : ColorTokens.primaryInk,
              size: 22,
            ),
          ),
          const SizedBox(width: AppConstants.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.headingMedium.copyWith(
                    color: selected ? ColorTokens.electricBlue : ColorTokens.primaryInk,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyles.bodySecondary.copyWith(fontSize: 13, height: 1.45),
                ),
              ],
            ),
          ),
          if (selected) ...[
            const SizedBox(width: 8),
            const Icon(Icons.check_circle_rounded, color: ColorTokens.electricBlue, size: 20),
          ],
        ],
      ),
    );
  }
}
