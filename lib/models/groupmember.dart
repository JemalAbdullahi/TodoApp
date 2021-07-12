import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:todolist/models/global.dart';

// ignore: must_be_immutable
class GroupMember extends Equatable {
  /// Member's First name
  late String firstname;

  /// Member's Last name
  late String lastname;

  /// Member's Username
  late String username;

  /// Member's Email Address
  late String emailaddress;

  /// Member's Phone Number
  late String phonenumber;

  /// Avatar Image
  late var avatar;

  bool selectedForAssignment = false;

  GroupMember.blank();
  GroupMember(
      {required this.firstname,
      required this.lastname,
      required this.emailaddress,
      required this.username,
      required this.phonenumber,
      required this.avatar});

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

  /// Get Group Member's Initials
  String initials() => firstname[0].toUpperCase() + lastname[0].toUpperCase();

  /// Create CircleAvatar
  CircleAvatar cAvatar({
    double radius = 12,
    Color color = darkBlue,
  }) {
    return CircleAvatar(
      //backgroundImage: member.avatar,
      backgroundColor: color,
      child: selectedForAssignment
          ? Icon(Icons.check, size: radius + 8, color: Colors.white)
          : Text(
              this.initials(),
              style: TextStyle(
                fontFamily: "Segoe UI",
                fontWeight: FontWeight.bold,
                fontSize: radius + 2,
                color: Colors.white,
              ),
            ),
      radius: radius,
    );
  }

  @override
  String toString() {
    return "Member: $username Assigned: $selectedForAssignment";
  }
}
