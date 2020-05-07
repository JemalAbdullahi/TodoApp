import 'package:flutter/material.dart';
import 'package:todolist/models/global.dart';

class CreateTaskOverlay extends StatefulWidget {
  @override
  _CreateTaskOverlayState createState() => _CreateTaskOverlayState();
}

class _CreateTaskOverlayState extends State<CreateTaskOverlay> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: red,
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        child: AppBar(),
      ),
    );
  }
}
