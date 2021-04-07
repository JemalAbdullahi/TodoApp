//import 'package:todolist/models/tasks.dart';

import 'package:flutter/cupertino.dart';
import 'package:todolist/models/group.dart';
import 'package:todolist/models/groupmember.dart';
import 'package:todolist/models/subtasks.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todolist/models/user.dart';
import 'package:todolist/models/tasks.dart';

class UserBloc {
  final _userGetter = PublishSubject<User>();
  User _user;

  UserBloc._privateConstructor();

  static final UserBloc _instance = UserBloc._privateConstructor();

  factory UserBloc() {
    return _instance;
  }

  Observable<User> get getUser => _userGetter.stream;

  User getUserObject() {
    return _user;
  }

  registerUser(String username, String password, String email, String firstname,
      String lastname, String phonenumber, ImageProvider avatar) async {
    _user = await repository.registerUser(
        username, password, email, firstname, lastname, phonenumber, avatar);
    _userGetter.sink.add(_user);
  }

  signinUser(String username, String password, String apiKey) async {
    try {
      _user = await repository.signinUser(username, password, apiKey);
    } catch (e) {
      throw Exception(e.message);
    }
    _userGetter.sink.add(_user);
  }

  updateUserProfile(
      String currentPassword,
      String newPassword,
      String email,
      String username,
      String firstname,
      String lastname,
      String phonenumber,
      ImageProvider avatar) async {
    try {
      _user = await repository.updateUserProfile(currentPassword, newPassword,
          email, username, firstname, lastname, phonenumber, avatar);
    } catch (e) {
      throw Exception(e.message);
    }
  }

  dispose() {
    _userGetter.close();
  }
}

class GroupBloc {
  final _groupSubject = BehaviorSubject<List<Group>>();
  List<Group> _groups = [];

  GroupBloc._privateConstructor() {
    updateGroups();
  }

  static final GroupBloc _instance = GroupBloc._privateConstructor();

  factory GroupBloc() {
    return _instance;
  }
  /* Testing GroupBloc 
  Future<List<Group>> testGroupList() async{
    return await repository.getUserGroups(_apiKey);
  } 
  */

  Stream<List<Group>> get getGroups {
    updateGroups();
    return _groupSubject.stream;
  }

  Future<Null> updateGroups() async {
    _groups = await repository.getUserGroups();
    _groupSubject.add(_groups);
  }
}

class GroupMemberBloc {
  final _groupMemberSubject = BehaviorSubject<List<GroupMember>>();
  String groupKey;
  var _groupMembers = <GroupMember>[];

  GroupMemberBloc(String groupKey) {
    this.groupKey = groupKey;
    _updateGroupMembers(groupKey).then((_) {
      _groupMemberSubject.add(_groupMembers);
    });
  }

  Stream<List<GroupMember>> get getGroupMembers => _groupMemberSubject.stream;
  Future<Null> _updateGroupMembers(String groupKey) async {
    _groupMembers = await repository.getGroupMembers(groupKey);
  }
}

class TaskBloc {
  final _taskSubject = BehaviorSubject<List<Task>>();
  String _groupKey;

  TaskBloc(String groupKey) {
    this._groupKey = groupKey;
    _updateTasks().then((tasks) {
      _taskSubject.add(tasks);
    });
  }

  Stream<List<Task>> get getTasks => _taskSubject.stream;

  Future<Null> addTask(String taskName, int index, bool completed) async {
    await repository.addTask(taskName, this._groupKey, index, completed);
    _updateTasks().then((tasks) => _taskSubject.add(tasks));
  }

  Future<Null> deleteTask(String taskKey) async {
    await repository.deleteTask(taskKey);
    await _updateTasks().then((tasks) => _taskSubject.add(tasks));
  }

  Future<List<Task>> _updateTasks() async {
    return await repository.getTasks(_groupKey);
  }
}

class SubtaskBloc {
  final _subtaskSubject = BehaviorSubject<List<Subtask>>();
  String _taskKey;

  SubtaskBloc(String taskKey) {
    this._taskKey = taskKey;
    _updateSubtasks().then((subtasks) {
      _subtaskSubject.add(subtasks);
    });
  }

  Stream<List<Subtask>> get getSubtasks => _subtaskSubject.stream;

  Future<Null> addSubtask(String subtaskName, int index, bool completed) async {
    await repository.addSubtask(_taskKey, subtaskName, index, completed);
    await _updateSubtasks().then((subtasks) => _subtaskSubject.add(subtasks));
  }

  Future<Null> deleteSubtask(String subtaskKey) async {
    await repository.deleteSubtask(subtaskKey);
    await _updateSubtasks().then((subtasks) => _subtaskSubject.add(subtasks));
  }

  Future<List<Subtask>> _updateSubtasks() async {
    return await repository.getSubtasks(_taskKey);
  }
}

final userBloc = UserBloc();
final groupBloc = GroupBloc();
//final taskBloc = TaskBloc();
