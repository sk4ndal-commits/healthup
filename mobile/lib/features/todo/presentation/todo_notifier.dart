import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile_app/features/todo/data/todo_repository.dart';

part 'todo_notifier.g.dart';

@riverpod
class TodoList extends _$TodoList {
  @override
  FutureOr<List<dynamic>> build() async {
    return ref.watch(todoRepositoryProvider).getTodos();
  }

  Future<void> addTodo(String title) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(todoRepositoryProvider).createTodo(title);
      return ref.read(todoRepositoryProvider).getTodos();
    });
  }

  Future<void> toggleTodo(dynamic todo) async {
    state = await AsyncValue.guard(() async {
      // Assuming todo has id, title, and isDone properties as per TodoUpdateRequest
      await ref.read(todoRepositoryProvider).updateTodo(
            todo.id as int,
            todo.title as String,
            !(todo.isDone as bool),
          );
      return ref.read(todoRepositoryProvider).getTodos();
    });
  }

  Future<void> deleteTodo(int id) async {
    state = await AsyncValue.guard(() async {
      await ref.read(todoRepositoryProvider).deleteTodo(id);
      return ref.read(todoRepositoryProvider).getTodos();
    });
  }
}
