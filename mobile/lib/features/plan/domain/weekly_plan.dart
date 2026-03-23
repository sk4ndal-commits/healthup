import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'weekly_plan.g.dart';

enum PlanArea {
  @JsonValue('movement')
  movement,
  @JsonValue('exercise')
  exercise,
  @JsonValue('sleep')
  sleep,
  @JsonValue('nutrition')
  nutrition,
  @JsonValue('recovery')
  recovery,
}

@JsonSerializable()
class DailyAction {
  final String id;
  final PlanArea area;
  final String title;
  final String description;
  final bool isStretch;

  const DailyAction({
    required this.id,
    required this.area,
    required this.title,
    required this.description,
    this.isStretch = false,
  });

  factory DailyAction.create({
    required PlanArea area,
    required String title,
    required String description,
    bool isStretch = false,
  }) {
    return DailyAction(
      id: const Uuid().v4(),
      area: area,
      title: title,
      description: description,
      isStretch: isStretch,
    );
  }

  factory DailyAction.fromJson(Map<String, dynamic> json) =>
      _$DailyActionFromJson(json);

  Map<String, dynamic> toJson() => _$DailyActionToJson(this);
}

@JsonSerializable()
class WeeklyPlan {
  final String id;
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final List<DailyAction> dailyBaselines;
  final int targetWorkoutsPerWeek;
  final String sleepTargetWindow;
  final String nutritionAnchor;
  final String recoveryAnchor;
  final DateTime createdAt;

  const WeeklyPlan({
    required this.id,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.dailyBaselines,
    required this.targetWorkoutsPerWeek,
    required this.sleepTargetWindow,
    required this.nutritionAnchor,
    required this.recoveryAnchor,
    required this.createdAt,
  });

  factory WeeklyPlan.fromJson(Map<String, dynamic> json) =>
      _$WeeklyPlanFromJson(json);

  Map<String, dynamic> toJson() => _$WeeklyPlanToJson(this);
}
