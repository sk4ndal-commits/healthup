import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

enum PrimaryGoal {
  @JsonValue('energy')
  energy,
  @JsonValue('fitness')
  fitness,
  @JsonValue('weight_loss')
  weightLoss,
  @JsonValue('consistency')
  consistency,
  @JsonValue('stress_reduction')
  stressReduction,
}

enum AgeRange {
  @JsonValue('under_25')
  under25,
  @JsonValue('25_34')
  age25to34,
  @JsonValue('35_44')
  age35to44,
  @JsonValue('45_54')
  age45to54,
  @JsonValue('55_plus')
  age55plus,
}

enum Gender {
  @JsonValue('male')
  male,
  @JsonValue('female')
  female,
  @JsonValue('non_binary')
  nonBinary,
  @JsonValue('prefer_not_to_say')
  preferNotToSay,
}

enum WorkStyle {
  @JsonValue('remote')
  remote,
  @JsonValue('hybrid')
  hybrid,
  @JsonValue('on_site')
  onSite,
}

enum ExerciseAvailability {
  @JsonValue('0_2')
  days0to2,
  @JsonValue('3_4')
  days3to4,
  @JsonValue('5_plus')
  days5plus,
}

enum ScheduleStability {
  @JsonValue('stable')
  stable,
  @JsonValue('somewhat_variable')
  somewhatVariable,
  @JsonValue('highly_variable')
  highlyVariable,
}

enum Derailer {
  @JsonValue('stress')
  stress,
  @JsonValue('low_energy')
  lowEnergy,
  @JsonValue('lack_of_time')
  lackOfTime,
  @JsonValue('poor_sleep')
  poorSleep,
  @JsonValue('travel')
  travel,
  @JsonValue('eating_out')
  eatingOut,
  @JsonValue('low_motivation')
  lowMotivation,
}

@JsonSerializable()
class UserProfile {
  final String userId;
  final String displayName;
  final PrimaryGoal primaryGoal;
  final AgeRange? ageRange;
  final Gender? gender;
  final double? heightCm;
  final double? weightKg;
  final WorkStyle? workStyle;
  final ExerciseAvailability? exerciseAvailability;
  final ScheduleStability? scheduleStability;
  final List<Derailer>? derailers;
  final String? preferredWorkoutStyle;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.userId,
    required this.displayName,
    required this.primaryGoal,
    this.ageRange,
    this.gender,
    this.heightCm,
    this.weightKg,
    this.workStyle,
    this.exerciseAvailability,
    this.scheduleStability,
    this.derailers,
    this.preferredWorkoutStyle,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  UserProfile copyWith({
    String? displayName,
    PrimaryGoal? primaryGoal,
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
  }) {
    return UserProfile(
      userId: userId,
      displayName: displayName ?? this.displayName,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      ageRange: ageRange ?? this.ageRange,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      workStyle: workStyle ?? this.workStyle,
      exerciseAvailability: exerciseAvailability ?? this.exerciseAvailability,
      scheduleStability: scheduleStability ?? this.scheduleStability,
      derailers: derailers ?? this.derailers,
      preferredWorkoutStyle: preferredWorkoutStyle ?? this.preferredWorkoutStyle,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
