// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_check_in.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyCheckIn _$DailyCheckInFromJson(Map<String, dynamic> json) => DailyCheckIn(
      userId: json['userId'] as String,
      date: DateTime.parse(json['date'] as String),
      completions: (json['completions'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, $enumDecode(_$CheckInTierEnumMap, e)),
      ),
      mode: $enumDecodeNullable(_$DailyModeEnumMap, json['mode']) ??
          DailyMode.normal,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$DailyCheckInToJson(DailyCheckIn instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'date': instance.date.toIso8601String(),
      'completions': instance.completions
          .map((k, e) => MapEntry(k, _$CheckInTierEnumMap[e]!)),
      'mode': _$DailyModeEnumMap[instance.mode]!,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$CheckInTierEnumMap = {
  CheckInTier.none: 'none',
  CheckInTier.good: 'good',
  CheckInTier.better: 'better',
  CheckInTier.best: 'best',
};

const _$DailyModeEnumMap = {
  DailyMode.normal: 'normal',
  DailyMode.busy: 'busy',
  DailyMode.recovery: 'recovery',
};
