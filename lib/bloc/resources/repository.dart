import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:todolist/models/subtasks.dart';
import 'package:todolist/models/tasks.dart';

import 'api.dart';
import 'package:todolist/models/user.dart';

class Repository {
  final apiProvider = ApiProvider();

  Future<User> registerUser(
          String username,
          String password,
          String email,
          String firstname,
          String lastname,
          String phonenumber,
          ImageProvider avatar) =>
      apiProvider.registerUser(
          username, password, email, firstname, lastname, phonenumber, avatar);

  Future signinUser(String username, String password, String apiKey) =>
      apiProvider.signinUser(username, password, apiKey);

  Future updateUserProfile(
          String currentPassword,
          String newPassword,
          String email,
          String username,
          String firstname,
          String lastname,
          String phonenumber,
          ImageProvider avatar) =>
      apiProvider.updateUserProfile(currentPassword, newPassword, email,
          username, firstname, lastname, phonenumber, avatar);

  Future<String> getApiKey() => apiProvider.getApiKey();

  Future getUserGroups() => apiProvider.getUserGroups();

  Future getGroupMembers(String groupKey) =>
      apiProvider.getGroupMembers(groupKey);

  Future getTasks(String groupKey) => apiProvider.getTasks(groupKey);

  Future<Null> addTask(
      String taskName, String groupKey, int index, bool completed) async {
    apiProvider.addTask(taskName, groupKey, index, completed);
  }

  Future<Null> updateTask(Task task) async {
    apiProvider.updateTask(task);
  }

  FutureOr<dynamic> deleteTask(String taskKey) async {
    apiProvider.deleteTask(taskKey);
  }

  Future getSubtasks(String taskKey) => apiProvider.getSubtasks(taskKey);

  Future<Null> addSubtask(
      String taskKey, String subtaskName, int index, bool completed) async {
    apiProvider.addSubtask(taskKey, subtaskName, index, completed);
  }

  Future<Null> updateSubtask(Subtask subtask) async {
    apiProvider.updateSubtask(subtask);
  }

  FutureOr<dynamic> deleteSubtask(String subtaskKey) async {
    apiProvider.deleteSubtask(subtaskKey);
  }

  Future searchUser(String searchTerm) => apiProvider.searchUser(searchTerm);
}

final repository = Repository();
