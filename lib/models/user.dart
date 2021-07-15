import 'package:todolist/models/groupmember.dart';
//import 'package:todolist/models/group.dart';

// ignore: must_be_immutable
class User extends GroupMember {
  late int id;
  late String password;
  late String apiKey;

  //List<Group> groups;

  User.blank(): super.blank();

  User(this.id, this.password, this.apiKey,
      {username, firstname, lastname, emailaddress, phonenumber, avatar})
      : super(
            firstname: firstname,
            lastname: lastname,
            username: username,
            emailaddress: emailaddress,
            phonenumber: phonenumber,
            avatar: avatar);

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      parsedJson['id'],
      parsedJson['password'],
      parsedJson['api_key'],
      username: parsedJson['username'],
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
