import 'dart:async';
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
  //static String baseURL = "https://taskmanager-group-pro.herokuapp.com/api";
  //static Uri baseURL = 'https://taskmanager-group-stage.herokuapp.com/api';
  //static String baseURL = "http://10.0.2.2:5000/api";
  static String stageHost = 'taskmanager-group-stage.herokuapp.com';
  static String productionHost = 'taskmanager-group-pro.herokuapp.com';
  static String localhost = "10.0.2.2:5000";
  Uri signinURL = Uri(scheme: 'https', host: stageHost, path: '/api/signin');
  Uri userURL = Uri(scheme: 'https', host: stageHost, path: '/api/user');
  Uri taskURL = Uri(scheme: 'https', host: stageHost, path: '/api/tasks');
  Uri subtaskURL = Uri(scheme: 'https', host: stageHost, path: '/api/subtasks');
  Uri groupURL = Uri(scheme: 'https', host: stageHost, path: '/api/group');
  Uri groupmemberURL =
      Uri(scheme: 'http', host: stageHost, path: '/api/groupmember');
  Uri searchURL = Uri(scheme: 'http', host: stageHost, path: '/api/search');
  Uri assignedtouserhURL =
      Uri(scheme: 'http', host: stageHost, path: '/api/assignedtouser');

  String apiKey = '';

  // User CRUD Functions
  /// Sign Up
  Future<User> registerUser(String username, String password, String email,
      String firstname, String lastname, String phonenumber, avatar) async {
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
      throw Exception(result["Message"]);
    }
  }

  /// Sign User In using username and password or API_Key
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
      throw Exception(result["Message"]);
    }
  }

  /// Edit Profile
  Future updateUserProfile(
      String currentPassword,
      String newPassword,
      String email,
      String username,
      String firstname,
      String lastname,
      String phonenumber,
      avatar) async {
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
      //print("User Profile Updated");
      return User.fromJson(result["data"]);
    } else {
      // If that call was not successful, throw an error.
      print(json.decode(response.body));
      throw Exception(result["Message"]);
    }
  }

  /// Group CRUD Functions
  /// Get a list of the User's Groups
  Future<List<Group>> getUserGroups() async {
    final _apiKey = await getApiKey();
    List<Group> groups = [];
    if (_apiKey.isNotEmpty) {
      final response = await client.get(
        groupURL,
        headers: {"Authorization": _apiKey},
      );
      final Map result = json.decode(response.body);
      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        for (Map<String, dynamic> json_ in result["data"]) {
          try {
            Group group = Group.fromJson(json_);
            //print("Get User Groups: ${group.groupKey}");
            group.members = await getGroupMembers(group.groupKey);
            //print("--------------End members-------------");
            //group.tasks = await getTasks(group.groupKey);
            //print("--------------End tasks-------------");
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
    return groups;
  }

  /// Add a Group
  Future addGroup(String groupName, bool isPublic) async {
    print(groupURL.toString());
    final response = await client.post(groupURL,
        headers: {"Authorization": apiKey},
        body: jsonEncode({
          "name": groupName,
          "is_public": isPublic,
        }));
    if (response.statusCode == 201) {
      final Map result = json.decode(response.body);
      Group addedGroup = Group.fromJson(result["data"]);
      //print("Group: " + addedGroup.name + " added");
      return addedGroup.groupKey;
    } else {
      // If that call was not successful, throw an error.
      final Map result = json.decode(response.body);
      print(result["Message"]);
      throw Exception(result["Message"]);
    }
  }

  /// Delete a Group
  Future deleteGroup(String groupKey) async {
    final response = await client.delete(
      groupURL,
      headers: {"Authorization": groupKey},
    );
    if (response.statusCode == 200) {
      // If the call to the server was successful
      //print("Group deleted");
    } else {
      // If that call was not successful, throw an error.
      final Map result = json.decode(response.body);
      throw Exception(result["Message"]);
    }
  }

// GroupMember CRUD Functions
  /// Get a list of the Group's Members.
  Future<List<GroupMember>> getGroupMembers(String groupKey) async {
    //print("$groupKey");
    final response = await client.get(
      groupmemberURL,
      headers: {"Authorization": groupKey},
    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<GroupMember> groupMembers = [];
      for (Map<String, dynamic> json_ in result["data"]) {
        try {
          groupMembers.add(GroupMember.fromJson(json_));
        } catch (Exception) {
          print(Exception);
          //throw Exception;
        }
      }
      //print("getGroupMembers: " +groupMembers.toString() +" @" +DateTime.now().toString());
      return groupMembers;
    } else {
      // If that call was not successful, throw an error.
      throw Exception(result["Message"]);
    }
  }

  /// Add a Group Member to the Group.
  /// * GroupKey: Unique Group Identifier
  /// * Username: Group Member's Username to be added
  Future addGroupMember(String groupKey, String username) async {
    print(groupmemberURL.toString());
    final response = await client.post(groupmemberURL,
        headers: {"Authorization": groupKey},
        body: jsonEncode({
          "username": username,
        }));
    final Map result = json.decode(response.body);
    if (response.statusCode == 201) {
      GroupMember addedGroupMember = GroupMember.fromJson(result["data"]);
      print("User ${addedGroupMember.username} added to GroupKey: $groupKey");
    } else {
      // If that call was not successful, throw an error.
      print(result["Message"]);
      throw Exception(result["Message"]);
    }
  }

  /// Delete a Group Member
  /// * GroupKey: Unique Group Identifier
  /// * Username: Group Member's Username to be added
  Future deleteGroupMember(String groupKey, String username) async {
    Uri gmURLQuery = groupmemberURL.replace(query: "username=$username");
    print(gmURLQuery.toString());
    final response = await client.delete(
      gmURLQuery,
      headers: {"Authorization": groupKey},
    );
    if (response.statusCode == 200) {
      // If the call to the server was successful
      //print("Group Member $username deleted");
    } else if (response.statusCode == 400 ||
        response.statusCode == 401 ||
        response.statusCode == 404) {
      // If that call was not successful, throw an error.
      final Map result = json.decode(response.body);
      throw Exception(result["Message"]);
    }
  }

//Task CRUD Functions
  /// Get a list of the Group's Tasks
  /// * GroupKey: Unique group identifier
  Future<List<Task>> getTasks(String groupKey) async {
    //print("$groupKey");
    final response = await client.get(
      taskURL,
      headers: {"Authorization": groupKey},
    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<Task> tasks = [];
      for (Map<String, dynamic> json_ in result["data"]) {
        try {
          Task task = Task.fromJson(json_);
          //task.subtasks = await getSubtasks(task.taskKey);
          tasks.add(task);
        } catch (Exception) {
          print(Exception);
        }
      }
      //print("getTasks: " + tasks.toString() + " @" + DateTime.now().toString());
      return tasks;
    } else {
      // If that call was not successful, throw an error.
      throw Exception(result["Message"]);
    }
  }

  /// Add a Task to the Group.
  ///
  /// * Task Name: Name of the task
  /// * GroupKey: Unique Group Identifier
  /// * Index: Position within Group's task list
  /// * Completed: True or False, Has the task been completed
  Future addTask(String taskName, String groupKey) async {
    final response = await client.post(taskURL,
        headers: {"Authorization": apiKey},
        body: jsonEncode({"title": taskName, "group_key": groupKey}));
    if (response.statusCode == 201) {
      //print("Task " + taskName + " added @" + DateTime.now().toString());
    } else {
      // If that call was not successful, throw an error.
      final Map result = json.decode(response.body);
      print(result["Message"]);
      throw Exception(result["Message"]);
    }
  }

  /// Update Task Info
  Future updateTask(Task task) async {
    final response = await client.put(taskURL,
        headers: {"Authorization": task.taskKey},
        body: jsonEncode({"completed": task.completed}));
    if (response.statusCode == 200) {
      //print("Task ${task.title} Updated");
    } else {
      // If that call was not successful, throw an error.
      print(json.decode(response.body));
      throw Exception('Failed to update tasks');
    }
  }

  /// Delete Task from the Group's List of tasks
  /// * Task Key: Unique Task Identifier
  Future deleteTask(String taskKey) async {
    final response = await client.delete(
      taskURL,
      headers: {"Authorization": taskKey},
    );
    if (response.statusCode == 200) {
      // If the call to the server was successful
      //print("Task deleted @" + DateTime.now().toString());
    } else {
      // If that call was not successful, throw an error.
      final Map result = json.decode(response.body);
      throw Exception(result["Message"]);
    }
  }

//Subtask CRUD Functions
  //Get Subtasks
  Future<List<Subtask>> getSubtasks(Task task) async {
    final response = await client.get(
      subtaskURL,
      headers: {"Authorization": task.taskKey},
    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<Subtask> subtasks = [];
      for (Map<String, dynamic> json_ in result["data"]) {
        try {
          Subtask subtask = Subtask.fromJson(json_);
          subtasks.add(subtask);
          subtask.deadline = json_['due_date'] == null
              ? DateTime.now()
              : DateTime.parse(json_['due_date']);
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
  Future addSubtask(String taskKey, String subtaskName) async {
    final response = await client.post(subtaskURL,
        headers: {"Authorization": taskKey},
        body: jsonEncode({
          "title": subtaskName,
        }));
    if (response.statusCode == 201) {
      //print("Subtask " + subtaskName + " added @" + DateTime.now().toString());
    } else {
      print(response.statusCode);
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
          "note": subtask.note,
          "completed": subtask.completed,
          "due_date": subtask.deadline!.toIso8601String()
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
      //print("Subtask deleted @" + DateTime.now().toString());
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
      for (Map<String, dynamic> json_ in result["data"]) {
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
      throw Exception(result["Message"]);
    }
  }

  ///AssignedToUser API Calls
  ///GET
  Future<List<GroupMember>> getUsersAssignedToSubtask(String subtaskKey) async {
    final response = await client.get(
      assignedtouserhURL,
      headers: {"Authorization": subtaskKey},
    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<GroupMember> groupMembers = [];
      for (Map<String, dynamic> json_ in result["data"]) {
        try {
          groupMembers.add(GroupMember.fromJson(json_));
        } catch (Exception) {
          print(Exception);
          //throw Exception;
        }
      }
      //print("getGroupMembers: " +groupMembers.toString() +" @" +DateTime.now().toString());
      return groupMembers;
    } else {
      // If that call was not successful, throw an error.
      throw Exception(result["Message"]);
    }
  }

  /// Post: Assign a Group Member to Subtask
  /// * SubtaskKey: Unique Subtask Identifier
  /// * Username: Group Member's Username to be added
  Future assignSubtaskToUser(String subtaskKey, String username) async {
    Uri assignURLQuery =
        assignedtouserhURL.replace(query: "username=$username");
    final response = await client.post(
      assignURLQuery,
      headers: {"Authorization": subtaskKey},
    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 201) {
      print(
          "User ${GroupMember.fromJson(result["data"]).username} assigned to SubtaskKey: $subtaskKey");
    } else {
      // If that call was not successful, throw an error.
      print(result["Message"]);
      throw Exception(result["Message"]);
    }
  }

  /// Delete: Unssign a Group Member to Subtask
  /// * SubtaskKey: Unique Subtask Identifier
  /// * Username: Group Member's Username to be added
  Future unassignSubtaskToUser(String subtaskKey, String username) async {
    Uri assignURLQuery =
        assignedtouserhURL.replace(query: "username=$username");
    final response = await client.delete(
      assignURLQuery,
      headers: {"Authorization": subtaskKey},
    );
    if (response.statusCode == 200) {
      // If the call to the server was successful
      //print("Group Member $username deleted");
    } else if (response.statusCode == 400 ||
        response.statusCode == 401 ||
        response.statusCode == 404) {
      // If that call was not successful, throw an error.
      final Map result = json.decode(response.body);
      throw Exception(result["Message"]);
    }
  }

  /// Save API key to Device's persistant storage
  Future<void> saveApiKey(String apiKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('API_Token', apiKey);
    this.apiKey = apiKey;
  }

  /// Get API Key from persistant storage.
  Future<String> getApiKey() async {
    //if(apiKey.isNotEmpty) return apiKey;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('API_Token') ?? "";
  }
}
