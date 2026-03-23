import 'package:test/test.dart';
import 'package:api_client/api_client.dart';

/// tests for AdminApi
void main() {
  final instance = ApiClient().getAdminApi();

  group(AdminApi, () {
    //Future apiV1AdminUsersGet() async
    test('test apiV1AdminUsersGet', () async {
      // TODO
    });

    //Future apiV1AdminUsersIdGet(int id) async
    test('test apiV1AdminUsersIdGet', () async {
      // TODO
    });

    //Future apiV1AdminUsersIdResetPasswordPost(int id, { AdminResetPasswordRequest adminResetPasswordRequest }) async
    test('test apiV1AdminUsersIdResetPasswordPost', () async {
      // TODO
    });

    //Future apiV1AdminUsersIdToggleActivePost(int id) async
    test('test apiV1AdminUsersIdToggleActivePost', () async {
      // TODO
    });

    //Future apiV1AdminUsersPost({ CreateUserRequest createUserRequest }) async
    test('test apiV1AdminUsersPost', () async {
      // TODO
    });
  });
}
