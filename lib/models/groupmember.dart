import 'package:flutter/material.dart';

class GroupMember{
  String firstname;
  String lastname;
  String username;
  String emailaddress;
  String phonenumber;
  ImageProvider avatar;

  GroupMember({this.firstname, this.lastname, this.emailaddress, this.username, this.phonenumber, this.avatar});

  factory GroupMember.fromJson(Map<String, dynamic> parsedJson){
    return GroupMember(
      firstname: parsedJson["firstname"],
      lastname: parsedJson["lastname"],
      username: parsedJson["username"],
      emailaddress: parsedJson["emailaddress"],
      phonenumber: parsedJson["phonenumber"],
      avatar: parsedJson["avatar"],
    );
  }
  
}