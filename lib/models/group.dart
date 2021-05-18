import 'package:flutter/cupertino.dart';
import 'package:todolist/models/groupmember.dart';
import 'package:todolist/models/tasks.dart';

class Group extends ChangeNotifier{
  int id;
  String _name;
  String groupKey;
  bool isPublic;
  List<GroupMember> members = [];
  List<Task> tasks;

  Group.blank();

  Group(this.id, this._name, this.groupKey, this.isPublic);

  factory Group.fromJson(Map<String, dynamic> parsedJson) {
    return Group(
      parsedJson['id'],
      parsedJson['name'],
      //parsedJson['members'],
      parsedJson['group_key'],
      parsedJson['is_public'],
    );
  }

  String get name => _name;

  set name(String name) {
    _name = name;
    notifyListeners();
  }

  void addGroupMember(GroupMember member){
    members.add(member);
    notifyListeners();
  }

  void removeGroupMember(GroupMember member){
    members.remove(member);
    notifyListeners();
  }
}
