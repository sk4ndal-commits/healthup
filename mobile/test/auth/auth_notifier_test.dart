import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/auth/auth_notifier.dart';
import 'package:mobile_app/auth/auth_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_notifier_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('AuthNotifier', () {
    test('initial state is unauthenticated when repo returns false', () async {
      when(mockRepository.isAuthenticated()).thenAnswer((_) async => false);

      final container = createContainer();
      
      // Wait for build
      await container.read(authNotifierProvider.future);

      expect(container.read(authNotifierProvider).value?.status, AuthStatus.unauthenticated);
      verify(mockRepository.isAuthenticated()).called(1);
    });

    test('initial state is authenticated when repo returns true', () async {
      when(mockRepository.isAuthenticated()).thenAnswer((_) async => true);

      final container = createContainer();
      
      // Wait for build to complete
      await container.read(authNotifierProvider.future);

      expect(container.read(authNotifierProvider).value?.status, AuthStatus.authenticated);
      verify(mockRepository.isAuthenticated()).called(1);
    });

    test('login updates state to authenticated on success', () async {
      when(mockRepository.isAuthenticated()).thenAnswer((_) async => false);
      when(mockRepository.login(any, any)).thenAnswer((_) async {});

      final container = createContainer();
      final notifier = container.read(authNotifierProvider.notifier);

      await notifier.login('test@example.com', 'password');

      expect(container.read(authNotifierProvider).value?.status, AuthStatus.authenticated);
      verify(mockRepository.login('test@example.com', 'password')).called(1);
    });

    test('logout updates state to unauthenticated', () async {
      when(mockRepository.isAuthenticated()).thenAnswer((_) async => true);
      when(mockRepository.logout()).thenAnswer((_) async {});

      final container = createContainer();
      final notifier = container.read(authNotifierProvider.notifier);

      await notifier.logout();

      expect(container.read(authNotifierProvider).value?.status, AuthStatus.unauthenticated);
      verify(mockRepository.logout()).called(1);
    });
  });
}
