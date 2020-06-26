import 'dart:async';
import 'package:todolist/models/subtasks.dart';
import 'package:todolist/models/tasks.dart';

import 'api.dart';
import 'package:todolist/models/user.dart';

class Repository {
  final apiProvider = ApiProvider();

  Future<User> registerUser(String username, String password, String email) =>
      apiProvider.registerUser(username, password, email);

  Future signinUser(String username, String password, String apiKey) =>
      apiProvider.signinUser(username, password, apiKey);

  Future getUserTasks(String apiKey) => apiProvider.getUserTasks(apiKey);

  Future<Null> addUserTask(
      String apiKey, String taskName, String groupName, int index) async {
    apiProvider.addUserTask(apiKey, taskName, groupName, index);
  }

  Future<Null> updateUserTask(Task task) async {
    apiProvider.updateUserTask(task);
  }

  FutureOr<dynamic> deleteUserTask(String taskKey) async {
    apiProvider.deleteUserTask(taskKey);
  }

  Future getSubTasks(String taskKey) => apiProvider.getSubTasks(taskKey);

  Future<Null> addSubTask(
      String taskKey, String subtaskName, String notes, int index) async {
    apiProvider.addSubTask(taskKey, subtaskName, notes, index);
  }

  Future<Null> updateSubTask(SubTask subtask) async {
    apiProvider.updateSubTask(subtask);
  }

  FutureOr<dynamic> deleteSubTask(String subtaskKey) async {
    apiProvider.deleteSubTask(subtaskKey);
  }
}
