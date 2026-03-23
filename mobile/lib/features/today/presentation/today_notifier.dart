import 'package:mobile_app/features/plan/data/plan_repository.dart';
import 'package:mobile_app/features/profile/presentation/profile_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../plan/domain/weekly_plan.dart';
import '../data/check_in_repository.dart';
import '../domain/daily_check_in.dart';

part 'today_notifier.g.dart';

class TodayState {
  final DateTime date;
  final WeeklyPlan? plan;
  final DailyCheckIn? checkIn;
  final bool isLoading;

  TodayState({
    required this.date,
    this.plan,
    this.checkIn,
    this.isLoading = false,
  });

  TodayState copyWith({
    DateTime? date,
    WeeklyPlan? plan,
    DailyCheckIn? checkIn,
    bool? isLoading,
  }) {
    return TodayState(
      date: date ?? this.date,
      plan: plan ?? this.plan,
      checkIn: checkIn ?? this.checkIn,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

@riverpod
class TodayNotifier extends _$TodayNotifier {
  @override
  Future<TodayState> build() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    final planRepo = await ref.watch(planRepositoryProvider.future);
    final checkInRepo = await ref.watch(checkInRepositoryProvider.future);
    final profile = await ref.watch(profileNotifierProvider.future);

    if (profile == null) {
      return TodayState(date: today);
    }

    final plan = planRepo.getCurrentPlan();
    final checkIn = await checkInRepo.getCheckIn(profile.userId, today);

    return TodayState(
      date: today,
      plan: plan,
      checkIn: checkIn ?? DailyCheckIn(
        userId: profile.userId,
        date: today,
        completions: {},
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> updateTier(String actionId, CheckInTier tier) async {
    final currentState = state.value;
    if (currentState == null || currentState.checkIn == null) return;

    final updatedCompletions = Map<String, CheckInTier>.from(currentState.checkIn!.completions);
    updatedCompletions[actionId] = tier;

    final updatedCheckIn = currentState.checkIn!.copyWith(
      completions: updatedCompletions,
      updatedAt: DateTime.now(),
    );

    final checkInRepo = await ref.read(checkInRepositoryProvider.future);
    await checkInRepo.saveCheckIn(updatedCheckIn);

    state = AsyncData(currentState.copyWith(checkIn: updatedCheckIn));
  }

  Future<void> updateMode(DailyMode mode) async {
    final currentState = state.value;
    if (currentState == null || currentState.checkIn == null) return;

    final updatedCheckIn = currentState.checkIn!.copyWith(
      mode: mode,
      updatedAt: DateTime.now(),
    );

    final checkInRepo = await ref.read(checkInRepositoryProvider.future);
    await checkInRepo.saveCheckIn(updatedCheckIn);

    state = AsyncData(currentState.copyWith(checkIn: updatedCheckIn));
  }
}
