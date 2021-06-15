import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GroupMember extends Equatable {
  /// Member's First name
  final String firstname;

  /// Member's Last name
  final String lastname;

  /// Member's Username
  final String username;

  /// Member's Email Address
  final String emailaddress;

  /// Member's Phone Number
  final String phonenumber;

  /// Avatar Image
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

  /// Get Group Member's Initials
  String initials() => firstname[0].toUpperCase() + lastname[0].toUpperCase();

  /// Create CircleAvatar
  CircleAvatar cAvatar({double radius = 12}) {
    return CircleAvatar(
      //backgroundImage: member.avatar,
      //backgroundColor: Colors.grey,
      child: Text(
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
    return "Member: $username";
  }
}
