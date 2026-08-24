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
        backgroundColor: ColorTokens.paper,
        appBar: AppBar(
          backgroundColor: ColorTokens.paper,
          scrolledUnderElevation: 0,
          elevation: 0,
          title: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: ColorTokens.acidGreen,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Caregiver Link',
                style: TextStyles.displayMedium.copyWith(fontSize: 24),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: AppConstants.space20, vertical: 6),
              decoration: BoxDecoration(
                color: ColorTokens.fog,
                borderRadius: BorderRadius.circular(AppConstants.radiusButton),
                border: Border.all(color: ColorTokens.hairline),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: ColorTokens.obsidian,
                  borderRadius: BorderRadius.circular(AppConstants.radiusButton),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: ColorTokens.inkBlack,
                labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Monitored Patients'),
                  Tab(text: 'My Caregivers'),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            _MonitoredPatientsTab(),
            _MyCaregiversTab(),
          ],
        ),
      ),
    );
  }
}

class _MonitoredPatientsTab extends ConsumerWidget {
  const _MonitoredPatientsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientsAsync = ref.watch(monitoredPatientsProvider);

    return patientsAsync.when(
      data: (patients) {
        if (patients.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(AppConstants.space24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  child: SizedBox(
                    width: 90,
                    height: 90,
                    child: Image.asset(
                      'assets/images/craftwork_caregiver_heart.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.space16),
                Text('No Linked Patients', style: TextStyles.headingMedium),
                const SizedBox(height: 6),
                Text(
                  'When a family member or patient grants you caregiver access, their real-time telemetry will appear here.',
                  style: TextStyles.caption,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(AppConstants.space20, AppConstants.space16, AppConstants.space20, 100),
          itemCount: patients.length,
          itemBuilder: (context, idx) {
            final link = patients[idx];
            return _PatientMonitorCard(link: link);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: ColorTokens.inkBlack)),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _PatientMonitorCard extends ConsumerWidget {
  final CaregiverLink link;
  const _PatientMonitorCard({required this.link});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missedAsync = ref.watch(patientMissedDosesProvider(link.patientId));

    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.space16),
      child: NeoCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: ColorTokens.fog,
                        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                        border: Border.all(color: ColorTokens.hairline),
                      ),
                      child: const Center(
                        child: Icon(Icons.person_rounded, color: ColorTokens.inkBlack, size: 20),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          link.patientEmail,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        Text('Linked on ${DateFormatters.formatShortDate(link.createdAt)}', style: TextStyles.caption),
                      ],
                    ),
                  ],
                ),
                const PillChip(
                  label: 'Live Heartbeat',
                  backgroundColor: ColorTokens.acidGreen,
                  textColor: ColorTokens.inkBlack,
                  borderColor: ColorTokens.inkBlack,
                ),
              ],
            ),
            const SizedBox(height: AppConstants.space16),

            // Missed doses section
            missedAsync.when(
              data: (missed) {
                if (missed.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: ColorTokens.mintSuccessBg,
                      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                      border: Border.all(color: ColorTokens.mintSuccessBorder),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle_outline_rounded, color: ColorTokens.mintSuccess, size: 16),
                        SizedBox(width: 8),
                        Text('All doses taken on schedule today!', style: TextStyle(color: ColorTokens.mintSuccess, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: ColorTokens.vermillion, size: 16),
                        const SizedBox(width: 6),
                        Text('${missed.length} Missed Dose Alert(s)', style: const TextStyle(color: ColorTokens.vermillion, fontWeight: FontWeight.w700, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...missed.map((log) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: ColorTokens.vermillionBg,
                              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                              border: Border.all(color: ColorTokens.vermillionBorder),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(log.medicationName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: ColorTokens.inkBlack)),
                                Text(DateFormatters.formatTime(log.scheduledTime), style: const TextStyle(color: ColorTokens.vermillion, fontWeight: FontWeight.w600, fontSize: 12)),
                              ],
                            ),
                          ),
                        )),
                  ],
                );
              },
              loading: () => const SizedBox(height: 24),
              error: (e, _) => Text('Failed to load telemetry: $e'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyCaregiversTab extends ConsumerWidget {
  const _MyCaregiversTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final caregiversAsync = ref.watch(myCaregiversProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(AppConstants.space20, AppConstants.space16, AppConstants.space20, 100),
      children: [
        // Telemetry info banner
        NeoCard(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: Image.asset(
                    'assets/images/craftwork_caregiver_heart.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.space16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Remote Heartbeat Alerts', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    SizedBox(height: 2),
                    Text(
                      'Your caregivers will be alerted automatically if any critical dose is missed.',
                      style: TextStyle(fontSize: 12, color: ColorTokens.graphite),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppConstants.space20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionHeader(
              title: 'Authorized Caregivers',
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_rounded, size: 16, color: ColorTokens.inkBlack),
              label: const Text('Invite', style: TextStyle(color: ColorTokens.inkBlack, fontWeight: FontWeight.w700, fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorTokens.acidGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusFull)),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              ),
              onPressed: () => _showInviteDialog(context, ref),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.space8),

        caregiversAsync.when(
          data: (caregivers) {
            if (caregivers.isEmpty) {
              return const NeoCard(
                child: Center(
                  child: Text('No caregivers linked yet. Tap Invite above to share access.', style: TextStyle(color: ColorTokens.graphite, fontSize: 13)),
                ),
              );
            }
            return Column(
              children: caregivers.map((link) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: NeoCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(link.caregiverEmail, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            Text('Status: ${link.status.name}', style: TextStyles.caption),
                          ],
                        ),
                        PillChip(
                          label: link.status.name.toUpperCase(),
                          backgroundColor: link.status == CaregiverLinkStatus.active ? ColorTokens.acidGreen : ColorTokens.fog,
                          textColor: ColorTokens.inkBlack,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const SizedBox(height: 60),
          error: (e, _) => Text('Error: $e'),
        ),
      ],
    );
  }

  void _showInviteDialog(BuildContext context, WidgetRef ref) {
    final emailCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ColorTokens.snow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusCard),
          side: const BorderSide(color: ColorTokens.hairline),
        ),
        title: const Text('Invite Caregiver', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: ColorTokens.inkBlack)),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter your caregiver\'s email to send them a monitoring link.', style: TextStyle(fontSize: 13, color: ColorTokens.graphite)),
              const SizedBox(height: AppConstants.space16),
              TextFormField(
                controller: emailCtrl,
                validator: Validators.email,
                decoration: const InputDecoration(
                  labelText: 'Caregiver Email',
                  hintText: 'e.g. daughter@example.com',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: ColorTokens.graphite)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorTokens.acidGreen,
              foregroundColor: ColorTokens.inkBlack,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusButton)),
            ),
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              try {
                final user = ref.read(firebaseAuthStateProvider).valueOrNull;
                if (user != null) {
                  await ref.read(caregiverNotifierProvider.notifier).inviteCaregiver(
                        patientId: user.uid,
                        patientEmail: user.email ?? '',
                        caregiverEmail: emailCtrl.text.trim(),
                      );
                }
                if (ctx.mounted) Navigator.pop(ctx);
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: const Text('Send Invite', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
