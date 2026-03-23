import 'package:json_annotation/json_annotation.dart';
import '../domain/weekly_plan.dart';

part 'plan_dtos.g.dart';

@JsonSerializable()
class DailyActionDto {
  final String id;
  final String area;
  final String title;
  final String description;
  final bool isStretch;

  const DailyActionDto({
    required this.id,
    required this.area,
    required this.title,
    required this.description,
    required this.isStretch,
  });

  factory DailyActionDto.fromDomain(DailyAction action) {
    return DailyActionDto(
      id: action.id,
      area: action.area.name,
      title: action.title,
      description: action.description,
      isStretch: action.isStretch,
    );
  }

  factory DailyActionDto.fromJson(Map<String, dynamic> json) =>
      _$DailyActionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DailyActionDtoToJson(this);
}

@JsonSerializable()
class WeeklyPlanDto {
  final String id;
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final List<DailyActionDto> dailyBaselines;
  final int targetWorkoutsPerWeek;
  final String sleepTargetWindow;
  final String nutritionAnchor;
  final String recoveryAnchor;
  final DateTime createdAt;

  const WeeklyPlanDto({
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

  factory WeeklyPlanDto.fromDomain(WeeklyPlan plan) {
    return WeeklyPlanDto(
      id: plan.id,
      userId: plan.userId,
      startDate: plan.startDate,
      endDate: plan.endDate,
      dailyBaselines: plan.dailyBaselines.map((a) => DailyActionDto.fromDomain(a)).toList(),
      targetWorkoutsPerWeek: plan.targetWorkoutsPerWeek,
      sleepTargetWindow: plan.sleepTargetWindow,
      nutritionAnchor: plan.nutritionAnchor,
      recoveryAnchor: plan.recoveryAnchor,
      createdAt: plan.createdAt,
    );
  }

  factory WeeklyPlanDto.fromJson(Map<String, dynamic> json) =>
      _$WeeklyPlanDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WeeklyPlanDtoToJson(this);
}
