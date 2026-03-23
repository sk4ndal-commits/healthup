// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyAction _$DailyActionFromJson(Map<String, dynamic> json) => DailyAction(
      id: json['id'] as String,
      area: $enumDecode(_$PlanAreaEnumMap, json['area']),
      title: json['title'] as String,
      description: json['description'] as String,
      isStretch: json['isStretch'] as bool? ?? false,
    );

Map<String, dynamic> _$DailyActionToJson(DailyAction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'area': _$PlanAreaEnumMap[instance.area]!,
      'title': instance.title,
      'description': instance.description,
      'isStretch': instance.isStretch,
    };

const _$PlanAreaEnumMap = {
  PlanArea.movement: 'movement',
  PlanArea.exercise: 'exercise',
  PlanArea.sleep: 'sleep',
  PlanArea.nutrition: 'nutrition',
  PlanArea.recovery: 'recovery',
};

WeeklyPlan _$WeeklyPlanFromJson(Map<String, dynamic> json) => WeeklyPlan(
      id: json['id'] as String,
      userId: json['userId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      dailyBaselines: (json['dailyBaselines'] as List<dynamic>)
          .map((e) => DailyAction.fromJson(e as Map<String, dynamic>))
          .toList(),
      targetWorkoutsPerWeek: (json['targetWorkoutsPerWeek'] as num).toInt(),
      sleepTargetWindow: json['sleepTargetWindow'] as String,
      nutritionAnchor: json['nutritionAnchor'] as String,
      recoveryAnchor: json['recoveryAnchor'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$WeeklyPlanToJson(WeeklyPlan instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'dailyBaselines': instance.dailyBaselines,
      'targetWorkoutsPerWeek': instance.targetWorkoutsPerWeek,
      'sleepTargetWindow': instance.sleepTargetWindow,
      'nutritionAnchor': instance.nutritionAnchor,
      'recoveryAnchor': instance.recoveryAnchor,
      'createdAt': instance.createdAt.toIso8601String(),
    };
