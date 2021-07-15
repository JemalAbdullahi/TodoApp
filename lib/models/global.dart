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

TextStyle appTitleStyle(double unitHeightValue) => TextStyle(
      color: darkBlueGradient,
      fontWeight: FontWeight.bold,
      fontFamily: "Segoe UI",
      fontSize: 28.0 * unitHeightValue,
    );

TextStyle hintTextStyle(double unitHeightValue) => TextStyle(
      color: Colors.white70,
      fontFamily: 'Segoe UI',
    );

TextStyle labelStyle(double unitHeightValue) => TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: 'Segoe UI',
      fontSize: 18 * unitHeightValue,
    );

BoxDecoration boxDecorationStyle() => BoxDecoration(
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

BoxDecoration profileBoxDecorationStyle() => BoxDecoration(
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

TextStyle cardTitleStyle(double unitHeightValue) => new TextStyle(
      fontFamily: 'Segoe UI',
      fontWeight: FontWeight.bold,
      color: darkRed,
      fontSize: 50 * unitHeightValue,
    );

TextStyle toDoListTileStyle(double unitHeightValue) => new TextStyle(
      fontFamily: 'Segoe UI',
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontSize: 25 * unitHeightValue,
    );

TextStyle toDoListSubtitleStyle(double unitHeightValue) => new TextStyle(
      fontFamily: 'Segoe UI',
      fontWeight: FontWeight.w300,
      color: Colors.white,
      fontSize: 17 * unitHeightValue,
    );

TextStyle taskListTitleStyle(double unitHeightValue) => new TextStyle(
      fontFamily: 'Segoe UI',
      fontWeight: FontWeight.bold,
      color: darkBlue,
      fontSize: 50 * unitHeightValue,
    );

TextStyle loginTitleStyle(double unitHeightValue) => new TextStyle(
      fontFamily: 'Segoe UI',
      fontWeight: FontWeight.bold,
      color: darkBlueGradient,
      fontSize: 36 * unitHeightValue,
    );
TextStyle loginButtonStyle(double unitHeightValue) => new TextStyle(
      fontFamily: 'Segoe UI',
      fontWeight: FontWeight.w700,
      color: lightBlue,
      fontSize: 24 * unitHeightValue,
    );

TextStyle registerButtonStyle(double unitHeightValue) => new TextStyle(
      fontFamily: 'Segoe UI',
      fontWeight: FontWeight.bold,
      color: red,
      fontSize: 24 * unitHeightValue,
    );
