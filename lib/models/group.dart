import 'package:todolist/models/groupmember.dart';

class Group {
  int id;
  String name;
  String groupKey;
  bool isPublic;
  List<GroupMember> members;
  
  

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
