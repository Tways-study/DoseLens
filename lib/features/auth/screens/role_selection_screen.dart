import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/color_tokens.dart';
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
      // Navigation handled by auth stream listener in main.dart
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
      backgroundColor: ColorTokens.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How will you use DoseLens?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: ColorTokens.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This helps us personalize your experience.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColorTokens.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 40),

              _RoleCard(
                role: UserRole.patient,
                selected: _selected == UserRole.patient,
                icon: Icons.medication_liquid_rounded,
                title: 'I\'m a Patient',
                description: 'Scan medications, track daily doses, and generate your health passport.',
                onTap: () => setState(() => _selected = UserRole.patient),
              ),
              const SizedBox(height: 16),

              _RoleCard(
                role: UserRole.caregiver,
                selected: _selected == UserRole.caregiver,
                icon: Icons.favorite_rounded,
                title: 'I\'m a Caregiver',
                description: 'Monitor a loved one\'s adherence and receive real-time missed dose alerts.',
                onTap: () => setState(() => _selected = UserRole.caregiver),
              ),

              const Spacer(),
              PrimaryActionButton(
                title: 'Get Started',
                isLoading: _loading,
                onPressed: _selected != null ? _confirm : null,
                backgroundColor: _selected != null ? ColorTokens.primarySlate : ColorTokens.borderLight,
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
      borderColor: selected ? ColorTokens.primaryTeal : ColorTokens.borderLight,
      backgroundColor: selected ? const Color(0xFFF0FDFA) : Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: selected ? ColorTokens.primaryTeal : ColorTokens.backgroundSecondaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: selected ? Colors.white : ColorTokens.textSecondaryLight, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: ColorTokens.textPrimaryLight)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(fontSize: 13, color: ColorTokens.textSecondaryLight, height: 1.5)),
              ],
            ),
          ),
          if (selected) ...[
            const SizedBox(width: 12),
            const Icon(Icons.check_circle_rounded, color: ColorTokens.primaryTeal, size: 20),
          ],
        ],
      ),
    );
  }
}
