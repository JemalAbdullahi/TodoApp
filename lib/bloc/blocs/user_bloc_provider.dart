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
      ImageProvider avatar,
      String apiKey) async {
    try {
      _user = await repository.updateUserProfile(currentPassword, newPassword,
          email, username, firstname, lastname, phonenumber, avatar, apiKey);
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
  String _apiKey;
  List<Group> _groups = <Group>[];
  
  void setApiKey() async {
    _apiKey = await repository.getApiKey();
    _updateGroups().then((_) {
      _groupSubject.add(_groups);
    });
  }

  GroupBloc._privateConstructor() {
    repository.getApiKey().then((apikey) {
      if (apikey.isNotEmpty) {
        this._apiKey = apikey;
        _updateGroups().then((_) {
          _groupSubject.add(_groups);
        });
      }
    });
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

  Stream<List<Group>> get getGroups => _groupSubject.stream;
  Future<Null> _updateGroups() async {
    _groups = await repository.getUserGroups(_apiKey);
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
  String _apiKey;

  var _tasks = <Task>[];

  TaskBloc(String apiKey) {
    this._apiKey = apiKey;
    _updateTasks().then((_) {
      _taskSubject.add(_tasks);
    });
  }

  Stream<List<Task>> get getTasks => _taskSubject.stream;
  Future<Null> _updateTasks() async {
    _tasks = await repository.getUserTasks(_apiKey);
  }
}

class SubTaskBloc {
  final _subTaskSubject = BehaviorSubject<List<SubTask>>();
  String taskKey;

  var _subTasks = <SubTask>[];

  SubTaskBloc(String taskKey) {
    this.taskKey = taskKey;
    _updateSubTasks(taskKey).then((_) {
      _subTaskSubject.add(_subTasks);
    });
  }

  Stream<List<SubTask>> get getSubTasks => _subTaskSubject.stream;
  Future<Null> _updateSubTasks(String taskKey) async {
    _subTasks = await repository.getSubTasks(taskKey);
  }
}

final userBloc = UserBloc();
final groupBloc = GroupBloc();
//final taskBloc = TaskBloc();
