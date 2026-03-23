import 'package:api_client/api_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile_app/core/api/api_provider.dart';

part 'todo_repository.g.dart';

class TodoRepository {
  final TodoApi _api;

  TodoRepository(this._api);

  Future<List<dynamic>> getTodos() async {
    return []; // Placeholder until API is fixed
  }

  Future<void> createTodo(String title) async {
    final request = TodoCreateRequest((b) => b
      ..title = title);
    
    await _api.apiV1TodoPost(todoCreateRequest: request);
  }

  Future<void> updateTodo(int id, String title, bool isCompleted) async {
    final request = TodoUpdateRequest((b) => b
      ..title = title
      ..isDone = isCompleted);
    
    await _api.apiV1TodoIdPut(id: id, todoUpdateRequest: request);
  }

  Future<void> deleteTodo(int id) async {
    await _api.apiV1TodoIdDelete(id: id);
  }
}

@riverpod
TodoRepository todoRepository(TodoRepositoryRef ref) {
  final api = ref.watch(todoApiProvider);
  return TodoRepository(api);
}
