// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'HealthUp';

  @override
  String get createProfileTitle => 'Your profile';

  @override
  String get createProfileSubtitle =>
      'Set up in under 1 minute. You can adjust this later.';

  @override
  String get nameFieldLabel => 'What should we call you?';

  @override
  String get nameFieldHint => 'First name or display name';

  @override
  String get nameFieldError => 'Please enter your name.';

  @override
  String get primaryGoalLabel => 'What matters most to you right now?';

  @override
  String get primaryGoalSubtitle => 'Choose one.';

  @override
  String get availabilityLabel => 'Weekly exercise availability';

  @override
  String get availabilitySubtitle =>
      'Days per week you can realistically commit.';

  @override
  String get stabilityLabel => 'How stable is your schedule?';

  @override
  String get stabilitySubtitle =>
      'This helps us decide how flexible your plan needs to be.';

  @override
  String get derailersLabel => 'What usually knocks you off track?';

  @override
  String get derailersSubtitle => 'Select all that apply.';

  @override
  String get optionalSectionLabel => 'Optional — helps personalise your plan';

  @override
  String get ageRangeLabel => 'Age range';

  @override
  String get genderLabel => 'Gender';

  @override
  String get workStyleLabel => 'Work style';

  @override
  String get heightLabel => 'Height (cm)';

  @override
  String get heightHint => 'e.g. 175';

  @override
  String get weightLabel => 'Weight (kg)';

  @override
  String get weightHint => 'e.g. 72';

  @override
  String get workoutStyleLabel => 'Preferred workout style';

  @override
  String get workoutStyleHint => 'e.g. Strength, Yoga, Running, Quick HIIT…';

  @override
  String get notesLabel => 'Anything else we should know?';

  @override
  String get notesHint => 'e.g. I travel a lot, I have a bad knee…';

  @override
  String get continueButton => 'Continue';

  @override
  String get errorSelectGoal => 'Please select a primary goal.';

  @override
  String get errorSelectAvailability =>
      'Please select your exercise availability.';

  @override
  String get errorSelectStability => 'Please select your schedule stability.';

  @override
  String get errorSelectDerailer => 'Please select at least one derailer.';

  @override
  String get goalEnergy => 'Feel more energetic';

  @override
  String get goalEnergyDesc =>
      'Focus on consistent sleep and metabolic health.';

  @override
  String get goalFitness => 'Get fitter';

  @override
  String get goalFitnessDesc =>
      'Improve strength, endurance, and overall capacity.';

  @override
  String get goalWeightLoss => 'Lose weight';

  @override
  String get goalWeightLossDesc =>
      'Support sustainable fat loss with nutrition and movement.';

  @override
  String get goalConsistency => 'Build consistency';

  @override
  String get goalConsistencyDesc =>
      'Focus on showing up every day, no matter what.';

  @override
  String get goalStressReduction => 'Reduce stress';

  @override
  String get goalStressReductionDesc =>
      'Use movement and recovery to manage high pressure.';

  @override
  String get availability0to2 => '0–2 days';

  @override
  String get availability3to4 => '3–4 days';

  @override
  String get availability5plus => '5+ days';

  @override
  String get stabilityStable => 'Stable';

  @override
  String get stabilitySomewhatVariable => 'Somewhat variable';

  @override
  String get stabilityHighlyVariable => 'Highly variable';

  @override
  String get derailerStress => 'Stress';

  @override
  String get derailerLowEnergy => 'Low energy';

  @override
  String get derailerLackOfTime => 'Lack of time';

  @override
  String get derailerPoorSleep => 'Poor sleep';

  @override
  String get derailerTravel => 'Travel';

  @override
  String get derailerEatingOut => 'Eating out';

  @override
  String get derailerLowMotivation => 'Low motivation';

  @override
  String get ageUnder25 => 'Under 25';

  @override
  String get age25to34 => '25–34';

  @override
  String get age35to44 => '35–44';

  @override
  String get age45to54 => '45–54';

  @override
  String get age55plus => '55+';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderNonBinary => 'Non-binary';

  @override
  String get genderPreferNotToSay => 'Prefer not to say';

  @override
  String get workStyleRemote => 'Remote';

  @override
  String get workStyleHybrid => 'Hybrid';

  @override
  String get workStyleOnSite => 'On-site';

  @override
  String get profileTitle => 'Profile';

  @override
  String get noProfileFound => 'No profile found.';

  @override
  String somethingWentWrong(String error) {
    return 'Something went wrong: $error';
  }

  @override
  String get rowLabelAgeRange => 'Age range';

  @override
  String get rowLabelGender => 'Gender';

  @override
  String get rowLabelWorkStyle => 'Work style';

  @override
  String get rowLabelAvailability => 'Availability';

  @override
  String get rowLabelStability => 'Stability';

  @override
  String get rowLabelDerailers => 'Derailers';

  @override
  String get rowLabelWorkoutStyle => 'Workout style';

  @override
  String get rowLabelHeight => 'Height';

  @override
  String get rowLabelWeight => 'Weight';

  @override
  String get rowLabelNotes => 'Notes';

  @override
  String profileCreated(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Created $dateString';
  }

  @override
  String profileUpdated(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Last updated $dateString';
  }

  @override
  String get minWinTitle => 'Minimum win setup';

  @override
  String get minWinSubtitle => 'On a hard day, what still counts?';

  @override
  String get minMovementLabel => 'Movement (Steps)';

  @override
  String get minMovementSubtitle => 'Minimum steps to keep momentum.';

  @override
  String get minExerciseLabel => 'Exercise (Minutes)';

  @override
  String get minExerciseSubtitle => 'Minimum active time that counts.';

  @override
  String get minSleepLabel => 'Sleep (Hours)';

  @override
  String get minSleepSubtitle => 'Minimum rest to function.';

  @override
  String get minNutritionLabel => 'Nutrition Anchor';

  @override
  String get minNutritionSubtitle => 'One simple rule you can always keep.';

  @override
  String get minNutritionHint =>
      'e.g. Drink 2L water, No sugar, High protein breakfast...';

  @override
  String get minWinPresetTitle => 'Use recommended presets';

  @override
  String get minWinPresetSubtitle => 'You can customise these anytime.';

  @override
  String get rowLabelMinMovement => 'Min Movement';

  @override
  String get rowLabelMinExercise => 'Min Exercise';

  @override
  String get rowLabelMinSleep => 'Min Sleep';

  @override
  String get rowLabelMinNutrition => 'Min Nutrition';

  @override
  String stepsCount(int count) {
    return '$count steps';
  }

  @override
  String minutesCount(int count) {
    return '$count min';
  }

  @override
  String hoursCount(double count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString hours';
  }
}
