import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/plan_generator.dart';
import '../domain/weekly_plan.dart';
import '../data/plan_repository.dart';
import '../../profile/presentation/profile_notifier.dart';

part 'plan_notifier.g.dart';

@riverpod
class PlanNotifier extends _$PlanNotifier {
  @override
  AsyncValue<WeeklyPlan?> build() {
    final repositoryAsync = ref.watch(planRepositoryProvider);
    return repositoryAsync.when(
      data: (repository) => AsyncValue.data(repository.getCurrentPlan()),
      loading: () => const AsyncValue.loading(),
      error: (error, stack) => AsyncValue.error(error, stack),
    );
  }

  Future<void> generateInitialPlan() async {
    final profile = ref.read(profileNotifierProvider).value;
    if (profile == null) return;

    final generator = PlanGenerator();
    final plan = generator.generateInitialPlan(profile);
    
    final repository = await ref.read(planRepositoryProvider.future);
    await repository.savePlan(plan);
    state = AsyncValue.data(plan);
  }
}
