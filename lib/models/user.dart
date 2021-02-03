import 'package:flutter/cupertino.dart';

class User {
  final int id;
  final String firstname;
  final String lastname;
  final String phonenumber;
  final String emailAddress;
  final String username;
  final String password;
  final String apiKey;
  final ImageProvider avatar;
  //List<String> groups;

  User(
      {this.firstname,
      this.lastname,
      this.phonenumber,
      this.emailAddress,
      this.id,
      this.apiKey,
      this.password,
      this.username,
      this.avatar});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
        firstname: parsedJson['firstname'],
        lastname: parsedJson['lastname'],
        phonenumber: parsedJson['phonenumber'],
        avatar: parsedJson['avatar'],
        username: parsedJson['username'],
        emailAddress: parsedJson['emailaddress'],
        password: parsedJson['password'],
        id: parsedJson['id'],
        apiKey: parsedJson['api_key']);
  }
}
