//import 'package:todolist/models/user.dart';

class Group {
  int id;
  String name;
  String groupKey;
  bool isPublic;
  //List<User> members;
  
  

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
