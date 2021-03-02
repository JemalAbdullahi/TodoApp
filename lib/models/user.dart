import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
//import 'package:todolist/models/group.dart';

class User extends Equatable{
  final int id;
  final String firstname;
  final String lastname;
  final String phonenumber;
  final String emailAddress;
  final String username;
  final String password;
  final String apiKey;
  final ImageProvider avatar;
  //List<Group> groups;

  User({
    this.apiKey,
    this.id,
    this.username,
    this.password,
    this.emailAddress,
    this.firstname,
    this.lastname,
    this.phonenumber,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      apiKey: parsedJson['api_key'],
      id: parsedJson['id'],
      username: parsedJson['username'],
      password: parsedJson['password'],
      emailAddress: parsedJson['emailaddress'],
      firstname: parsedJson['firstname'],
      lastname: parsedJson['lastname'],
      phonenumber: parsedJson['phonenumber'],
      avatar: parsedJson['avatar'],
    );
  }
  @override
  List<Object> get props => [username];

}
