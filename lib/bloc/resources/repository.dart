import 'dart:async';
import 'api.dart';
import 'package:todolist/models/user.dart';

class Repository {
  final apiProvider = ApiProvider();

  Future<User> registerUser(String username, String password, String email) 
    => apiProvider.registerUser(username, password, email);

  Future signinUser(String username, String password, String apiKey) 
    => apiProvider.signinUser(username, password, apiKey);
  
  Future getUserTasks(String apiKey) 
    => apiProvider.getUserTasks(apiKey);

  Future<Null> addUserTask(String apiKey, String taskName, String groupName) async {
    apiProvider.addUserTask(apiKey, taskName, groupName);
  }

  Future getSubTasks(String taskKey) 
    => apiProvider.getSubTasks(taskKey);

  Future<Null> addSubTask(String taskKey, String subtaskName, String notes) async {
    apiProvider.addSubTask(taskKey, subtaskName, notes);
  }

}