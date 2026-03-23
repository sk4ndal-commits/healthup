import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/daily_check_in.dart';

import 'package:mobile_app/features/profile/data/profile_repository.dart';

part 'check_in_repository.g.dart';

class CheckInRepository {
  final SharedPreferences _prefs;
  static const String _keyPrefix = 'daily_check_in_';

  CheckInRepository(this._prefs);

  String _getKey(String userId, DateTime date) {
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return '${_keyPrefix}${userId}_$dateStr';
  }

  Future<DailyCheckIn?> getCheckIn(String userId, DateTime date) async {
    final jsonStr = _prefs.getString(_getKey(userId, date));
    if (jsonStr == null) return null;
    return DailyCheckIn.fromJson(json.decode(jsonStr) as Map<String, dynamic>);
  }

  Future<void> saveCheckIn(DailyCheckIn checkIn) async {
    await _prefs.setString(
      _getKey(checkIn.userId, checkIn.date),
      json.encode(checkIn.toJson()),
    );
  }
}

@Riverpod(keepAlive: true)
Future<CheckInRepository> checkInRepository(CheckInRepositoryRef ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return CheckInRepository(prefs);
}
