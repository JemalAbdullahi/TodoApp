import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/models/subtasks.dart';
import 'package:todolist/models/tasks.dart';
import 'dart:convert';
import 'package:todolist/models/user.dart';

class ApiProvider {
  Client client = Client();
  //final _apiKey = 'your_api_key';

  Future<User> registerUser(
      String username, String password, String email) async {
    final response = await client.post("http://10.0.2.2:5000/api/register",
        // headers: "",
        body: jsonEncode({
          "emailaddress": email,
          "username": username,
          "password": password,
        }));
    final Map result = json.decode(response.body);
    if (response.statusCode == 201) {
      // If the call to the server was successful, parse the JSON
      await saveApiKey(result["data"]["api_key"]);
      return User.fromJson(result["data"]);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future signinUser(String username, String password, String apiKey) async {
    final response = await client.post("http://10.0.2.2:5000/api/signin",
        headers: {"Authorization": apiKey},
        body: jsonEncode({
          "username": username,
          "password": password,
        }));
    final Map result = json.decode(response.body);
    if (response.statusCode == 201) {
      // If the call to the server was successful, parse the JSON
      await saveApiKey(result["data"]["api_key"]);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<List<Task>> getUserTasks(String apiKey) async {
    final response = await client.get(
      "http://10.0.2.2:5000/api/tasks",
      headers: {"Authorization": apiKey},
    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 201) {
      // If the call to the server was successful, parse the JSON
      List<Task> tasks = [];
      for (Map json_ in result["data"]) {
        try {
          tasks.add(Task.fromJson(json_));
        } catch (Exception) {
          print(Exception);
        }
      }
      return tasks;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load tasks');
    }
  }

  Future addUserTask(
      String apiKey, String taskName, String groupName, int index) async {
    final response = await client.post("http://10.0.2.2:5000/api/tasks",
        headers: {"Authorization": apiKey},
        body: jsonEncode({
          "title": taskName,
          "note": "",
          "completed": false,
          "repeats": "",
          "group": groupName,
          "reminders": "",
          "index": index
        }));
    if (response.statusCode == 201) {
      print("Task " + taskName + " added");
    } else {
      // If that call was not successful, throw an error.
      print(json.decode(response.body));
      throw Exception('Failed to post tasks');
    }
  }

  Future updateUserTask(Task task) async {
    final response = await client.put("http://10.0.2.2:5000/api/tasks",
        headers: {"Authorization": task.taskKey},
        body: jsonEncode({
          "title": task.title,
          "note": task.note,
          "repeats": task.repeats,
          "completed": task.completed,
          "group": task.group,
          "reminders": task.reminders,
          "index": task.index
        }));
    if (response.statusCode == 201) {
      print("Task " + task.title + " Updated");
    } else {
      // If that call was not successful, throw an error.
      print(json.decode(response.body));
      throw Exception('Failed to update tasks');
    }
  }

  Future deleteUserTask(String taskKey) async {
    final response = await client.delete(
      "http://10.0.2.2:5000/api/tasks",
      headers: {"Authorization": taskKey},
    );
    if (response.statusCode == 201) {
      // If the call to the server was successful
      print("Task deleted");
    } else {
      // If that call was not successful, throw an error.
      print(json.decode(response.body));
      throw Exception('Failed to delete task');
    }
  }

  Future<List<SubTask>> getSubTasks(String taskKey) async {
    final response = await client.get(
      "http://10.0.2.2:5000/api/subtasks",
      headers: {"Authorization": taskKey},
    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 201) {
      // If the call to the server was successful, parse the JSON
      List<SubTask> subtasks = [];
      for (Map json_ in result["data"]) {
        try {
          subtasks.add(SubTask.fromJson(json_));
        } catch (Exception) {
          print(Exception);
        }
      }
      return subtasks;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load tasks');
    }
  }

  Future addSubTask(
      String taskKey, String subtaskName, String notes, int index) async {
    final response = await client.post("http://10.0.2.2:5000/api/subtasks",
        headers: {"Authorization": taskKey},
        body: jsonEncode({
          "title": subtaskName,
          "note": notes,
          "completed": false,
          "repeats": "",
          "group": "",
          "reminders": "",
          "index": index
        }));
    if (response.statusCode == 201) {
      print("SubTask " + subtaskName + " added");
    } else {
      // If that call was not successful, throw an error.
      print(json.decode(response.body));
      throw Exception('Failed to load tasks');
    }
  }

  Future updateSubTask(SubTask subtask) async {
    final response = await client.put("http://10.0.2.2:5000/api/subtasks",
        headers: {"Authorization": subtask.subtaskKey},
        body: jsonEncode({
          "title": subtask.title,
          "note": subtask.note,
          "repeats": subtask.repeats,
          "completed": subtask.completed,
          "group": subtask.group,
          "reminders": subtask.reminders,
          "index": subtask.index
        }));
    if (response.statusCode == 201) {
      print("SubTask " + subtask.title + " Updated");
    } else {
      // If that call was not successful, throw an error.
      print(json.decode(response.body));
      throw Exception('Failed to update tasks');
    }
  }

  Future deleteSubTask(String subtaskKey) async {
    final response = await client.delete(
      "http://10.0.2.2:5000/api/subtasks",
      headers: {"Authorization": subtaskKey},
    );
    if (response.statusCode == 201) {
      // If the call to the server was successful
      print("SubTask deleted");
    } else {
      // If that call was not successful, throw an error.
      print(json.decode(response.body));
      throw Exception('Failed to delete subtask');
    }
  }

  saveApiKey(String apiKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('API_Token', apiKey);
  }
}
