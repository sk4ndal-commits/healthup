import 'package:api_client/api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/auth/auth_repository.dart';
import 'package:mobile_app/core/services/secure_storage_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'auth_repository_test.mocks.dart';

@GenerateMocks([AuthApi, SecureStorageService])
void main() {
  late AuthRepository repository;
  late MockAuthApi mockAuthApi;
  late MockSecureStorageService mockStorage;

  setUp(() {
    mockAuthApi = MockAuthApi();
    mockStorage = MockSecureStorageService();
    repository = AuthRepository(mockAuthApi, mockStorage);
  });

  group('AuthRepository', () {
    test('login calls api', () async {
      when(mockAuthApi.apiV1AuthLoginPost(loginRequest: anyNamed('loginRequest')))
          .thenAnswer((_) async => Response(requestOptions: RequestOptions(path: ''), statusCode: 200));

      await repository.login('test@example.com', 'password');

      verify(mockAuthApi.apiV1AuthLoginPost(loginRequest: anyNamed('loginRequest'))).called(1);
    });

    test('logout clears storage', () async {
      when(mockStorage.getRefreshToken()).thenAnswer((_) async => 'refresh');
      when(mockAuthApi.apiV1AuthLogoutPost(refreshRequest: anyNamed('refreshRequest')))
          .thenAnswer((_) async => Response(requestOptions: RequestOptions(path: ''), statusCode: 200));

      await repository.logout();

      verify(mockStorage.getRefreshToken()).called(1);
      verify(mockAuthApi.apiV1AuthLogoutPost(refreshRequest: anyNamed('refreshRequest'))).called(1);
      verify(mockStorage.clearAll()).called(1);
    });

    test('isAuthenticated returns true when token exists', () async {
      when(mockStorage.getAccessToken()).thenAnswer((_) async => 'token');

      final result = await repository.isAuthenticated();

      expect(result, isTrue);
      verify(mockStorage.getAccessToken()).called(1);
    });

    test('isAuthenticated returns false when token is null', () async {
      when(mockStorage.getAccessToken()).thenAnswer((_) async => null);

      final result = await repository.isAuthenticated();

      expect(result, isFalse);
      verify(mockStorage.getAccessToken()).called(1);
    });
  });
}
