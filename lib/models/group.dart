import 'package:todolist/models/user.dart';

class Group {
  String name;
  int groupId;
  String groupKey;
  List<User> members;
  String group;
  

  Group(this.name, this.group, this.groupId, this.groupKey);

  factory Group.fromJson(Map<String, dynamic> parsedJson) {
    return Group(
      parsedJson['name'],
      parsedJson['id'],
      parsedJson['group_key'],
      parsedJson['members'],
    );
  }
}
