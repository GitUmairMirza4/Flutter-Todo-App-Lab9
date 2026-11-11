
import 'package:flutter/material.dart';

import '../models/todo.dart';
import '../services/todo_service.dart';

class TodoProvider extends ChangeNotifier {
  final TodoService _service = TodoService();

  List<Todo> todos = [];

  bool isLoading = false;
  String? errorMessage;

  // GET: Fetch todos
  Future<void> fetchTodos() async {
    isLoading = true;
    errorMessage = null;

    notifyListeners();

    try {
      todos = await _service.getTodos();
    } catch (e) {
      errorMessage = 'Something went wrong.\n$e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Count completed todos
  int get completedCount {
    return todos.where((todo) => todo.completed).length;
  }

  // POST: Add a new todo
  Future<bool> addTodo(String title) async {
    try {
      final newTodo = await _service.createTodo(
        Todo(
          userId: 1,
          title: title,
          completed: false,
        ),
      );

      todos.insert(0, newTodo);

      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('Add todo failed: $e');
      return false;
    }
  }
}
