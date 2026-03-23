// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      primaryGoal: $enumDecode(_$PrimaryGoalEnumMap, json['primaryGoal']),
      ageRange: $enumDecodeNullable(_$AgeRangeEnumMap, json['ageRange']),
      gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
      heightCm: (json['heightCm'] as num?)?.toDouble(),
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      workStyle: $enumDecodeNullable(_$WorkStyleEnumMap, json['workStyle']),
      exerciseAvailability: $enumDecodeNullable(
          _$ExerciseAvailabilityEnumMap, json['exerciseAvailability']),
      scheduleStability: $enumDecodeNullable(
          _$ScheduleStabilityEnumMap, json['scheduleStability']),
      derailers: (json['derailers'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$DerailerEnumMap, e))
          .toList(),
      preferredWorkoutStyle: json['preferredWorkoutStyle'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'displayName': instance.displayName,
      'primaryGoal': _$PrimaryGoalEnumMap[instance.primaryGoal]!,
      'ageRange': _$AgeRangeEnumMap[instance.ageRange],
      'gender': _$GenderEnumMap[instance.gender],
      'heightCm': instance.heightCm,
      'weightKg': instance.weightKg,
      'workStyle': _$WorkStyleEnumMap[instance.workStyle],
      'exerciseAvailability':
          _$ExerciseAvailabilityEnumMap[instance.exerciseAvailability],
      'scheduleStability':
          _$ScheduleStabilityEnumMap[instance.scheduleStability],
      'derailers':
          instance.derailers?.map((e) => _$DerailerEnumMap[e]!).toList(),
      'preferredWorkoutStyle': instance.preferredWorkoutStyle,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$PrimaryGoalEnumMap = {
  PrimaryGoal.energy: 'energy',
  PrimaryGoal.fitness: 'fitness',
  PrimaryGoal.weightLoss: 'weight_loss',
  PrimaryGoal.consistency: 'consistency',
  PrimaryGoal.stressReduction: 'stress_reduction',
};

const _$AgeRangeEnumMap = {
  AgeRange.under25: 'under_25',
  AgeRange.age25to34: '25_34',
  AgeRange.age35to44: '35_44',
  AgeRange.age45to54: '45_54',
  AgeRange.age55plus: '55_plus',
};

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.nonBinary: 'non_binary',
  Gender.preferNotToSay: 'prefer_not_to_say',
};

const _$WorkStyleEnumMap = {
  WorkStyle.remote: 'remote',
  WorkStyle.hybrid: 'hybrid',
  WorkStyle.onSite: 'on_site',
};

const _$ExerciseAvailabilityEnumMap = {
  ExerciseAvailability.days0to2: '0_2',
  ExerciseAvailability.days3to4: '3_4',
  ExerciseAvailability.days5plus: '5_plus',
};

const _$ScheduleStabilityEnumMap = {
  ScheduleStability.stable: 'stable',
  ScheduleStability.somewhatVariable: 'somewhat_variable',
  ScheduleStability.highlyVariable: 'highly_variable',
};

const _$DerailerEnumMap = {
  Derailer.stress: 'stress',
  Derailer.lowEnergy: 'low_energy',
  Derailer.lackOfTime: 'lack_of_time',
  Derailer.poorSleep: 'poor_sleep',
  Derailer.travel: 'travel',
  Derailer.eatingOut: 'eating_out',
  Derailer.lowMotivation: 'low_motivation',
};
