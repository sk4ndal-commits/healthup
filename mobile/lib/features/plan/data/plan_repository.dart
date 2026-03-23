import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../profile/data/profile_repository.dart';
import '../domain/weekly_plan.dart';

part 'plan_repository.g.dart';

class PlanRepository {
  final SharedPreferences _prefs;
  static const _keyPrefix = 'weekly_plan_';
  static const _currentPlanKey = 'current_weekly_plan_id';

  PlanRepository(this._prefs);

  Future<void> savePlan(WeeklyPlan plan) async {
    await _prefs.setString('$_keyPrefix${plan.id}', jsonEncode(plan.toJson()));
    await _prefs.setString(_currentPlanKey, plan.id);
  }

  WeeklyPlan? getCurrentPlan() {
    final id = _prefs.getString(_currentPlanKey);
    if (id == null) return null;
    
    final jsonStr = _prefs.getString('$_keyPrefix$id');
    if (jsonStr == null) return null;

    try {
      return WeeklyPlan.fromJson(jsonDecode(jsonStr));
    } catch (e) {
      return null;
    }
  }

  Future<void> deletePlan(String id) async {
    await _prefs.remove('$_keyPrefix$id');
    final currentId = _prefs.getString(_currentPlanKey);
    if (currentId == id) {
      await _prefs.remove(_currentPlanKey);
    }
  }
}

@riverpod
Future<PlanRepository> planRepository(PlanRepositoryRef ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return PlanRepository(prefs);
}
