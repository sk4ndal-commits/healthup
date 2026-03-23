import 'package:api_client/api_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile_app/core/api/api_provider.dart';
import 'package:mobile_app/core/services/secure_storage_service.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final AuthApi _authApi;
  final SecureStorageService _storage;

  AuthRepository(this._authApi, this._storage);

  Future<void> login(String email, String password) async {
    await _authApi.apiV1AuthLoginPost(
      loginRequest: LoginRequest((b) => b
        ..email = email
        ..password = password),
    );

    // TODO: The generated API client currently returns Response<void>
    // but the backend returns tokens. This needs fixing in the OpenAPI spec
    // or generator config. For now, we assume tokens are handled via cookies
    // or the spec needs to be updated to return a LoginResponse model.
  }

  Future<void> register(String email, String password, String accountName) async {
    await _authApi.apiV1AuthRegisterPost(
      registerRequest: RegisterRequest((b) => b
        ..email = email
        ..password = password
        ..accountName = accountName),
    );
  }

  Future<void> logout() async {
    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken != null) {
      try {
        await _authApi.apiV1AuthLogoutPost(
          refreshRequest: RefreshRequest((b) => b..refreshToken = refreshToken),
        );
      } catch (_) {
        // Ignore logout errors, we're clearing local state anyway
      }
    }
    await _storage.clearAll();
  }

  Future<void> forgotPassword(String email) async {
    await _authApi.apiV1AuthForgotPasswordPost(
      forgotPasswordRequest: ForgotPasswordRequest((b) => b..email = email),
    );
  }

  Future<void> resetPassword(String email, String token, String newPassword) async {
    await _authApi.apiV1AuthResetPasswordPost(
      resetPasswordRequest: ResetPasswordRequest((b) => b
        ..email = email
        ..token = token
        ..newPassword = newPassword),
    );
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    await _authApi.apiV1AuthChangePasswordPost(
      changePasswordRequest: ChangePasswordRequest((b) => b
        ..oldPassword = oldPassword
        ..newPassword = newPassword),
    );
  }

  Future<bool> isAuthenticated() async {
    final token = await _storage.getAccessToken();
    return token != null;
  }
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final authApi = ref.watch(authApiProvider);
  final storage = ref.watch(secureStorageServiceProvider);
  return AuthRepository(authApi, storage);
}
