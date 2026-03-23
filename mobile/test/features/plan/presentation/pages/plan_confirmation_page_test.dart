import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/plan/domain/weekly_plan.dart';
import 'package:mobile_app/features/plan/presentation/pages/plan_confirmation_page.dart';
import 'package:mobile_app/features/plan/presentation/plan_notifier.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

class PlanNotifierMock extends PlanNotifier {
  final AsyncValue<WeeklyPlan?> initialValue;
  PlanNotifierMock(this.initialValue);

  @override
  AsyncValue<WeeklyPlan?> build() => initialValue;
}

void main() {
  final testPlan = WeeklyPlan(
    id: 'test-plan',
    userId: 'test-user',
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 6)),
    dailyBaselines: [
      DailyAction.create(
        area: PlanArea.movement,
        title: 'Daily Movement',
        description: '10000 steps',
      ),
      DailyAction.create(
        area: PlanArea.nutrition,
        title: 'Nutrition Anchor',
        description: 'Healthy breakfast',
      ),
    ],
    targetWorkoutsPerWeek: 3,
    sleepTargetWindow: '8.0 hours',
    nutritionAnchor: 'Healthy breakfast',
    recoveryAnchor: 'Evening Wind-down',
    createdAt: DateTime.now(),
  );

  Widget createTestWidget({AsyncValue<WeeklyPlan?>? planValue}) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const PlanConfirmationPage(),
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        planNotifierProvider.overrideWith(() => PlanNotifierMock(planValue ?? AsyncValue.data(testPlan))),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
        ],
      ),
    );
  }

  testWidgets('PlanConfirmationPage shows plan details', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Here’s your starting plan'), findsOneWidget);
    expect(find.text('8.0 hours'), findsOneWidget);
    expect(find.text('3 per week'), findsOneWidget);
    expect(find.text('Daily Movement'), findsOneWidget);
    expect(find.text('10000 steps'), findsOneWidget);
  });

  testWidgets('PlanConfirmationPage shows loading state', (tester) async {
    await tester.pumpWidget(createTestWidget(planValue: const AsyncValue.loading()));
    
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
