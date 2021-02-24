import 'package:flutter/material.dart';

Color loginBlue = new Color(0xff56C7F1);
Color lightBlue = new Color(0xffceecf2);
Color lightBlueGradient = new Color(0xff00D4FF);
Color darkBlue = new Color(0xff023059);
Color darkBlueGradient = new Color(0xff0087FF);
Color red = new Color(0xfff20f38);
Color darkRed = new Color(0xffbf0426);
Color brownRed = new Color(0xff590209);

final appTitleStyle = TextStyle(
  color: darkBlueGradient,
  fontWeight: FontWeight.bold,
  fontFamily: "Segoe UI",
  fontSize: 28.0,
);

final hintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

final labelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
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
    fontWeight: FontWeight.w500,
    color: Colors.white,
    fontSize: 30);

TextStyle toDoListSubtitleStyle = new TextStyle(
    fontFamily: 'Segoe UI',
    fontWeight: FontWeight.w300,
    color: Colors.white,
    fontSize: 18);

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
