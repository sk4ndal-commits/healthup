import 'package:test/test.dart';
import 'package:api_client/api_client.dart';

/// tests for AuthApi
void main() {
  final instance = ApiClient().getAuthApi();

  group(AuthApi, () {
    //Future apiV1AuthChangePasswordPost({ ChangePasswordRequest changePasswordRequest }) async
    test('test apiV1AuthChangePasswordPost', () async {
      // TODO
    });

    //Future apiV1AuthForgotPasswordPost({ ForgotPasswordRequest forgotPasswordRequest }) async
    test('test apiV1AuthForgotPasswordPost', () async {
      // TODO
    });

    //Future apiV1AuthLoginPost({ LoginRequest loginRequest }) async
    test('test apiV1AuthLoginPost', () async {
      // TODO
    });

    //Future apiV1AuthLogoutPost({ RefreshRequest refreshRequest }) async
    test('test apiV1AuthLogoutPost', () async {
      // TODO
    });

    //Future apiV1AuthRefreshPost({ RefreshRequest refreshRequest }) async
    test('test apiV1AuthRefreshPost', () async {
      // TODO
    });

    //Future apiV1AuthRegisterPost({ RegisterRequest registerRequest }) async
    test('test apiV1AuthRegisterPost', () async {
      // TODO
    });

    //Future apiV1AuthResetPasswordPost({ ResetPasswordRequest resetPasswordRequest }) async
    test('test apiV1AuthResetPasswordPost', () async {
      // TODO
    });
  });
}
