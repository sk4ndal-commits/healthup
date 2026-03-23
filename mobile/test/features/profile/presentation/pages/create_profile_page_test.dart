import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/profile/data/profile_repository.dart';
import 'package:mobile_app/features/profile/domain/user_profile.dart';
import 'package:mobile_app/features/profile/presentation/pages/create_profile_page.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'create_profile_page_test.mocks.dart';

import 'package:go_router/go_router.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

@GenerateMocks([ProfileRepository])
void main() {
  late MockProfileRepository mockRepo;

  setUp(() {
    mockRepo = MockProfileRepository();
  });

  Widget createTestWidget() {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const CreateProfilePage(),
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        profileRepositoryProvider.overrideWith((ref) => Future.value(mockRepo)),
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

  testWidgets('Selecting a goal is required to submit profile', (tester) async {
    when(mockRepo.getProfile()).thenAnswer((_) async => null);
    
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Fill name but don't select goal
    await tester.enterText(find.byType(TextFormField).first, 'John Doe');
    
    // Tap submit button
    final submitButton = find.text('Continue');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pump();

    // Check for snackbar or error message
    expect(find.text('Please select a primary goal.'), findsOneWidget);
    
    // Verify repo was not called
    verifyNever(mockRepo.createProfile(
      displayName: anyNamed('displayName'),
      primaryGoal: anyNamed('primaryGoal'),
    ));
  });

  testWidgets('Selecting a goal and submitting profile works', (tester) async {
    when(mockRepo.getProfile()).thenAnswer((_) async => null);
    when(mockRepo.createProfile(
      displayName: anyNamed('displayName'),
      primaryGoal: anyNamed('primaryGoal'),
      ageRange: anyNamed('ageRange'),
      gender: anyNamed('gender'),
      heightCm: anyNamed('heightCm'),
      weightKg: anyNamed('weightKg'),
      workStyle: anyNamed('workStyle'),
      exerciseAvailability: anyNamed('exerciseAvailability'),
      scheduleStability: anyNamed('scheduleStability'),
      derailers: anyNamed('derailers'),
      preferredWorkoutStyle: anyNamed('preferredWorkoutStyle'),
      notes: anyNamed('notes'),
    )).thenAnswer((_) async => UserProfile(
      userId: 'test-id',
      displayName: 'John Doe',
      primaryGoal: PrimaryGoal.energy,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Fill name
    await tester.enterText(find.byType(TextFormField).first, 'John Doe');
    
    // Select a goal (e.g., Energy)
    final goalFinder = find.text('Feel more energetic');
    await tester.ensureVisible(goalFinder);
    await tester.tap(goalFinder);
    await tester.pump();

    // Select availability (e.g., 3-4)
    final availabilityFinder = find.text('3–4 days');
    await tester.ensureVisible(availabilityFinder);
    await tester.tap(availabilityFinder);
    await tester.pump();

    // Select stability (e.g., Stable)
    final stabilityFinder = find.text('Stable');
    await tester.ensureVisible(stabilityFinder);
    await tester.tap(stabilityFinder);
    await tester.pump();

    // Select derailer (e.g., Stress)
    final derailerFinder = find.text('Stress');
    await tester.ensureVisible(derailerFinder);
    await tester.tap(derailerFinder);
    await tester.pump();

    // Tap submit button
    final submitButton = find.text('Continue');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Verify repo was called with correct goal
    verify(mockRepo.createProfile(
      displayName: 'John Doe',
      primaryGoal: PrimaryGoal.energy,
      ageRange: anyNamed('ageRange'),
      gender: anyNamed('gender'),
      heightCm: anyNamed('heightCm'),
      weightKg: anyNamed('weightKg'),
      workStyle: anyNamed('workStyle'),
      exerciseAvailability: ExerciseAvailability.days3to4,
      scheduleStability: ScheduleStability.stable,
      derailers: [Derailer.stress],
      preferredWorkoutStyle: anyNamed('preferredWorkoutStyle'),
      minMovementSteps: anyNamed('minMovementSteps'),
      minExerciseMinutes: anyNamed('minExerciseMinutes'),
      minSleepHours: anyNamed('minSleepHours'),
      minNutritionAnchor: anyNamed('minNutritionAnchor'),
      notes: anyNamed('notes'),
    )).called(1);
  });
}
