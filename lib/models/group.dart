import 'package:todolist/models/groupmember.dart';
import 'package:todolist/models/tasks.dart';

class Group {
  int id;
  String name;
  String groupKey;
  bool isPublic;
  List<GroupMember> members;
  List<Task> tasks;
  
  

  Group(this.id, this.name, this.groupKey, this.isPublic);

  factory Group.fromJson(Map<String, dynamic> parsedJson) {
    return Group(
      parsedJson['id'],
      parsedJson['name'],
      //parsedJson['members'],
      parsedJson['group_key'],
      parsedJson['is_public'],
    );
  }
}
