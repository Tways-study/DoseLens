import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/neo_card.dart';
import '../../../core/widgets/pill_chip.dart';
import '../../../core/widgets/primary_action_button.dart';
import '../../../main.dart';
import '../providers/auth_provider.dart';

class RoleSelectionScreen extends ConsumerStatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  ConsumerState<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  UserRole _selectedRole = UserRole.patient;

  Future<void> _continue() async {
    await ref.read(userRoleProvider.notifier).setRole(_selectedRole);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainAppShell()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTokens.icePaper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.space24, vertical: AppConstants.space32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PillChip(
                label: 'Onboarding · Step 1 of 1',
                backgroundColor: ColorTokens.ceruleanBg,
                textColor: ColorTokens.electricCerulean,
                borderColor: ColorTokens.ceruleanBorder,
              ),
              const SizedBox(height: AppConstants.space16),

              Text(
                'Select Your\nExperience.',
                style: TextStyles.displayLarge,
              ),
              const SizedBox(height: AppConstants.space8),
              Text(
                'DoseLens personalizes its interface based on how you manage health.',
                style: TextStyles.bodySecondary,
              ),
              const SizedBox(height: AppConstants.space32),

              _RoleCard(
                role: UserRole.patient,
                title: 'Patient / Self-Managed',
                description: 'Track your daily medication schedule, log doses, scan prescriptions, and generate clinical passports.',
                icon: Icons.person_rounded,
                badge: 'Recommended',
                isSelected: _selectedRole == UserRole.patient,
                onTap: () => setState(() => _selectedRole = UserRole.patient),
              ),
              const SizedBox(height: AppConstants.space16),

              _RoleCard(
                role: UserRole.caregiver,
                title: 'Caregiver / Family Monitor',
                description: 'Monitor loved ones\' adherence in real-time, receive missed dose heartbeat alerts, and review history.',
                icon: Icons.favorite_rounded,
                badge: 'Remote Telemetry',
                isSelected: _selectedRole == UserRole.caregiver,
                onTap: () => setState(() => _selectedRole = UserRole.caregiver),
              ),

              const Spacer(),

              PrimaryActionButton(
                title: 'Enter DoseLens',
                onPressed: _continue,
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
  final String title;
  final String description;
  final IconData icon;
  final String badge;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.title,
    required this.description,
    required this.icon,
    required this.badge,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NeoCard(
      onTap: onTap,
      borderColor: isSelected ? ColorTokens.electricCerulean : ColorTokens.coolHairline,
      backgroundColor: isSelected ? ColorTokens.snow : ColorTokens.snow,
      padding: const EdgeInsets.all(AppConstants.space20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isSelected ? ColorTokens.ceruleanBg : ColorTokens.iceSlate,
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              border: Border.all(color: isSelected ? ColorTokens.electricCerulean : ColorTokens.coolHairline, width: isSelected ? 1.5 : 0.8),
            ),
            child: Icon(icon, color: isSelected ? ColorTokens.electricCerulean : ColorTokens.coolSlate, size: 22),
          ),
          const SizedBox(width: AppConstants.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                    ),
                    PillChip(
                      label: badge,
                      backgroundColor: isSelected ? ColorTokens.ceruleanBg : ColorTokens.iceSlate,
                      textColor: isSelected ? ColorTokens.electricCerulean : ColorTokens.coolSlate,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
