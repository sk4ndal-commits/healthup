import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/todo/data/todo_repository.dart';
import 'package:mobile_app/features/todo/presentation/todo_notifier.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'todo_notifier_test.mocks.dart';

@GenerateMocks([TodoRepository])
void main() {
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        todoRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('TodoList Notifier', () {
    test('initial state loads todos from repository', () async {
      final todos = [{'id': 1, 'title': 'Test', 'isDone': false}];
      when(mockRepository.getTodos()).thenAnswer((_) async => todos);

      final container = createContainer();
      
      // Wait for build
      await container.read(todoListProvider.future);

      expect(container.read(todoListProvider).value, todos);
      verify(mockRepository.getTodos()).called(1);
    });

    test('addTodo calls repository and refreshes state', () async {
      when(mockRepository.getTodos()).thenAnswer((_) async => []);
      when(mockRepository.createTodo(any)).thenAnswer((_) async {});

      final container = createContainer();
      final notifier = container.read(todoListProvider.notifier);

      // Change mock behavior for refresh
      final newTodos = [{'id': 1, 'title': 'New', 'isDone': false}];
      when(mockRepository.getTodos()).thenAnswer((_) async => newTodos);

      await notifier.addTodo('New');

      expect(container.read(todoListProvider).value, newTodos);
      verify(mockRepository.createTodo('New')).called(1);
      verify(mockRepository.getTodos()).called(greaterThanOrEqualTo(1));
    });

    test('deleteTodo calls repository and refreshes state', () async {
      final todos = [{'id': 1, 'title': 'Test', 'isDone': false}];
      when(mockRepository.getTodos()).thenAnswer((_) async => todos);
      when(mockRepository.deleteTodo(any)).thenAnswer((_) async {});

      final container = createContainer();
      final notifier = container.read(todoListProvider.notifier);

      // Change mock behavior for refresh
      when(mockRepository.getTodos()).thenAnswer((_) async => []);

      await notifier.deleteTodo(1);

      expect(container.read(todoListProvider).value, isEmpty);
      verify(mockRepository.deleteTodo(1)).called(1);
    });
  });
}
