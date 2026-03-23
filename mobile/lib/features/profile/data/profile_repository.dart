import 'dart:convert';

import 'package:mobile_app/features/profile/domain/user_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

part 'profile_repository.g.dart';

class ProfileRepository {
  static const String _profileKey = 'user_profile';

  final SharedPreferences _prefs;

  ProfileRepository(this._prefs);

  Future<UserProfile?> getProfile() async {
    final json = _prefs.getString(_profileKey);
    if (json == null) return null;
    return UserProfile.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<UserProfile> createProfile({
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
    String? notes,
  }) async {
    final now = DateTime.now();
    final profile = UserProfile(
      userId: const Uuid().v4(),
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
      notes: notes,
      createdAt: now,
      updatedAt: now,
    );
    await _saveProfile(profile);
    return profile;
  }

  Future<UserProfile> updateProfile(UserProfile profile) async {
    await _saveProfile(profile);
    return profile;
  }

  Future<void> _saveProfile(UserProfile profile) async {
    await _prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  Future<bool> hasProfile() async {
    return _prefs.containsKey(_profileKey);
  }
}

@riverpod
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) async {
  return SharedPreferences.getInstance();
}

@riverpod
Future<ProfileRepository> profileRepository(ProfileRepositoryRef ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return ProfileRepository(prefs);
}
