import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/features/plan/domain/weekly_plan.dart';
import 'package:mobile_app/features/today/domain/daily_check_in.dart';
import 'package:mobile_app/features/today/presentation/today_notifier.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(todayNotifierProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.todayTitle),
        centerTitle: false,
      ),
      body: stateAsync.when(
        data: (state) => _buildContent(context, ref, state, l10n),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, TodayState state, AppLocalizations l10n) {
    if (state.plan == null) {
      return Center(child: Text(l10n.noPlanFound));
    }

    final dateStr = DateFormat.yMMMMd().format(state.date);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dateStr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          _buildModeSelector(context, ref, state.checkIn?.mode ?? DailyMode.normal, l10n),
          const SizedBox(height: 32),
          ...state.plan!.dailyBaselines.map((action) => _buildActionCard(
                context,
                ref,
                action,
                state.checkIn?.completions[action.id] ?? CheckInTier.none,
                l10n,
              )),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildModeSelector(BuildContext context, WidgetRef ref, DailyMode currentMode, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.todayModeLabel, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SegmentedButton<DailyMode>(
          segments: [
            ButtonSegment(value: DailyMode.normal, label: Text(l10n.modeNormal)),
            ButtonSegment(value: DailyMode.busy, label: Text(l10n.modeBusy)),
            ButtonSegment(value: DailyMode.recovery, label: Text(l10n.modeRecovery)),
          ],
          selected: {currentMode},
          onSelectionChanged: (newSelection) {
            ref.read(todayNotifierProvider.notifier).updateMode(newSelection.first);
          },
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    WidgetRef ref,
    DailyAction action,
    CheckInTier currentTier,
    AppLocalizations l10n,
  ) {
    final areaLabel = _getAreaLabel(action.area, l10n);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  areaLabel.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (action.isStretch)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'STRETCH',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onTertiaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(action.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(action.description, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            _buildTierSelector(ref, action.id, currentTier, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildTierSelector(WidgetRef ref, String actionId, CheckInTier currentTier, AppLocalizations l10n) {
    return Wrap(
      spacing: 8,
      children: [
        _TierChip(
          label: l10n.tierGood,
          isSelected: currentTier == CheckInTier.good,
          onTap: () => ref.read(todayNotifierProvider.notifier).updateTier(actionId, CheckInTier.good),
        ),
        _TierChip(
          label: l10n.tierBetter,
          isSelected: currentTier == CheckInTier.better,
          onTap: () => ref.read(todayNotifierProvider.notifier).updateTier(actionId, CheckInTier.better),
        ),
        _TierChip(
          label: l10n.tierBest,
          isSelected: currentTier == CheckInTier.best,
          onTap: () => ref.read(todayNotifierProvider.notifier).updateTier(actionId, CheckInTier.best),
        ),
      ],
    );
  }

  String _getAreaLabel(PlanArea area, AppLocalizations l10n) {
    switch (area) {
      case PlanArea.movement: return l10n.planAreaMovement;
      case PlanArea.exercise: return l10n.planAreaExercise;
      case PlanArea.sleep: return l10n.planAreaSleep;
      case PlanArea.nutrition: return l10n.planAreaNutrition;
      case PlanArea.recovery: return l10n.planAreaRecovery;
    }
  }
}

class _TierChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TierChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: colorScheme.primaryContainer,
      labelStyle: TextStyle(
        color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
