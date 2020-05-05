import 'package:flutter/material.dart';
import 'package:todolist/UI/title_card.dart';

import 'package:todolist/models/global.dart';

class ToDoTab extends StatefulWidget {
  @override
  _ToDoTabState createState() => _ToDoTabState();
}

class _ToDoTabState extends State<ToDoTab> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [lightBlue, lightBlueGradient],
            ),
          ),
        ),
        TitleCard('To Do'),
      ],
    );
  }
}
