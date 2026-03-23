import 'package:test/test.dart';
import 'package:api_client/api_client.dart';

/// tests for HealthApi
void main() {
  final instance = ApiClient().getHealthApi();

  group(HealthApi, () {
    //Future apiV1HealthGet() async
    test('test apiV1HealthGet', () async {
      // TODO
    });
  });
}
