import 'package:flutter/material.dart';

const Color loginBlue = Color(0xff56C7F1);
const Color lightBlue = Color(0xffceecf2);
const Color lightBlueGradient = Color(0xff00D4FF);
const Color lightGreenBlue = Color(0xff4AD2EE);
const Color darkGreenBlue = Color(0xff006F85);
const Color darkerGreenBlue = Color(0xff006175);
const Color darkBlue = Color(0xff023059);
const Color darkBlueGradient = Color(0xff0087FF);
const Color red = Color(0xfff20f38);
const Color darkRed = Color(0xffc70000);
const Color brownRed = Color(0xff590209);

final appTitleStyle = TextStyle(
  color: darkBlueGradient,
  fontWeight: FontWeight.bold,
  fontFamily: "Segoe UI",
  fontSize: 28.0,
);

final hintTextStyle = TextStyle(
  color: Colors.white70,
  fontFamily: 'Segoe UI',
);

final labelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'Segoe UI',
);

final boxDecorationStyle = BoxDecoration(
  color: Color(0xff57CBF2),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

final profileBoxDecorationStyle = BoxDecoration(
  color: Color(0xff57CBF2),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

TextStyle cardTitleStyle = new TextStyle(
    fontFamily: 'Segoe UI',
    fontWeight: FontWeight.bold,
    color: darkRed,
    fontSize: 50);

TextStyle toDoListTileStyle = new TextStyle(
    fontFamily: 'Segoe UI',
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontSize: 25);

TextStyle toDoListSubtitleStyle = new TextStyle(
    fontFamily: 'Segoe UI',
    fontWeight: FontWeight.w300,
    color: Colors.white,
    fontSize: 17);

TextStyle taskListTitleStyle = new TextStyle(
    fontFamily: 'Segoe UI',
    fontWeight: FontWeight.bold,
    color: darkBlue,
    fontSize: 50);

TextStyle loginTitleStyle = new TextStyle(
    fontFamily: 'Segoe UI',
    fontWeight: FontWeight.bold,
    color: darkBlueGradient,
    fontSize: 36);
TextStyle loginButtonStyle = new TextStyle(
    fontFamily: 'Segoe UI',
    fontWeight: FontWeight.w700,
    color: lightBlue,
    fontSize: 24);

TextStyle registerButtonStyle = new TextStyle(
    fontFamily: 'Segoe UI',
    fontWeight: FontWeight.bold,
    color: red,
    fontSize: 24);
