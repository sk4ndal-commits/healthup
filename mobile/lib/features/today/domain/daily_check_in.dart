import 'package:json_annotation/json_annotation.dart';

part 'daily_check_in.g.dart';

enum CheckInTier {
  @JsonValue('none')
  none,
  @JsonValue('good')
  good,
  @JsonValue('better')
  better,
  @JsonValue('best')
  best,
}

enum DailyMode {
  @JsonValue('normal')
  normal,
  @JsonValue('busy')
  busy,
  @JsonValue('recovery')
  recovery,
}

@JsonSerializable()
class DailyCheckIn {
  final String userId;
  final DateTime date; // Store only the date part
  final Map<String, CheckInTier> completions; // actionId -> tier
  final DailyMode mode;
  final DateTime updatedAt;

  const DailyCheckIn({
    required this.userId,
    required this.date,
    required this.completions,
    this.mode = DailyMode.normal,
    required this.updatedAt,
  });

  factory DailyCheckIn.fromJson(Map<String, dynamic> json) =>
      _$DailyCheckInFromJson(json);

  Map<String, dynamic> toJson() => _$DailyCheckInToJson(this);

  DailyCheckIn copyWith({
    Map<String, CheckInTier>? completions,
    DailyMode? mode,
    DateTime? updatedAt,
  }) {
    return DailyCheckIn(
      userId: userId,
      date: date,
      completions: completions ?? this.completions,
      mode: mode ?? this.mode,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
