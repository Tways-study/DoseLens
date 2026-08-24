import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/theme/text_styles.dart';
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
        backgroundColor: ColorTokens.canvas,
        appBar: AppBar(
          title: Text('Caregiver.', style: TextStyles.displayMedium),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: AppConstants.space20, vertical: 6),
              decoration: BoxDecoration(
                color: ColorTokens.coolWash,
                borderRadius: BorderRadius.circular(AppConstants.radiusFull),
              ),
              child: TabBar(
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: ColorTokens.paper,
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                  boxShadow: const [ColorTokens.cardShadow],
                ),
                labelColor: ColorTokens.primaryInk,
                labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                unselectedLabelColor: ColorTokens.midGray,
                unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                tabs: const [
                  Tab(text: 'Patients I Monitor'),
                  Tab(text: 'My Caregivers'),
                ],
              ),
            ),
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
      padding: const EdgeInsets.fromLTRB(AppConstants.space20, AppConstants.space16, AppConstants.space20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          linksAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(color: ColorTokens.electricBlue, strokeWidth: 2),
              ),
            ),
            error: (e, _) => _ErrorBanner(message: e.toString()),
            data: (links) {
              if (links.isEmpty) {
                return const _EmptyState(
                  icon: Icons.favorite_border_rounded,
                  title: 'No patients linked yet.',
                  subtitle: 'Ask the patient to invite you from their "My Caregivers" tab.',
                );
              }
              return Column(
                children: links
                    .map((link) => Padding(
                          padding: const EdgeInsets.only(bottom: AppConstants.space16),
                          child: _PatientMonitorCard(link: link),
                        ))
                    .toList(),
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
      borderRadius: AppConstants.radiusCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Patient header
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFF0F7FF),
                child: const Icon(Icons.person_rounded, color: ColorTokens.electricBlue, size: 20),
              ),
              const SizedBox(width: AppConstants.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Patient ID: ...${link.patientId.substring(link.patientId.length > 8 ? link.patientId.length - 8 : 0)}',
                      style: TextStyles.labelLarge,
                    ),
                    Text(
                      'Linked since ${DateFormatters.formatDate(link.createdAt)}',
                      style: TextStyles.caption,
                    ),
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
          const SizedBox(height: AppConstants.space16),
          missedAsync.when(
            loading: () => const LinearProgressIndicator(color: ColorTokens.electricBlue, minHeight: 2),
            error: (_, __) => const SizedBox.shrink(),
            data: (missed) {
              if (missed.isEmpty) {
                return Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: ColorTokens.mintSuccess, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'No missed doses in the last 24 hours',
                      style: TextStyles.caption.copyWith(color: ColorTokens.mintSuccess, fontWeight: FontWeight.w600),
                    ),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: ColorTokens.ember, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        '${missed.length} missed dose${missed.length > 1 ? 's' : ''} in 24h',
                        style: TextStyles.caption.copyWith(color: ColorTokens.ember, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...missed.take(3).map((log) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: ColorTokens.emberBg,
                            borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                            border: Border.all(color: ColorTokens.emberBorder, width: 0.8),
                          ),
                          child: Row(
                            children: [
                              const StatusBadge(status: AdherenceStatus.missed),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  log.medicationName,
                                  style: TextStyles.labelLarge.copyWith(fontSize: 13),
                                ),
                              ),
                              Text(
                                DateFormatters.formatTime(log.scheduledTime),
                                style: TextStyles.caption,
                              ),
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
      padding: const EdgeInsets.fromLTRB(AppConstants.space20, AppConstants.space16, AppConstants.space20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NeoCard(
            borderRadius: AppConstants.radiusCard,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Invite a Caregiver',
                  style: TextStyles.headingMedium.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  'Share adherence telemetry with a family member or physician.',
                  style: TextStyles.bodySecondary.copyWith(fontSize: 13),
                ),
                const SizedBox(height: AppConstants.space16),
                _InviteButton(patientId: user?.uid ?? ''),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.space28),
          SectionHeader(title: 'Active Caregivers', subtitle: 'Persons with remote heartbeat access'),
          const SizedBox(height: AppConstants.space8),
          linksAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(color: ColorTokens.electricBlue, strokeWidth: 2),
              ),
            ),
            error: (e, _) => _ErrorBanner(message: e.toString()),
            data: (links) {
              if (links.isEmpty) {
                return const _EmptyState(
                  icon: Icons.group_outlined,
                  title: 'No caregivers invited yet.',
                  subtitle: 'Invite someone to monitor your medication adherence heartbeat.',
                );
              }
              return Column(
                children: links
                    .map((link) => Padding(
                          padding: const EdgeInsets.only(bottom: AppConstants.space12),
                          child: _CaregiverLinkCard(link: link),
                        ))
                    .toList(),
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid email address')));
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
            backgroundColor: ColorTokens.electricBlue,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusMedium)),
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
            style: const TextStyle(fontSize: 14, color: ColorTokens.primaryInk),
            decoration: InputDecoration(
              hintText: 'caregiver@email.com',
              hintStyle: const TextStyle(color: ColorTokens.midGray),
              filled: true,
              fillColor: ColorTokens.coolWash,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppConstants.radiusMedium), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppConstants.radiusMedium), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                borderSide: const BorderSide(color: ColorTokens.electricBlue, width: 1.5),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppConstants.space12),
        SizedBox(
          height: 46,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorTokens.electricBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusPill)),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            onPressed: _loading ? null : _invite,
            child: _loading
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Invite', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
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
      borderRadius: AppConstants.radiusCard,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: ColorTokens.coolWash,
            child: Text(
              link.caregiverEmail.substring(0, 1).toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w700, color: ColorTokens.primaryInk),
            ),
          ),
          const SizedBox(width: AppConstants.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  link.caregiverEmail,
                  style: TextStyles.labelLarge,
                ),
                Text(
                  DateFormatters.formatDate(link.createdAt),
                  style: TextStyles.caption,
                ),
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
            icon: const Icon(Icons.remove_circle_outline_rounded, color: ColorTokens.ember, size: 20),
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
      borderRadius: AppConstants.radiusCard,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
        child: Center(
          child: Column(
            children: [
              Icon(icon, size: 36, color: ColorTokens.midGray),
              const SizedBox(height: AppConstants.space12),
              Text(
                title,
                style: TextStyles.headingMedium,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyles.caption,
                textAlign: TextAlign.center,
              ),
            ],
          ),
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
      borderRadius: AppConstants.radiusCard,
      borderColor: ColorTokens.emberBorder,
      backgroundColor: ColorTokens.emberBg,
      child: Text(message, style: const TextStyle(color: ColorTokens.ember, fontSize: 13)),
    );
  }
}
