import 'package:sandbox_core/src/providers/back_request.dart';
import 'package:sandbox_core/src/source/http_manegment/http_request_models.dart';

void main() {
  // Using the JSON Placeholder to demonstrate the package
  const String getJsonUrl = 'https://jsonplaceholder.typicode.com/todos/1';
  const String getListOfJsonUrl = 'https://jsonplaceholder.typicode.com/todos';

  SandHttp.makeJsonGetRequest<Task, Map<String, dynamic>, void>(
    path: getJsonUrl,
    config: _httpConfig,
    fromMapFunc: (map) => Task.fromMap(map),
    onError: (_, httpErrorModel) {
      // Manege the error here
    },
  );

  SandHttp.makeListOfJsonGetRequest<Task, Map<String, dynamic>, void>(
    path: getListOfJsonUrl,
    config: _httpConfig,
    fromMapFunc: (map) => Task.fromMap(map),
    onError: (_, httpErrorModel) {
      // Manege the error here
    },
  );
}

class Task {
  final String userId;
  final int id;
  final int title;
  final bool completed;
  const Task({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      userId: map['userId'] ?? '',
      id: map['id']?.toInt() ?? 0,
      title: map['title']?.toInt() ?? 0,
      completed: map['completed'] ?? false,
    );
  }

  @override
  String toString() {
    return 'Task(userId: $userId, id: $id, title: $title, completed: $completed)';
  }
}

final HttpRequestConfig _httpConfig = HttpRequestConfig();
