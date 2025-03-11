import 'package:test_app_flutter/emitter/emitter.dart';

class TodoItem {
  final String title;
  final String? description;
  final bool isDone;

  TodoItem({
    required this.title,
    this.description,
    this.isDone = false,
  });
}

enum AppState {
  todoEditor,
  exercise2,
  exercise3,
}

class AppController {
  final appStateEmitter = Emitter<AppState>(initialValue: AppState.todoEditor);

  final todoItemsEmitter = Emitter<List<TodoItem>>(initialValue: [
    TodoItem(title: 'First item', description: 'This is the first item', isDone: true),
    TodoItem(title: 'Second item', description: 'This is the second item'),
    TodoItem(title: 'Third item', description: 'This is the third item'),
  ]);

  void changeAppState(AppState state) {
    appStateEmitter.value = state;
  }

  void addTodoItem(TodoItem item) {
    final currentItems = List<TodoItem>.from(todoItemsEmitter.value);
    currentItems.add(item);
    todoItemsEmitter.value = currentItems;
  }

  Future<void> executeRpcCall() async {
    await Future.delayed(Duration(seconds: 2));
  }
}
