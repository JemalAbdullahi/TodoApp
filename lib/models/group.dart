import 'package:flutter/cupertino.dart';
import 'package:todolist/models/groupmember.dart';
import 'package:todolist/models/tasks.dart';

class Group extends ChangeNotifier {
  late int id;
  late String _name;
  late String groupKey;
  late bool isPublic;
  late List<GroupMember> members = [];
  late List<Task> tasks;

  /// Time Created
  late DateTime timeCreated;

  /// Time Updated
  late DateTime timeUpdated;

  Group.blank();

  Group(this.id, this._name, this.groupKey, this.isPublic, this.timeCreated,
      this.timeUpdated);

  factory Group.fromJson(Map<String, dynamic> parsedJson) {
    return Group(
        parsedJson['id'],
        parsedJson['name'],
        //parsedJson['members'],
        parsedJson['group_key'],
        parsedJson['is_public'],
        DateTime.parse(parsedJson['time_created']),
        DateTime.parse(parsedJson['time_updated']));
  }

  String get name => _name;

  set name(String name) {
    _name = name;
    notifyListeners();
  }

  void addGroupMember(GroupMember member) {
    members.add(member);
    notifyListeners();
  }

  void removeGroupMember(GroupMember member) {
    members.remove(member);
    notifyListeners();
  }

  @override
  String toString() {
    return "Name: $_name Public: $isPublic Members: ${members.length}.";
  }
}
