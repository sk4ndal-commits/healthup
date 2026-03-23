import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/plan/domain/plan_generator.dart';
import 'package:mobile_app/features/plan/domain/weekly_plan.dart';
import 'package:mobile_app/features/profile/domain/user_profile.dart';

void main() {
  late PlanGenerator generator;

  setUp(() {
    generator = PlanGenerator();
  });

  final testProfile = UserProfile(
    userId: 'test-user',
    displayName: 'Test User',
    primaryGoal: PrimaryGoal.fitness,
    exerciseAvailability: ExerciseAvailability.days3to4,
    scheduleStability: ScheduleStability.stable,
    derailers: [Derailer.stress],
    minMovementSteps: 8000,
    minExerciseMinutes: 20,
    minSleepHours: 7.5,
    minNutritionAnchor: 'High protein breakfast',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  test('generates plan based on profile inputs', () {
    final plan = generator.generateInitialPlan(testProfile);

    expect(plan.userId, equals(testProfile.userId));
    expect(plan.targetWorkoutsPerWeek, equals(3)); // Based on days3to4
    expect(plan.sleepTargetWindow, contains('7.5'));
    expect(plan.nutritionAnchor, equals('High protein breakfast'));

    // Check daily baselines
    final movementAction = plan.dailyBaselines.firstWhere((a) => a.area == PlanArea.movement);
    expect(movementAction.description, contains('8000'));

    final nutritionAction = plan.dailyBaselines.firstWhere((a) => a.area == PlanArea.nutrition);
    expect(nutritionAction.description, equals('High protein breakfast'));
  });

  test('adjusts workout target based on availability', () {
    final lowAvailabilityProfile = testProfile.copyWith(
      exerciseAvailability: ExerciseAvailability.days0to2,
    );
    final highAvailabilityProfile = testProfile.copyWith(
      exerciseAvailability: ExerciseAvailability.days5plus,
    );

    final lowPlan = generator.generateInitialPlan(lowAvailabilityProfile);
    final highPlan = generator.generateInitialPlan(highAvailabilityProfile);

    expect(lowPlan.targetWorkoutsPerWeek, equals(2));
    expect(highPlan.targetWorkoutsPerWeek, equals(4));
  });

  test('generates stretch actions for specific goals', () {
    final fitnessProfile = testProfile.copyWith(primaryGoal: PrimaryGoal.fitness);
    final weightLossProfile = testProfile.copyWith(primaryGoal: PrimaryGoal.weightLoss);
    final energyProfile = testProfile.copyWith(primaryGoal: PrimaryGoal.energy);

    final fitnessPlan = generator.generateInitialPlan(fitnessProfile);
    final weightLossPlan = generator.generateInitialPlan(weightLossProfile);
    final energyPlan = generator.generateInitialPlan(energyProfile);

    expect(fitnessPlan.dailyBaselines.any((a) => a.isStretch), isTrue);
    expect(weightLossPlan.dailyBaselines.any((a) => a.isStretch), isTrue);
    expect(energyPlan.dailyBaselines.any((a) => a.isStretch), isFalse);
  });
}
