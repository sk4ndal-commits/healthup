import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/features/profile/domain/user_profile.dart';
import 'package:mobile_app/features/profile/presentation/profile_notifier.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class CreateProfilePage extends ConsumerStatefulWidget {
  const CreateProfilePage({super.key});

  @override
  ConsumerState<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends ConsumerState<CreateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _workoutStyleController = TextEditingController();
  final _nutritionAnchorController = TextEditingController();

  PrimaryGoal? _selectedGoal;
  AgeRange? _selectedAgeRange;
  Gender? _selectedGender;
  WorkStyle? _selectedWorkStyle;
  ExerciseAvailability? _selectedAvailability;
  ScheduleStability? _selectedStability;
  final List<Derailer> _selectedDerailers = [];

  // Min Win thresholds
  double _minMovement = 3000;
  double _minExercise = 10;
  double _minSleep = 6;

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _workoutStyleController.dispose();
    _nutritionAnchorController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGoal == null) {
      _showError(AppLocalizations.of(context)!.errorSelectGoal);
      return;
    }
    if (_selectedAvailability == null) {
      _showError(AppLocalizations.of(context)!.errorSelectAvailability);
      return;
    }
    if (_selectedStability == null) {
      _showError(AppLocalizations.of(context)!.errorSelectStability);
      return;
    }
    if (_selectedDerailers.isEmpty) {
      _showError(AppLocalizations.of(context)!.errorSelectDerailer);
      return;
    }

    await ref.read(profileNotifierProvider.notifier).createProfile(
          displayName: _nameController.text.trim(),
          primaryGoal: _selectedGoal!,
          ageRange: _selectedAgeRange,
          gender: _selectedGender,
          heightCm: double.tryParse(_heightController.text),
          weightKg: double.tryParse(_weightController.text),
          workStyle: _selectedWorkStyle,
          exerciseAvailability: _selectedAvailability,
          scheduleStability: _selectedStability,
          derailers: _selectedDerailers,
          preferredWorkoutStyle: _workoutStyleController.text.trim().isEmpty
              ? null
              : _workoutStyleController.text.trim(),
          minMovementSteps: _minMovement.toInt(),
          minExerciseMinutes: _minExercise.toInt(),
          minSleepHours: _minSleep,
          minNutritionAnchor: _nutritionAnchorController.text.trim().isEmpty
              ? null
              : _nutritionAnchorController.text.trim(),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );

    if (mounted) {
      context.go('/');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);
    final isLoading = profileState.isLoading;

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  l10n.createProfileTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.createProfileSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF6B6B6B),
                      ),
                ),
                const SizedBox(height: 32),

                // Name
                _SectionLabel(label: l10n.nameFieldLabel),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: _inputDecoration(l10n.nameFieldHint),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.nameFieldError
                      : null,
                ),
                const SizedBox(height: 28),

                // Primary goal — required
                _SectionLabel(label: l10n.primaryGoalLabel),
                const SizedBox(height: 4),
                Text(
                  l10n.primaryGoalSubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF6B6B6B),
                      ),
                ),
                const SizedBox(height: 12),
                _GoalSelector(
                  selected: _selectedGoal,
                  onChanged: (g) => setState(() => _selectedGoal = g),
                ),
                const SizedBox(height: 32),

                // Availability
                _SectionLabel(label: l10n.availabilityLabel),
                const SizedBox(height: 4),
                Text(
                  l10n.availabilitySubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF6B6B6B),
                      ),
                ),
                const SizedBox(height: 12),
                _ChipSelector<ExerciseAvailability>(
                  options: ExerciseAvailability.values,
                  selected: _selectedAvailability,
                  label: (v) => _availabilityLabel(context, v),
                  onChanged: (v) => setState(() => _selectedAvailability = v),
                ),
                const SizedBox(height: 28),

                // Stability
                _SectionLabel(label: l10n.stabilityLabel),
                const SizedBox(height: 4),
                Text(
                  l10n.stabilitySubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF6B6B6B),
                      ),
                ),
                const SizedBox(height: 12),
                _ChipSelector<ScheduleStability>(
                  options: ScheduleStability.values,
                  selected: _selectedStability,
                  label: (v) => _stabilityLabel(context, v),
                  onChanged: (v) => setState(() => _selectedStability = v),
                ),
                const SizedBox(height: 28),

                // Derailers
                _SectionLabel(label: l10n.derailersLabel),
                const SizedBox(height: 4),
                Text(
                  l10n.derailersSubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF6B6B6B),
                      ),
                ),
                const SizedBox(height: 12),
                _MultiChipSelector<Derailer>(
                  options: Derailer.values,
                  selected: _selectedDerailers,
                  label: (v) => _derailerLabel(context, v),
                  onToggle: (v) => setState(() {
                    if (_selectedDerailers.contains(v)) {
                      _selectedDerailers.remove(v);
                    } else {
                      _selectedDerailers.add(v);
                    }
                  }),
                ),
                const SizedBox(height: 32),

                // Minimum Win Setup
                Text(
                  l10n.minWinTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.minWinSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF6B6B6B),
                      ),
                ),
                const SizedBox(height: 24),

                // Movement Min
                _SectionLabel(label: l10n.minMovementLabel),
                const SizedBox(height: 4),
                Text(
                  l10n.minMovementSubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF6B6B6B),
                      ),
                ),
                Slider(
                  value: _minMovement,
                  min: 1000,
                  max: 10000,
                  divisions: 18,
                  label: l10n.stepsCount(_minMovement.toInt()),
                  activeColor: const Color(0xFF1A1A1A),
                  onChanged: (v) => setState(() => _minMovement = v),
                ),
                const SizedBox(height: 16),

                // Exercise Min
                _SectionLabel(label: l10n.minExerciseLabel),
                const SizedBox(height: 4),
                Text(
                  l10n.minExerciseSubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF6B6B6B),
                      ),
                ),
                Slider(
                  value: _minExercise,
                  min: 5,
                  max: 60,
                  divisions: 11,
                  label: l10n.minutesCount(_minExercise.toInt()),
                  activeColor: const Color(0xFF1A1A1A),
                  onChanged: (v) => setState(() => _minExercise = v),
                ),
                const SizedBox(height: 16),

                // Sleep Min
                _SectionLabel(label: l10n.minSleepLabel),
                const SizedBox(height: 4),
                Text(
                  l10n.minSleepSubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF6B6B6B),
                      ),
                ),
                Slider(
                  value: _minSleep,
                  min: 4,
                  max: 9,
                  divisions: 10,
                  label: l10n.hoursCount(_minSleep),
                  activeColor: const Color(0xFF1A1A1A),
                  onChanged: (v) => setState(() => _minSleep = v),
                ),
                const SizedBox(height: 16),

                // Nutrition Anchor
                _SectionLabel(label: l10n.minNutritionLabel),
                const SizedBox(height: 4),
                Text(
                  l10n.minNutritionSubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF6B6B6B),
                      ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nutritionAnchorController,
                  decoration: _inputDecoration(l10n.minNutritionHint),
                ),
                const SizedBox(height: 32),

                // Optional section header
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        l10n.optionalSectionLabel,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF9E9E9E),
                            ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),

                // Age range
                _SectionLabel(label: l10n.ageRangeLabel),
                const SizedBox(height: 8),
                _ChipSelector<AgeRange>(
                  options: AgeRange.values,
                  selected: _selectedAgeRange,
                  label: (v) => _ageRangeLabel(context, v),
                  onChanged: (v) => setState(() => _selectedAgeRange = v),
                ),
                const SizedBox(height: 20),

                // Gender
                _SectionLabel(label: l10n.genderLabel),
                const SizedBox(height: 8),
                _ChipSelector<Gender>(
                  options: Gender.values,
                  selected: _selectedGender,
                  label: (v) => _genderLabel(context, v),
                  onChanged: (v) => setState(() => _selectedGender = v),
                ),
                const SizedBox(height: 20),

                // Work style
                _SectionLabel(label: l10n.workStyleLabel),
                const SizedBox(height: 8),
                _ChipSelector<WorkStyle>(
                  options: WorkStyle.values,
                  selected: _selectedWorkStyle,
                  label: (v) => _workStyleLabel(context, v),
                  onChanged: (v) => setState(() => _selectedWorkStyle = v),
                ),
                const SizedBox(height: 20),

                // Height & weight
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionLabel(label: l10n.heightLabel),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _heightController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d{0,3}\.?\d{0,1}')),
                            ],
                            decoration: _inputDecoration(l10n.heightHint),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionLabel(label: l10n.weightLabel),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _weightController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d{0,3}\.?\d{0,1}')),
                            ],
                            decoration: _inputDecoration(l10n.weightHint),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Notes
                _SectionLabel(label: l10n.workoutStyleLabel),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _workoutStyleController,
                  decoration: _inputDecoration(l10n.workoutStyleHint),
                ),
                const SizedBox(height: 20),

                // Notes
                _SectionLabel(label: l10n.notesLabel),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: _inputDecoration(l10n.notesHint),
                ),
                const SizedBox(height: 40),

                // CTA
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: isLoading ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1A1A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            l10n.continueButton,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF1A1A1A), width: 1.5),
      ),
    );
  }
}

// ── Goal selector ──────────────────────────────────────────────────────────

class _GoalSelector extends StatelessWidget {
  final PrimaryGoal? selected;
  final ValueChanged<PrimaryGoal> onChanged;

  const _GoalSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: PrimaryGoal.values.map((goal) {
        final isSelected = selected == goal;
        return GestureDetector(
          onTap: () => onChanged(goal),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF1A1A1A) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF1A1A1A)
                    : const Color(0xFFE0E0E0),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _goalTitle(context, goal),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _goalDescription(context, goal),
                        style: TextStyle(
                          fontSize: 13,
                          color: isSelected
                              ? const Color(0xFFCCCCCC)
                              : const Color(0xFF6B6B6B),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle, color: Colors.white, size: 20),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _goalTitle(BuildContext context, PrimaryGoal goal) {
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

  String _goalDescription(BuildContext context, PrimaryGoal goal) {
    final l10n = AppLocalizations.of(context)!;
    switch (goal) {
      case PrimaryGoal.energy:
        return l10n.goalEnergyDesc;
      case PrimaryGoal.fitness:
        return l10n.goalFitnessDesc;
      case PrimaryGoal.weightLoss:
        return l10n.goalWeightLossDesc;
      case PrimaryGoal.consistency:
        return l10n.goalConsistencyDesc;
      case PrimaryGoal.stressReduction:
        return l10n.goalStressReductionDesc;
    }
  }
}

// ── Generic chip selector ──────────────────────────────────────────────────

class _ChipSelector<T> extends StatelessWidget {
  final List<T> options;
  final T? selected;
  final String Function(T) label;
  final ValueChanged<T> onChanged;

  const _ChipSelector({
    required this.options,
    required this.selected,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selected == option;
        return GestureDetector(
          onTap: () => onChanged(option),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF1A1A1A) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF1A1A1A)
                    : const Color(0xFFE0E0E0),
              ),
            ),
            child: Text(
              label(option),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _MultiChipSelector<T> extends StatelessWidget {
  final List<T> options;
  final List<T> selected;
  final String Function(T) label;
  final ValueChanged<T> onToggle;

  const _MultiChipSelector({
    required this.options,
    required this.selected,
    required this.label,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selected.contains(option);
        return GestureDetector(
          onTap: () => onToggle(option),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF1A1A1A) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF1A1A1A)
                    : const Color(0xFFE0E0E0),
              ),
            ),
            child: Text(
              label(option),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Section label ──────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A1A),
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
