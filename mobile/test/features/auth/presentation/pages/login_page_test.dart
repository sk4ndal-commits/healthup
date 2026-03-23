import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/auth/auth_repository.dart';
import 'package:mobile_app/features/auth/presentation/pages/login_page.dart';
import 'package:mobile_app/core/widgets/custom_text_field.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_page_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    when(mockRepository.isAuthenticated()).thenAnswer((_) async => false);
  });

  Widget createLoginPage() {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepository),
      ],
      child: const MaterialApp(
        home: LoginPage(),
      ),
    );
  }

  group('LoginPage', () {
    testWidgets('renders all fields and login button', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginPage());

      expect(find.text('Login'), findsAtLeast(1));
      expect(find.byType(CustomTextField), findsNWidgets(3)); // Tenant, Email and Password
      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    });

    testWidgets('shows validation errors when fields are empty', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginPage());

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump();

      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('calls login on notifier when form is valid', (WidgetTester tester) async {
      when(mockRepository.login(any, any)).thenAnswer((_) async {});
      
      await tester.pumpWidget(createLoginPage());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(CustomTextField).at(1), 'test@example.com');
      await tester.enterText(find.byType(CustomTextField).at(2), 'password123');
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump(); // Start _login
      await tester.pump(const Duration(milliseconds: 100)); // Allow async login to complete

      verify(mockRepository.login('test@example.com', 'password123')).called(1);
    });

    testWidgets('shows loading indicator when state is loading', (WidgetTester tester) async {
      when(mockRepository.login(any, any)).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 1));
      });

      await tester.pumpWidget(createLoginPage());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(CustomTextField).at(1), 'test@example.com');
      await tester.enterText(find.byType(CustomTextField).at(2), 'password123');
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump(); // Start _login, sets _isLoading = true

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      await tester.pump(const Duration(seconds: 1)); // Wait for login to complete
      await tester.pump(); // Final rebuild after login completes and sets _isLoading = false
    });
  });
}
