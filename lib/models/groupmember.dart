import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GroupMember extends Equatable{
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
  

  @override
  List<Object> get props => [username];
}