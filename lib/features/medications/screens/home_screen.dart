import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/neo_card.dart';
import '../../../core/widgets/pill_chip.dart';
import '../../../core/widgets/status_badge.dart';
import '../models/adherence_log.dart';
import '../models/medication.dart';
import '../providers/medications_provider.dart';
import 'add_medication_screen.dart';
import 'medication_detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final medsAsync = ref.watch(medicationsStreamProvider);
    final logsAsync = ref.watch(todayLogsProvider);
    final rateAsync = ref.watch(adherenceRateProvider);

    return Scaffold(
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
              'Today',
              style: TextStyles.displayMedium.copyWith(fontSize: 26),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: ColorTokens.inkBlack, size: 28),
            tooltip: 'Add Medication',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddMedicationScreen()),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Stack(
        children: [
          // Atmospheric Lime Glow Radial Wash
          Positioned(
            top: -60,
            left: 0,
            right: 0,
            height: 220,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.2, -0.4),
                  radius: 0.8,
                  colors: [
                    const Color(0xFFCAFC00).withValues(alpha: 0.22),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          RefreshIndicator(
            color: ColorTokens.inkBlack,
            onRefresh: () async => ref.invalidate(medicationsStreamProvider),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(AppConstants.space20, AppConstants.space8, AppConstants.space20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Subtitle
                  Text(
                    _formatDateHeader(),
                    style: TextStyles.bodySecondary,
                  ),
                  const SizedBox(height: AppConstants.space16),

                  // Hero Art + Adherence Metric Card
                  rateAsync.when(
                    data: (rate) => _HeroAdherenceCard(rate: rate),
                    loading: () => const _LoadingCard(height: 120),
                    error: (_, __) => const _HeroAdherenceCard(rate: 1.0),
                  ),
                  const SizedBox(height: AppConstants.space24),

                  // Category Filter Tab Bar (Craftwork Segmented Control)
                  _buildCategoryTabs(),
                  const SizedBox(height: AppConstants.space20),

                  // Schedule Timeline
                  medsAsync.when(
                    data: (meds) {
                      final filteredMeds = _filterMedications(meds);
                      if (filteredMeds.isEmpty) {
                        return _EmptyScheduleState(filter: _selectedFilter);
                      }
                      final logs = logsAsync.valueOrNull ?? [];
                      return _TimelineList(
                        medications: filteredMeds,
                        todayLogs: logs,
                      );
                    },
                    loading: () => const Column(
                      children: [
                        _LoadingCard(height: 80),
                        SizedBox(height: 12),
                        _LoadingCard(height: 80),
                      ],
                    ),
                    error: (e, _) => NeoCard(
                      child: Text('Failed to load schedule: $e', style: const TextStyle(color: ColorTokens.vermillion)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final tabs = ['All', 'Morning', 'Afternoon', 'Evening', 'As Needed'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.map((tab) {
          final isSelected = _selectedFilter == tab;
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = tab),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? ColorTokens.obsidian : ColorTokens.fog,
                  borderRadius: BorderRadius.circular(AppConstants.radiusButton),
                  border: Border.all(
                    color: isSelected ? ColorTokens.obsidian : ColorTokens.hairline,
                    width: 1.0,
                  ),
                ),
                child: Text(
                  tab,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : ColorTokens.inkBlack,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<Medication> _filterMedications(List<Medication> meds) {
    if (_selectedFilter == 'All') return meds;
    if (_selectedFilter == 'Morning') {
      return meds.where((m) => m.times.any((t) => int.tryParse(t.split(':')[0]) != null && int.parse(t.split(':')[0]) < 12)).toList();
    }
    if (_selectedFilter == 'Afternoon') {
      return meds.where((m) => m.times.any((t) => int.tryParse(t.split(':')[0]) != null && int.parse(t.split(':')[0]) >= 12 && int.parse(t.split(':')[0]) < 18)).toList();
    }
    if (_selectedFilter == 'Evening') {
      return meds.where((m) => m.times.any((t) => int.tryParse(t.split(':')[0]) != null && int.parse(t.split(':')[0]) >= 18)).toList();
    }
    if (_selectedFilter == 'As Needed') {
      return meds.where((m) => m.frequency == MedicationFrequency.asNeeded).toList();
    }
    return meds;
  }

  String _formatDateHeader() {
    final now = DateTime.now();
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return '${days[now.weekday - 1]}, ${DateFormatters.formatDate(now)}';
  }
}

class _HeroAdherenceCard extends StatelessWidget {
  final double rate;
  const _HeroAdherenceCard({required this.rate});

  @override
  Widget build(BuildContext context) {
    final pct = (rate * 100).round();
    final isGood = pct >= 80;

    return NeoCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // 3D Hero Art Banner with subtle crop
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppConstants.radiusCard)),
            child: SizedBox(
              height: 110,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/craftwork_hero_pills.jpg',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          ColorTokens.snow.withValues(alpha: 0.6),
                          ColorTokens.snow,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 12,
                    child: PillChip(
                      label: isGood ? 'Optimal Adherence' : 'Attention Needed',
                      backgroundColor: isGood ? ColorTokens.acidGreen : ColorTokens.vermillionBg,
                      textColor: isGood ? ColorTokens.inkBlack : ColorTokens.vermillion,
                      borderColor: isGood ? ColorTokens.inkBlack : ColorTokens.vermillionBorder,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Metric Details
          Padding(
            padding: const EdgeInsets.fromLTRB(AppConstants.space20, 4, AppConstants.space20, AppConstants.space16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '30-Day Adherence Rate',
                      style: TextStyles.caption.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$pct%',
                      style: TextStyles.metricNumber,
                    ),
                  ],
                ),
                SizedBox(
                  width: 56,
                  height: 56,
                  child: CustomPaint(
                    painter: _CraftworkDonutPainter(rate: rate),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CraftworkDonutPainter extends CustomPainter {
  final double rate;
  const _CraftworkDonutPainter({required this.rate});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;

    final bgPaint = Paint()
      ..color = ColorTokens.fog
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke;

    final fgPaint = Paint()
      ..color = ColorTokens.acidGreen
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final borderPaint = Paint()
      ..color = ColorTokens.inkBlack
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawCircle(center, radius + 3.5, borderPaint);
    canvas.drawCircle(center, radius - 3.5, borderPaint);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708,
      rate.clamp(0.0, 1.0) * 6.2832,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_CraftworkDonutPainter old) => old.rate != rate;
}

class _TimelineList extends ConsumerWidget {
  final List<Medication> medications;
  final List<AdherenceLog> todayLogs;

  const _TimelineList({
    required this.medications,
    required this.todayLogs,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Scheduled Doses', style: TextStyles.headingMedium),
            Text('${medications.length} active', style: TextStyles.caption),
          ],
        ),
        const SizedBox(height: AppConstants.space12),
        ...medications.map((med) {
          final log = todayLogs.where((l) => l.medicationId == med.id).firstOrNull;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.space12),
            child: _MedicationCard(
              medication: med,
              todayLog: log,
            ),
          );
        }),
      ],
    );
  }
}

class _MedicationCard extends ConsumerWidget {
  final Medication medication;
  final AdherenceLog? todayLog;

  const _MedicationCard({
    required this.medication,
    this.todayLog,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTaken = todayLog?.status == AdherenceStatus.taken;

    return Dismissible(
      key: Key(medication.id),
      background: _buildSwipeAction(
        color: ColorTokens.acidGreen,
        icon: Icons.check_circle_rounded,
        label: 'Take Dose',
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: _buildSwipeAction(
        color: ColorTokens.vermillion,
        icon: Icons.cancel_rounded,
        label: 'Skip',
        alignment: Alignment.centerRight,
      ),
      confirmDismiss: (direction) async {
        final status = direction == DismissDirection.startToEnd
            ? AdherenceStatus.taken
            : AdherenceStatus.skipped;
        await ref.read(medicationsNotifierProvider.notifier).logAdherence(
          medicationId: medication.id,
          medicationName: medication.name,
          status: status,
        );
        return false;
      },
      child: NeoCard(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MedicationDetailScreen(medication: medication),
          ),
        ),
        child: Row(
          children: [
            // Time Badge or Icon
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: isTaken ? ColorTokens.acidGreen : ColorTokens.fog,
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                border: Border.all(color: ColorTokens.hairline, width: 1.0),
              ),
              child: Center(
                child: Icon(
                  isTaken ? Icons.check_rounded : Icons.medication_outlined,
                  color: ColorTokens.inkBlack,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: AppConstants.space16),

            // Drug Metadata
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          medication.name,
                          style: TextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (todayLog != null)
                        StatusBadge(status: todayLog!.status)
                      else
                        const PillChip(
                          label: 'Pending',
                          backgroundColor: ColorTokens.fog,
                          textColor: ColorTokens.graphite,
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${medication.dosage} · ${medication.frequencyLabel}',
                    style: TextStyles.caption,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeAction({
    required Color color,
    required IconData icon,
    required String label,
    required Alignment alignment,
  }) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.space20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppConstants.radiusCard),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: ColorTokens.inkBlack, size: 20),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: ColorTokens.inkBlack, fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _EmptyScheduleState extends StatelessWidget {
  final String filter;
  const _EmptyScheduleState({required this.filter});

  @override
  Widget build(BuildContext context) {
    return NeoCard(
      padding: const EdgeInsets.all(AppConstants.space32),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: ColorTokens.fog,
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: const Icon(Icons.inventory_2_outlined, color: ColorTokens.graphite, size: 26),
            ),
            const SizedBox(height: AppConstants.space12),
            Text(
              filter == 'All' ? 'No Medications Scheduled' : 'No $filter Doses',
              style: TextStyles.headingMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Scan your prescription bottle or tap + above to add a new medication.',
              style: TextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  final double height;
  const _LoadingCard({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: ColorTokens.fog,
        borderRadius: BorderRadius.circular(AppConstants.radiusCard),
        border: Border.all(color: ColorTokens.hairline),
      ),
    );
  }
}
