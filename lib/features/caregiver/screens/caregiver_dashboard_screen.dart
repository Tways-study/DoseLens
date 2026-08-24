import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/neo_card.dart';
import '../../../core/widgets/pill_chip.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../models/caregiver_link.dart';
import '../providers/caregiver_provider.dart';

class CaregiverDashboardScreen extends ConsumerWidget {
  const CaregiverDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(userRoleProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ColorTokens.backgroundLight,
        appBar: AppBar(
          title: const Text('Caregiver', style: TextStyle(fontWeight: FontWeight.w700, color: ColorTokens.textPrimaryLight)),
          bottom: const TabBar(
            indicatorColor: ColorTokens.primaryTeal,
            labelColor: ColorTokens.primaryTeal,
            unselectedLabelColor: ColorTokens.textSecondaryLight,
            tabs: [
              Tab(text: 'Patients I Monitor'),
              Tab(text: 'My Caregivers'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _CaregiverView(),
            _PatientView(),
          ],
        ),
      ),
    );
  }
}

// ─── Caregiver View: Monitor linked patients ──────────────────────────────────

class _CaregiverView extends ConsumerWidget {
  const _CaregiverView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final linksAsync = ref.watch(myLinkedPatientsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          linksAsync.when(
            loading: () => const Center(child: CircularProgressIndicator(color: ColorTokens.primaryTeal)),
            error: (e, _) => _ErrorBanner(message: e.toString()),
            data: (links) {
              if (links.isEmpty) {
                return const _EmptyState(
                  icon: Icons.favorite_border_rounded,
                  title: 'No patients linked yet',
                  subtitle: 'Ask the patient to add you as a caregiver from the "My Caregivers" tab.',
                );
              }
              return Column(
                children: links.map((link) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _PatientMonitorCard(link: link),
                )).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PatientMonitorCard extends ConsumerWidget {
  final CaregiverLink link;
  const _PatientMonitorCard({required this.link});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missedAsync = ref.watch(patientMissedDosesProvider(link.patientId));

    return NeoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Patient header
          Row(
            children: [
              CircleAvatar(
                backgroundColor: ColorTokens.primaryTeal.withValues(alpha: 0.1),
                child: const Icon(Icons.person_rounded, color: ColorTokens.primaryTeal, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Patient ID: ...${link.patientId.substring(link.patientId.length > 8 ? link.patientId.length - 8 : 0)}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ColorTokens.textPrimaryLight)),
                    Text('Linked since ${DateFormatters.formatDate(link.createdAt)}',
                        style: const TextStyle(fontSize: 12, color: ColorTokens.textMutedLight)),
                  ],
                ),
              ),
              PillChip(
                label: 'Active',
                backgroundColor: ColorTokens.mintSuccessBg,
                textColor: ColorTokens.mintSuccess,
                borderColor: ColorTokens.mintSuccessBorder,
              ),
            ],
          ),

          // Missed doses in last 24h
          const SizedBox(height: 16),
          missedAsync.when(
            loading: () => const LinearProgressIndicator(color: ColorTokens.primaryTeal, minHeight: 2),
            error: (_, __) => const SizedBox.shrink(),
            data: (missed) {
              if (missed.isEmpty) {
                return Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: ColorTokens.mintSuccess, size: 16),
                    const SizedBox(width: 8),
                    const Text('No missed doses in the last 24 hours', style: TextStyle(fontSize: 13, color: ColorTokens.mintSuccess, fontWeight: FontWeight.w500)),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: ColorTokens.alertCoral, size: 16),
                      const SizedBox(width: 8),
                      Text('${missed.length} missed dose${missed.length > 1 ? 's' : ''} in 24h',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: ColorTokens.alertCoral)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...missed.take(3).map((log) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: ColorTokens.alertCoralBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: ColorTokens.alertCoralBorder),
                      ),
                      child: Row(
                        children: [
                          const StatusBadge(status: AdherenceStatus.missed),
                          const SizedBox(width: 10),
                          Expanded(child: Text(log.medicationName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: ColorTokens.textPrimaryLight))),
                          Text(DateFormatters.formatTime(log.scheduledTime), style: const TextStyle(fontSize: 12, color: ColorTokens.textSecondaryLight)),
                        ],
                      ),
                    ),
                  )),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─── Patient View: Manage my caregivers ───────────────────────────────────────

class _PatientView extends ConsumerWidget {
  const _PatientView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final linksAsync = ref.watch(myCaregiversProvider);
    final user = ref.watch(firebaseAuthStateProvider).valueOrNull;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          NeoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Invite a Caregiver', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: ColorTokens.textPrimaryLight)),
                const SizedBox(height: 4),
                const Text('Share access with a trusted person to monitor your doses.', style: TextStyle(fontSize: 13, color: ColorTokens.textSecondaryLight)),
                const SizedBox(height: 16),
                _InviteButton(patientId: user?.uid ?? ''),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SectionHeader(title: 'My Caregivers', subtitle: 'People who can see your adherence'),
          const SizedBox(height: 12),
          linksAsync.when(
            loading: () => const Center(child: CircularProgressIndicator(color: ColorTokens.primaryTeal)),
            error: (e, _) => _ErrorBanner(message: e.toString()),
            data: (links) {
              if (links.isEmpty) {
                return const _EmptyState(
                  icon: Icons.group_outlined,
                  title: 'No caregivers yet',
                  subtitle: 'Invite someone to help monitor your medication adherence.',
                );
              }
              return Column(
                children: links.map((link) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _CaregiverLinkCard(link: link),
                )).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _InviteButton extends ConsumerStatefulWidget {
  final String patientId;
  const _InviteButton({required this.patientId});

  @override
  ConsumerState<_InviteButton> createState() => _InviteButtonState();
}

class _InviteButtonState extends ConsumerState<_InviteButton> {
  final _emailCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _invite() async {
    final email = _emailCtrl.text.trim();
    if (Validators.email(email) != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid email')));
      return;
    }
    setState(() => _loading = true);
    try {
      await ref.read(caregiverNotifierProvider.notifier).inviteCaregiver(
        patientId: widget.patientId,
        caregiverEmail: email,
      );
      _emailCtrl.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invitation sent to $email'),
            backgroundColor: ColorTokens.mintSuccess,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontSize: 14, color: ColorTokens.textPrimaryLight),
            decoration: InputDecoration(
              hintText: 'caregiver@email.com',
              hintStyle: const TextStyle(color: ColorTokens.textMutedLight),
              filled: true,
              fillColor: ColorTokens.backgroundLight,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ColorTokens.borderLight)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ColorTokens.borderLight)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ColorTokens.primaryTeal, width: 1.5)),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorTokens.primaryTeal,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onPressed: _loading ? null : _invite,
            child: _loading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Invite', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }
}

class _CaregiverLinkCard extends ConsumerWidget {
  final CaregiverLink link;
  const _CaregiverLinkCard({required this.link});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPending = link.status == CaregiverLinkStatus.pending;
    return NeoCard(
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: ColorTokens.backgroundSecondaryLight,
            child: Text(link.caregiverEmail.substring(0, 1).toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w700, color: ColorTokens.textPrimaryLight)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(link.caregiverEmail, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ColorTokens.textPrimaryLight)),
                Text(DateFormatters.formatDate(link.createdAt), style: const TextStyle(fontSize: 12, color: ColorTokens.textMutedLight)),
              ],
            ),
          ),
          PillChip(
            label: isPending ? 'Pending' : link.status.name[0].toUpperCase() + link.status.name.substring(1),
            backgroundColor: isPending ? ColorTokens.warningAmberBg : ColorTokens.mintSuccessBg,
            textColor: isPending ? ColorTokens.warningAmber : ColorTokens.mintSuccess,
            borderColor: isPending ? ColorTokens.warningAmberBorder : ColorTokens.mintSuccessBorder,
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline_rounded, color: ColorTokens.alertCoral, size: 20),
            onPressed: () async {
              await ref.read(caregiverNotifierProvider.notifier).revokeLink(link.id);
            },
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _EmptyState({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return NeoCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Column(
          children: [
            Icon(icon, size: 40, color: ColorTokens.textMutedLight),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: ColorTokens.textPrimaryLight)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 13, color: ColorTokens.textSecondaryLight), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});
  @override
  Widget build(BuildContext context) {
    return NeoCard(
      borderColor: ColorTokens.alertCoralBorder,
      backgroundColor: ColorTokens.alertCoralBg,
      child: Text(message, style: const TextStyle(color: ColorTokens.alertCoral, fontSize: 13)),
    );
  }
}
