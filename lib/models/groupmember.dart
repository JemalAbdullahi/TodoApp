import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GroupMember extends Equatable {
  final String firstname;
  final String lastname;
  final String username;
  final String emailaddress;
  final String phonenumber;
  final ImageProvider avatar;

  GroupMember(
      {this.firstname,
      this.lastname,
      this.emailaddress,
      this.username,
      this.phonenumber,
      this.avatar});

  factory GroupMember.fromJson(Map<String, dynamic> parsedJson) {
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

  // Get Group Member's Initials
  String initials() => firstname[0].toUpperCase() + lastname[0].toUpperCase();

  //Create CircleAvatar
  CircleAvatar cAvatar({double radius=12}){
    return CircleAvatar(
            //backgroundImage: member.avatar,
            //backgroundColor: Colors.grey,
            child: Text(
              this.initials(),
              style: TextStyle(
                fontFamily: "Segoe UI",
                fontWeight: FontWeight.bold,
                fontSize: radius+2,
                color: Colors.white,
              ),
            ),
            radius: radius,
          );
  }
}
