import 'package:todolist/models/group.dart';
import 'package:todolist/models/groupmember.dart';
import 'package:todolist/models/subtasks.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todolist/models/user.dart';
import 'package:todolist/models/tasks.dart';

class UserBloc {
  final PublishSubject<User> _userGetter = PublishSubject<User>();
  User _user = new User();

  UserBloc._privateConstructor();

  static final UserBloc _instance = UserBloc._privateConstructor();

  factory UserBloc() {
    return _instance;
  }

  Stream<User> get getUser => _userGetter.stream;

  User getUserObject() {
    return _user;
  }

  Future<void> registerUser(String username, String password, String email,
      String firstname, String lastname, String phonenumber, avatar) async {
    try {
      _user = await repository.registerUser(
          username, password, email, firstname, lastname, phonenumber, avatar);
    } catch (e) {
      throw e;
    }
    _userGetter.sink.add(_user);
  }

  Future<void> signinUser(
      String username, String password, String apiKey) async {
    try {
      _user = await repository.signinUser(username, password, apiKey);
    } catch (e) {
      throw e;
    }
    _userGetter.sink.add(_user);
  }

  Future<void> updateUserProfile(
      String currentPassword,
      String newPassword,
      String email,
      String username,
      String firstname,
      String lastname,
      String phonenumber,
      avatar) async {
    try {
      _user = await repository.updateUserProfile(currentPassword, newPassword,
          email, username, firstname, lastname, phonenumber, avatar);
    } catch (e) {
      throw e;
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

  List<Group> getGroupList() {
    return _groups;
  }

  Future<void> deleteGroup(String groupKey) async {
    await repository.deleteGroup(groupKey);
    await updateGroups();
  }

  Future<String> addGroup(String groupName, bool isPublic) async {
    String groupKey = await repository.addGroup(groupName, isPublic);
    await updateGroups();
    return groupKey;
  }

  Future<void> updateGroups() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    _groups = await repository.getUserGroups();
    _groupSubject.add(_groups);
  }
}

class GroupMemberBloc {
  final _groupMemberSubject = BehaviorSubject<List<GroupMember>>();
  String groupKey;
  var _groupMembers = <GroupMember>[];

  GroupMemberBloc(String groupKey) : this.groupKey = groupKey {
    _updateGroupMembers(groupKey);
  }

  Stream<List<GroupMember>> get getGroupMembers => _groupMemberSubject.stream;
  Future<void> _updateGroupMembers(String groupKey) async {
    _groupMembers = await repository.getGroupMembers(groupKey);
    _groupMemberSubject.add(_groupMembers);
  }
}

class TaskBloc {
  final _taskSubject = BehaviorSubject<List<Task>>();
  String _groupKey;

  TaskBloc(String groupKey) : this._groupKey = groupKey {
    updateTasks();
  }

  Stream<List<Task>> get getTasks => _taskSubject.stream;

  Future<void> addTask(String taskName) async {
    await repository.addTask(taskName, this._groupKey);
    await updateTasks();
  }

  Future<void> deleteTask(String taskKey) async {
    await repository.deleteTask(taskKey);
    await updateTasks();
  }

  Future<void> updateTasks() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    List<Task> tasks = await repository.getTasks(this._groupKey);
    _taskSubject.add(tasks);
  }
}

class SubtaskBloc {
  final _subtaskSubject = BehaviorSubject<List<Subtask>>();
  Task _task;

  SubtaskBloc(Task task) : this._task = task {
    _updateSubtasks();
  }

  Stream<List<Subtask>> get getSubtasks => _subtaskSubject.stream;

  Future<void> addSubtask(String subtaskName) async {
    await repository.addSubtask(_task.taskKey, subtaskName);
    await _updateSubtasks();
  }

  Future<void> deleteSubtask(String subtaskKey) async {
    await repository.deleteSubtask(subtaskKey);
    await _updateSubtasks();
  }

  Future<void> updateSubtaskInfo(Subtask subtask) async {
    Future.wait(
      [
        repository.updateSubtask(subtask),
        _updateSubtasks(),
      ],
    );
    //await repository.updateSubtask(subtask);
    //await _updateSubtasks();
  }

  Future<void> _updateSubtasks() async {
    List<Subtask> subtasks = await repository.getSubtasks(_task);
    _subtaskSubject.add(subtasks);
  }
}

final userBloc = UserBloc();
final groupBloc = GroupBloc();
//final taskBloc = TaskBloc();
