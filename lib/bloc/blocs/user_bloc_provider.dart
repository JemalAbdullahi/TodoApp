//import 'package:todolist/models/tasks.dart';

import 'package:flutter/cupertino.dart';
import 'package:todolist/models/subtasks.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todolist/models/user.dart';
import 'package:todolist/models/tasks.dart';

class UserBloc {
  final _repository = Repository();
  final _userGetter = PublishSubject<User>();
  User _user;

  Observable<User> get getUser => _userGetter.stream;

  User getUserObject() {
    return _user;
  }

  registerUser(String username, String password, String email, String firstname,
      String lastname, String phonenumber, ImageProvider avatar) async {
    _user = await _repository.registerUser(
        username, password, email, firstname, lastname, phonenumber, avatar);
    _userGetter.sink.add(_user);
  }

  signinUser(String username, String password, String apiKey) async {
    _user = await _repository.signinUser(username, password, apiKey);
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
      _user = await _repository.updateUserProfile(currentPassword, newPassword,
          email, username, firstname, lastname, phonenumber, avatar, apiKey);
    } catch (e) {
      throw Exception(e.message);
    }
  }

  dispose() {
    _userGetter.close();
  }
}

class TaskBloc {
  final _repository = Repository();
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
    _tasks = await _repository.getUserTasks(_apiKey);
  }
}

class SubTaskBloc {
  final _repository = Repository();
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
    _subTasks = await _repository.getSubTasks(taskKey);
  }
}

final userBloc = UserBloc();
