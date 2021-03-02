import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/models/group.dart';
import 'package:todolist/models/groupmember.dart';
import 'package:todolist/models/subtasks.dart';
import 'package:todolist/models/tasks.dart';
import 'dart:convert';
import 'package:todolist/models/user.dart';

class ApiProvider {
  Client client = Client();
  static String baseURL = "http://10.0.2.2:5000/api";
  String signinURL = baseURL + "/signin";
  String userURL = baseURL + "/user";
  String taskURL = baseURL + "/tasks";
  String subtaskURL = baseURL + "/subtasks";
  String groupURL = baseURL + "/group";
  String groupmemberURL = baseURL + "/groupmember";
  String searchURL = baseURL + "/search";

  String apiKey;

//User CRUD Functions
  //Sign Up
  Future<User> registerUser(
      String username,
      String password,
      String email,
      String firstname,
      String lastname,
      String phonenumber,
      ImageProvider avatar) async {
    final response = await client.post(userURL,
        // headers: "",
        body: jsonEncode({
          "emailaddress": email,
          "username": username,
          "password": password,
          "firstname": firstname,
          "lastname": lastname,
          "phonenumber": phonenumber,
          "avatar": avatar,
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

  //Sign In
  Future signinUser(String username, String password, String apiKey) async {
    final response = await client.post(signinURL,
        headers: {"Authorization": apiKey},
        body: jsonEncode({
          "username": username,
          "password": password,
        }));
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      await saveApiKey(result["data"]["api_key"]);
      return User.fromJson(result["data"]);
    } else {
      // If that call was not successful, throw an error.
      throw Exception(result["message"]);
    }
  }

  // Edit Profile
  Future updateUserProfile(
      String currentPassword,
      String newPassword,
      String email,
      String username,
      String firstname,
      String lastname,
      String phonenumber,
      ImageProvider avatar) async {
    final response = await client.put(userURL,
        headers: {"Authorization": apiKey},
        body: jsonEncode({
          "currentPassword": currentPassword,
          "newPassword": newPassword,
          "email": email,
          "username": username,
          "firstname": firstname,
          "lastname": lastname,
          "phonenumber": phonenumber,
          "avatar": avatar,
        }));
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      print("User Profile Updated");
      return User.fromJson(result["data"]);
    } else {
      // If that call was not successful, throw an error.
      print(json.decode(response.body));
      throw Exception(result["Message"]);
    }
  }

//Group CRUD Functions
  // Get User's Group's
  Future<List<Group>> getUserGroups() async {
    final _apiKey = await getApiKey();
    final response = await client.get(
      groupURL,
      headers: {"Authorization": _apiKey},
    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<Group> groups = [];
      for (Map json_ in result["data"]) {
        try {
          Group group = Group.fromJson(json_);
          group.members = await getGroupMembers(group.groupKey);
          group.tasks = await getTasks(group.groupKey);
          groups.add(group);
        } catch (Exception) {
          print(Exception);
        }
      }
      return groups;
    } else {
      // If that call was not successful, throw an error.
      throw Exception(result["Message"]);
    }
  }

  //GroupMember CRUD Functions
  // Get Group's Members
  Future<List<GroupMember>> getGroupMembers(String groupKey) async {
    final response = await client.get(
      groupmemberURL,
      headers: {"Authorization": groupKey},
    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<GroupMember> groupMembers = [];
      for (Map json_ in result["data"]) {
        try {
          groupMembers.add(GroupMember.fromJson(json_));
        } catch (Exception) {
          print(Exception);
          throw Exception;
        }
      }
      return groupMembers;
    } else {
      // If that call was not successful, throw an error.
      throw Exception(result["Message"]);
    }
  }

//Task CRUD Functions
  // Get Tasks
  Future<List<Task>> getTasks(String groupKey) async {
    final response = await client.get(
      taskURL,
      headers: {"Authorization": groupKey},
    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<Task> tasks = [];
      for (Map json_ in result["data"]) {
        try {
          Task task = Task.fromJson(json_);
          task.subtasks = await getSubtasks(task.taskKey);
          tasks.add(task);
        } catch (Exception) {
          print(Exception);
        }
      }
      return tasks;
    } else {
      // If that call was not successful, throw an error.
      throw Exception(result["Message"]);
    }
  }

  //Add Task
  Future addTask(
      String taskName, String groupKey, int index, bool completed) async {
    final response = await client.post(taskURL,
        headers: {"Authorization": apiKey},
        body: jsonEncode({
          "title": taskName,
          "group_key": groupKey,
          "index": index,
          "completed": completed
        }));
    if (response.statusCode == 201) {
      print("Task " + taskName + " added");
    } else {
      // If that call was not successful, throw an error.
      final Map result = json.decode(response.body);
      print(result["Message"]);
      throw Exception(result["Message"]);
    }
  }

  //Update Task
  Future updateTask(Task task) async {
    final response = await client.put(taskURL,
        headers: {"Authorization": task.taskKey},
        body: jsonEncode({
          "title": task.title,
          "note": task.note,
          "repeats": task.repeats,
          "completed": task.completed,
          "reminders": task.reminders,
          "index": task.index
        }));
    if (response.statusCode == 200) {
      print("Task " + task.title + " Updated");
    } else {
      // If that call was not successful, throw an error.
      print(json.decode(response.body));
      throw Exception('Failed to update tasks');
    }
  }

  //Delete Task
  Future deleteTask(String taskKey) async {
    final response = await client.delete(
      taskURL,
      headers: {"Authorization": taskKey},
    );
    if (response.statusCode == 200) {
      // If the call to the server was successful
      print("Task deleted");
    } else {
      // If that call was not successful, throw an error.
      final Map result = json.decode(response.body);
      throw Exception(result["Message"]);
    }
  }

//Subtask CRUD Functions
  //Get Subtasks
  Future<List<Subtask>> getSubtasks(String taskKey) async {
    final response = await client.get(
      subtaskURL,
      headers: {"Authorization": taskKey},
    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<Subtask> subtasks = [];
      for (Map json_ in result["data"]) {
        try {
          subtasks.add(Subtask.fromJson(json_));
        } catch (Exception) {
          print(Exception);
        }
      }
      return subtasks;
    } else {
      // If that call was not successful, throw an error.
      throw Exception(result["Message"]);
    }
  }

  //Add Subtask
  Future addSubtask(
      String taskKey, String subtaskName, int index, bool completed) async {
    final response = await client.post(subtaskURL,
        headers: {"Authorization": taskKey},
        body: jsonEncode({
          "title": subtaskName,
          "note": "",
          "completed": completed,
          "repeats": "",
          "group": "",
          "reminders": "",
          "index": index
        }));
    if (response.statusCode == 201) {
      print("Subtask " + subtaskName + " added");
    } else {
      // If that call was not successful, throw an error.
      final Map result = json.decode(response.body);
      throw Exception(result["Message"]);
    }
  }

  //Update Subtask
  Future updateSubtask(Subtask subtask) async {
    final response = await client.put(subtaskURL,
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
    if (response.statusCode == 200) {
      print("Subtask " + subtask.title + " Updated");
    } else {
      // If that call was not successful, throw an error.
      final Map result = json.decode(response.body);
      throw Exception(result["Message"]);
    }
  }

  //Delete Subtask
  Future deleteSubtask(String subtaskKey) async {
    final response = await client.delete(
      subtaskURL,
      headers: {"Authorization": subtaskKey},
    );
    if (response.statusCode == 200) {
      // If the call to the server was successful
      print("Subtask deleted");
    } else {
      // If that call was not successful, throw an error.
      final Map result = json.decode(response.body);
      throw Exception(result["Message"]);
    }
  }

  //Search API Calls
  Future<List<GroupMember>> searchUser(String searchTerm) async {
    final response = await client.post(searchURL,
        headers: {"Authorization": apiKey},
        body: jsonEncode({
          "search_term": searchTerm,
        }));
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<GroupMember> searchResults = [];
      for (Map json_ in result["data"]) {
        try {
          searchResults.add(GroupMember.fromJson(json_));
        } catch (Exception) {
          print(Exception);
          throw Exception;
        }
      }
      return searchResults;
    } else {
      // If that call was not successful, throw an error.
      throw Exception(result["message"]);
    }
  }

  //Save API key
  saveApiKey(String apiKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('API_Token', apiKey);
    this.apiKey = apiKey;
  }

  Future<String> getApiKey() async {
    //if(apiKey.isNotEmpty) return apiKey;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('API_Token');
  }
}
