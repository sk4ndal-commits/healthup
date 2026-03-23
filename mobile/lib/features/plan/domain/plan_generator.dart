import 'package:uuid/uuid.dart';
import '../../profile/domain/user_profile.dart';
import 'weekly_plan.dart';

class PlanGenerator {
  WeeklyPlan generateInitialPlan(UserProfile profile) {
    final now = DateTime.now();
    // Week starts today for the initial plan
    final startDate = DateTime(now.year, now.month, now.day);
    final endDate = startDate.add(const Duration(days: 6));

    // 1. Sleep target window (rule-based)
    // Most professionals benefit from an 8-hour window, 
    // we can adjust based on their minSleepHours or goal.
    final sleepTargetHours = profile.minSleepHours ?? 8.0;
    final sleepTargetWindow = "${sleepTargetHours.toStringAsFixed(1)} hours";

    // 2. Weekly workout target
    int targetWorkouts = 3;
    if (profile.exerciseAvailability != null) {
      switch (profile.exerciseAvailability!) {
        case ExerciseAvailability.days0to2:
          targetWorkouts = 2;
          break;
        case ExerciseAvailability.days3to4:
          targetWorkouts = 3;
          break;
        case ExerciseAvailability.days5plus:
          targetWorkouts = 4; // Start realistically
          break;
      }
    }

    // 3. Daily movement baseline (steps)
    final movementSteps = profile.minMovementSteps ?? 5000;
    final movementBaseline = DailyAction.create(
      area: PlanArea.movement,
      title: "Daily Movement",
      description: "Minimum $movementSteps steps today",
    );

    // 4. One nutrition anchor
    String nutritionAnchor = profile.minNutritionAnchor ?? "Eat a high-protein breakfast";
    final nutritionBaseline = DailyAction.create(
      area: PlanArea.nutrition,
      title: "Nutrition Anchor",
      description: nutritionAnchor,
    );

    // 5. One recovery anchor
    // Default recovery based on goal
    String recoveryTitle = "Evening Wind-down";
    String recoveryDesc = "10 minutes of screen-free time before bed";
    
    if (profile.primaryGoal == PrimaryGoal.stressReduction) {
      recoveryTitle = "Stress Reset";
      recoveryDesc = "5 minutes of intentional breathing";
    } else if (profile.primaryGoal == PrimaryGoal.energy) {
      recoveryTitle = "Energy Recovery";
      recoveryDesc = "Brief afternoon daylight exposure";
    }

    final recoveryBaseline = DailyAction.create(
      area: PlanArea.recovery,
      title: recoveryTitle,
      description: recoveryDesc,
    );

    // Stretch action (optional, based on goal)
    final stretchAction = _generateStretchAction(profile);

    final dailyBaselines = [
      movementBaseline,
      nutritionBaseline,
      recoveryBaseline,
    ];
    
    if (stretchAction != null) {
      dailyBaselines.add(stretchAction);
    }

    return WeeklyPlan(
      id: const Uuid().v4(),
      userId: profile.userId,
      startDate: startDate,
      endDate: endDate,
      dailyBaselines: dailyBaselines,
      targetWorkoutsPerWeek: targetWorkouts,
      sleepTargetWindow: sleepTargetWindow,
      nutritionAnchor: nutritionAnchor,
      recoveryAnchor: recoveryTitle,
      createdAt: now,
    );
  }

  DailyAction? _generateStretchAction(UserProfile profile) {
    switch (profile.primaryGoal) {
      case PrimaryGoal.fitness:
        return DailyAction.create(
          area: PlanArea.exercise,
          title: "Extra Mobility",
          description: "5 minutes of stretching",
          isStretch: true,
        );
      case PrimaryGoal.weightLoss:
        return DailyAction.create(
          area: PlanArea.nutrition,
          title: "Hydration Focus",
          description: "Drink 500ml water before lunch",
          isStretch: true,
        );
      default:
        return null;
    }
  }
}
