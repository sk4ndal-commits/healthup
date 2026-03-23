import 'package:mobile_app/features/profile/data/profile_repository.dart';
import 'package:mobile_app/features/profile/domain/user_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_notifier.g.dart';

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  FutureOr<UserProfile?> build() async {
    final repo = await ref.watch(profileRepositoryProvider.future);
    return repo.getProfile();
  }

  Future<void> createProfile({
    required String displayName,
    required PrimaryGoal primaryGoal,
    AgeRange? ageRange,
    Gender? gender,
    double? heightCm,
    double? weightKg,
    WorkStyle? workStyle,
    ExerciseAvailability? exerciseAvailability,
    ScheduleStability? scheduleStability,
    List<Derailer>? derailers,
    String? preferredWorkoutStyle,
    int? minMovementSteps,
    int? minExerciseMinutes,
    double? minSleepHours,
    String? minNutritionAnchor,
    String? notes,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(profileRepositoryProvider.future);
      return repo.createProfile(
        displayName: displayName,
        primaryGoal: primaryGoal,
        ageRange: ageRange,
        gender: gender,
        heightCm: heightCm,
        weightKg: weightKg,
        workStyle: workStyle,
        exerciseAvailability: exerciseAvailability,
        scheduleStability: scheduleStability,
        derailers: derailers,
        preferredWorkoutStyle: preferredWorkoutStyle,
        minMovementSteps: minMovementSteps,
        minExerciseMinutes: minExerciseMinutes,
        minSleepHours: minSleepHours,
        minNutritionAnchor: minNutritionAnchor,
        notes: notes,
      );
    });
  }

  Future<void> updateProfile(UserProfile profile) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(profileRepositoryProvider.future);
      return repo.updateProfile(profile);
    });
  }
}
