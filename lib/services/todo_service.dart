
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/todo.dart';

class TodoService {
  final String baseUrl =
      'https://jsonplaceholder.typicode.com';

  // GET: Fetch all todos
  Future<List<Todo>> getTodos() async {
    final url = Uri.parse('$baseUrl/todos');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((item) => Todo.fromJson(item))
          .toList();
    } else {
      throw Exception(
        'Failed to load todos: ${response.statusCode}',
      );
    }
  }

  // POST: Create a new todo
  Future<Todo> createTodo(Todo todo) async {
    final url = Uri.parse('$baseUrl/todos');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(todo.toJson()),
    );

    if (response.statusCode == 201) {
      return Todo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to create todo: ${response.statusCode}',
      );
    }
  }
}
