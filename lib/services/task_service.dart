import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';
import '../utils/constants.dart';

class TaskServiceException implements Exception {
  final String message;
  final bool isOffline;
  TaskServiceException(this.message, {this.isOffline = false});
  @override
  String toString() => message;
}

class TaskService {
  Map<String, String> _headers(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  Map<String, dynamic> _decode(String body) {
    if (body.isEmpty) return {};
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  Future<List<TaskModel>> fetchTasks({required String token}) async {
    try {
      final response = await http
          .get(Uri.parse(ApiConfig.tasksEndpoint), headers: _headers(token))
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final body = _decode(response.body);
        final data = body['data'] ?? body;
        final List decoded =
            data['tasks'] ??
            []; // 👈 backend returns { data: { tasks: [...] } }
        return decoded
            .map((e) => TaskModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      throw TaskServiceException(
        'Could not load tasks (${response.statusCode}).',
      );
    } on SocketException {
      throw TaskServiceException('No internet connection.', isOffline: true);
    } on TaskServiceException {
      rethrow;
    } catch (e) {
      throw TaskServiceException('Could not load tasks.', isOffline: true);
    }
  }

  Future<TaskModel> createTask({
    required String token,
    required TaskModel task,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.tasksEndpoint),
            headers: _headers(token),
            body: jsonEncode(task.toJson()),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = _decode(response.body);
        final data = body['data'] ?? body;
        return TaskModel.fromJson(
          Map<String, dynamic>.from(data['task'] ?? data),
        );
      }
      throw TaskServiceException('Could not create the task.');
    } on SocketException {
      throw TaskServiceException('No internet connection.', isOffline: true);
    } on TaskServiceException {
      rethrow;
    } catch (e) {
      throw TaskServiceException('Could not create the task.', isOffline: true);
    }
  }

  Future<TaskModel> updateTask({
    required String token,
    required TaskModel task,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse('${ApiConfig.tasksEndpoint}/${task.id}'),
            headers: _headers(token),
            body: jsonEncode(task.toJson()),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final body = _decode(response.body);
        final data = body['data'] ?? body;
        return TaskModel.fromJson(
          Map<String, dynamic>.from(data['task'] ?? data),
        );
      }
      throw TaskServiceException('Could not update the task.');
    } on SocketException {
      throw TaskServiceException('No internet connection.', isOffline: true);
    } on TaskServiceException {
      rethrow;
    } catch (e) {
      throw TaskServiceException('Could not update the task.', isOffline: true);
    }
  }

  Future<void> deleteTask({
    required String token,
    required String taskId,
  }) async {
    try {
      final response = await http
          .delete(
            Uri.parse('${ApiConfig.tasksEndpoint}/$taskId'),
            headers: _headers(token),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200 || response.statusCode == 204) return;
      throw TaskServiceException('Could not delete the task.');
    } on SocketException {
      throw TaskServiceException('No internet connection.', isOffline: true);
    } on TaskServiceException {
      rethrow;
    } catch (e) {
      throw TaskServiceException('Could not delete the task.', isOffline: true);
    }
  }
}
