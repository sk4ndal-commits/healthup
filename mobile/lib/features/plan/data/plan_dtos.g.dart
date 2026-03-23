// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyActionDto _$DailyActionDtoFromJson(Map<String, dynamic> json) =>
    DailyActionDto(
      id: json['id'] as String,
      area: json['area'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      isStretch: json['isStretch'] as bool,
    );

Map<String, dynamic> _$DailyActionDtoToJson(DailyActionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'area': instance.area,
      'title': instance.title,
      'description': instance.description,
      'isStretch': instance.isStretch,
    };

WeeklyPlanDto _$WeeklyPlanDtoFromJson(Map<String, dynamic> json) =>
    WeeklyPlanDto(
      id: json['id'] as String,
      userId: json['userId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      dailyBaselines: (json['dailyBaselines'] as List<dynamic>)
          .map((e) => DailyActionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      targetWorkoutsPerWeek: (json['targetWorkoutsPerWeek'] as num).toInt(),
      sleepTargetWindow: json['sleepTargetWindow'] as String,
      nutritionAnchor: json['nutritionAnchor'] as String,
      recoveryAnchor: json['recoveryAnchor'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$WeeklyPlanDtoToJson(WeeklyPlanDto instance) =>
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
