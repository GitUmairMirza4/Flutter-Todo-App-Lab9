
class Todo {
  final int userId;
  final int? id;
  final String title;
  final bool completed;

  Todo({
    required this.userId,
    this.id,
    required this.title,
    required this.completed,
  });

  // Convert JSON into Todo object
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }

  // Convert Todo object into JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'completed': completed,
    };
  }
}
