import 'package:todolist/models/groupmember.dart';
//import 'package:todolist/models/group.dart';

class User extends GroupMember {
  final int? id;
  final String? password;
  final String? apiKey;
  
  //List<Group> groups;

  User(
      {this.id,
      this.password,
      this.apiKey,
      username,
      firstname,
      lastname,
      emailaddress,
      phonenumber,
      avatar})
      : super(
            firstname: firstname,
            lastname: lastname,
            username: username,
            emailaddress: emailaddress,
            phonenumber: phonenumber,
            avatar: avatar);

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      apiKey: parsedJson['api_key'],
      id: parsedJson['id'],
      username: parsedJson['username'],
      password: parsedJson['password'],
      emailaddress: parsedJson['emailaddress'],
      firstname: parsedJson['firstname'],
      lastname: parsedJson['lastname'],
      phonenumber: parsedJson['phonenumber'],
      avatar: parsedJson['avatar'],
    );
  }
  @override
  List<Object> get props => [username];

  @override
  String toString() {
    return username;
  }
}
