import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/plan/domain/weekly_plan.dart';
import 'package:mobile_app/features/today/domain/daily_check_in.dart';
import 'package:mobile_app/features/today/presentation/pages/today_page.dart';
import 'package:mobile_app/features/today/presentation/today_notifier.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  late WeeklyPlan mockPlan;

  setUp(() {
    mockPlan = WeeklyPlan(
      id: 'plan_1',
      userId: 'user_1',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 7)),
      dailyBaselines: [
        DailyAction(
          id: 'action_1',
          area: PlanArea.movement,
          title: 'Daily Movement',
          description: 'Walk 5000 steps',
        ),
      ],
      targetWorkoutsPerWeek: 3,
      sleepTargetWindow: '8 hours',
      nutritionAnchor: 'No sugar',
      recoveryAnchor: 'Meditation',
      createdAt: DateTime.now(),
    );
  });

  Widget createTestWidget(TodayState state) {
    return ProviderScope(
      overrides: [
        todayNotifierProvider.overrideWith(() => SimpleMockTodayNotifier(state)),
      ],
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en')],
        home: TodayPage(),
      ),
    );
  }

  testWidgets('TodayPage shows action and allows tier selection', (tester) async {
    final state = TodayState(
      date: DateTime.now(),
      plan: mockPlan,
      checkIn: DailyCheckIn(
        userId: 'user_1',
        date: DateTime.now(),
        completions: {},
        updatedAt: DateTime.now(),
      ),
    );

    await tester.pumpWidget(createTestWidget(state));
    await tester.pumpAndSettle();

    expect(find.text('Daily Movement'), findsOneWidget);
    expect(find.text('Walk 5000 steps'), findsOneWidget);
    expect(find.text('Good'), findsOneWidget);
    expect(find.text('Better'), findsOneWidget);
    expect(find.text('Best'), findsOneWidget);
  });
}

class SimpleMockTodayNotifier extends TodayNotifier {
  final TodayState _mockState;
  SimpleMockTodayNotifier(this._mockState);

  @override
  Future<TodayState> build() async => _mockState;

  @override
  Future<void> updateTier(String actionId, CheckInTier tier) async {}

  @override
  Future<void> updateMode(DailyMode mode) async {}
}
