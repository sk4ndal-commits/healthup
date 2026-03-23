import 'package:test/test.dart';
import 'package:api_client/api_client.dart';

/// tests for CultureApi
void main() {
  final instance = ApiClient().getCultureApi();

  group(CultureApi, () {
    //Future cultureSetCulturePost({ String culture, String returnUrl }) async
    test('test cultureSetCulturePost', () async {
      // TODO
    });
  });
}
