import 'package:test/test.dart';
import 'package:api_client/api_client.dart';

/// tests for TodoApi
void main() {
  final instance = ApiClient().getTodoApi();

  group(TodoApi, () {
    //Future apiV1TodoGet() async
    test('test apiV1TodoGet', () async {
      // TODO
    });

    //Future apiV1TodoIdDelete(int id) async
    test('test apiV1TodoIdDelete', () async {
      // TODO
    });

    //Future apiV1TodoIdGet(int id) async
    test('test apiV1TodoIdGet', () async {
      // TODO
    });

    //Future apiV1TodoIdPut(int id, { TodoUpdateRequest todoUpdateRequest }) async
    test('test apiV1TodoIdPut', () async {
      // TODO
    });

    //Future apiV1TodoIdTogglePost(int id) async
    test('test apiV1TodoIdTogglePost', () async {
      // TODO
    });

    //Future apiV1TodoPost({ TodoCreateRequest todoCreateRequest }) async
    test('test apiV1TodoPost', () async {
      // TODO
    });
  });
}
