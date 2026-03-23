import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/profile/domain/user_profile.dart';
import 'package:mobile_app/features/profile/presentation/profile_notifier.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileNotifierProvider);

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8F6),
        elevation: 0,
        title: Text(
          l10n.profileTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ),
      body: profileState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.somethingWentWrong(e.toString()))),
        data: (profile) {
          if (profile == null) {
            return Center(child: Text(l10n.noProfileFound));
          }
          return _ProfileContent(profile: profile);
        },
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final UserProfile profile;

  const _ProfileContent({required this.profile});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      children: [
        // Avatar + name
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: const Color(0xFF1A1A1A),
                child: Text(
                  profile.displayName.isNotEmpty
                      ? profile.displayName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                profile.displayName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 4),
              _GoalBadge(goal: profile.primaryGoal),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Details card
        _Card(
          children: [
            if (profile.ageRange != null)
              _Row(
                  label: l10n.rowLabelAgeRange,
                  value: _ageRangeLabel(context, profile.ageRange!)),
            if (profile.gender != null)
              _Row(
                  label: l10n.rowLabelGender,
                  value: _genderLabel(context, profile.gender!)),
            if (profile.workStyle != null)
              _Row(
                  label: l10n.rowLabelWorkStyle,
                  value: _workStyleLabel(context, profile.workStyle!)),
            if (profile.exerciseAvailability != null)
              _Row(
                  label: l10n.rowLabelAvailability,
                  value: _availabilityLabel(context, profile.exerciseAvailability!)),
            if (profile.scheduleStability != null)
              _Row(
                  label: l10n.rowLabelStability,
                  value: _stabilityLabel(context, profile.scheduleStability!)),
            if (profile.derailers != null && profile.derailers!.isNotEmpty)
              _Row(
                  label: l10n.rowLabelDerailers,
                  value: profile.derailers!
                      .map((d) => _derailerLabel(context, d))
                      .join(', ')),
            if (profile.preferredWorkoutStyle != null &&
                profile.preferredWorkoutStyle!.isNotEmpty)
              _Row(
                  label: l10n.rowLabelWorkoutStyle,
                  value: profile.preferredWorkoutStyle!),
            if (profile.heightCm != null)
              _Row(
                  label: l10n.rowLabelHeight,
                  value: '${profile.heightCm!.toStringAsFixed(0)} cm'),
            if (profile.weightKg != null)
              _Row(
                  label: l10n.rowLabelWeight,
                  value: '${profile.weightKg!.toStringAsFixed(0)} kg'),
            if (profile.notes != null && profile.notes!.isNotEmpty)
              _Row(label: l10n.rowLabelNotes, value: profile.notes!),
          ],
        ),
        const SizedBox(height: 12),

        // Minimum Win thresholds
        _Card(
          children: [
            if (profile.minMovementSteps != null)
              _Row(
                label: l10n.rowLabelMinMovement,
                value: l10n.stepsCount(profile.minMovementSteps!),
              ),
            if (profile.minExerciseMinutes != null)
              _Row(
                label: l10n.rowLabelMinExercise,
                value: l10n.minutesCount(profile.minExerciseMinutes!),
              ),
            if (profile.minSleepHours != null)
              _Row(
                label: l10n.rowLabelMinSleep,
                value: l10n.hoursCount(profile.minSleepHours!),
              ),
            if (profile.minNutritionAnchor != null &&
                profile.minNutritionAnchor!.isNotEmpty)
              _Row(
                label: l10n.rowLabelMinNutrition,
                value: profile.minNutritionAnchor!,
              ),
          ],
        ),
        const SizedBox(height: 12),

        // Meta
        _Card(
          children: [
            _Row(
              label: l10n.profileCreated(profile.createdAt),
              value: '',
            ),
            _Row(
              label: l10n.profileUpdated(profile.updatedAt),
              value: '',
            ),
          ],
        ),
      ],
    );
  }
}

class _GoalBadge extends StatelessWidget {
  final PrimaryGoal goal;
  const _GoalBadge({required this.goal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _goalLabel(context, goal),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Color(0xFF4A4A4A),
        ),
      ),
    );
  }

  String _goalLabel(BuildContext context, PrimaryGoal goal) {
    final l10n = AppLocalizations.of(context)!;
    switch (goal) {
      case PrimaryGoal.energy:
        return l10n.goalEnergy;
      case PrimaryGoal.fitness:
        return l10n.goalFitness;
      case PrimaryGoal.weightLoss:
        return l10n.goalWeightLoss;
      case PrimaryGoal.consistency:
        return l10n.goalConsistency;
      case PrimaryGoal.stressReduction:
        return l10n.goalStressReduction;
    }
  }
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        children: children
            .asMap()
            .entries
            .map((e) => Column(
                  children: [
                    e.value,
                    if (e.key < children.length - 1)
                      const Divider(height: 1, indent: 16, endIndent: 16),
                  ],
                ))
            .toList(),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B6B6B),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Label helpers ──────────────────────────────────────────────────────────

String _ageRangeLabel(BuildContext context, AgeRange r) {
  final l10n = AppLocalizations.of(context)!;
  switch (r) {
    case AgeRange.under25:
      return l10n.ageUnder25;
    case AgeRange.age25to34:
      return l10n.age25to34;
    case AgeRange.age35to44:
      return l10n.age35to44;
    case AgeRange.age45to54:
      return l10n.age45to54;
    case AgeRange.age55plus:
      return l10n.age55plus;
  }
}

String _genderLabel(BuildContext context, Gender g) {
  final l10n = AppLocalizations.of(context)!;
  switch (g) {
    case Gender.male:
      return l10n.genderMale;
    case Gender.female:
      return l10n.genderFemale;
    case Gender.nonBinary:
      return l10n.genderNonBinary;
    case Gender.preferNotToSay:
      return l10n.genderPreferNotToSay;
  }
}

String _workStyleLabel(BuildContext context, WorkStyle w) {
  final l10n = AppLocalizations.of(context)!;
  switch (w) {
    case WorkStyle.remote:
      return l10n.workStyleRemote;
    case WorkStyle.hybrid:
      return l10n.workStyleHybrid;
    case WorkStyle.onSite:
      return l10n.workStyleOnSite;
  }
}

String _availabilityLabel(BuildContext context, ExerciseAvailability a) {
  final l10n = AppLocalizations.of(context)!;
  switch (a) {
    case ExerciseAvailability.days0to2:
      return l10n.availability0to2;
    case ExerciseAvailability.days3to4:
      return l10n.availability3to4;
    case ExerciseAvailability.days5plus:
      return l10n.availability5plus;
  }
}

String _stabilityLabel(BuildContext context, ScheduleStability s) {
  final l10n = AppLocalizations.of(context)!;
  switch (s) {
    case ScheduleStability.stable:
      return l10n.stabilityStable;
    case ScheduleStability.somewhatVariable:
      return l10n.stabilitySomewhatVariable;
    case ScheduleStability.highlyVariable:
      return l10n.stabilityHighlyVariable;
  }
}

String _derailerLabel(BuildContext context, Derailer d) {
  final l10n = AppLocalizations.of(context)!;
  switch (d) {
    case Derailer.stress:
      return l10n.derailerStress;
    case Derailer.lowEnergy:
      return l10n.derailerLowEnergy;
    case Derailer.lackOfTime:
      return l10n.derailerLackOfTime;
    case Derailer.poorSleep:
      return l10n.derailerPoorSleep;
    case Derailer.travel:
      return l10n.derailerTravel;
    case Derailer.eatingOut:
      return l10n.derailerEatingOut;
    case Derailer.lowMotivation:
      return l10n.derailerLowMotivation;
  }
}
