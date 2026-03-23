import 'package:api_client/api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/todo/data/todo_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'todo_repository_test.mocks.dart';

@GenerateMocks([TodoApi])
void main() {
  late TodoRepository repository;
  late MockTodoApi mockApi;

  setUp(() {
    mockApi = MockTodoApi();
    repository = TodoRepository(mockApi);
  });

  group('TodoRepository', () {
    test('getTodos returns list of todos', () async {
      // Currently returns empty list as placeholder
      final result = await repository.getTodos();
      expect(result, isEmpty);
    });

    test('createTodo calls api', () async {
      when(mockApi.apiV1TodoPost(todoCreateRequest: anyNamed('todoCreateRequest')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: 200,
              ));

      await repository.createTodo('New');

      verify(mockApi.apiV1TodoPost(todoCreateRequest: anyNamed('todoCreateRequest'))).called(1);
    });

    test('deleteTodo calls api', () async {
      when(mockApi.apiV1TodoIdDelete(id: 1)).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
          ));

      await repository.deleteTodo(1);

      verify(mockApi.apiV1TodoIdDelete(id: 1)).called(1);
    });
  });
}
