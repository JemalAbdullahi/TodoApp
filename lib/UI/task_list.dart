import 'package:flutter/material.dart';
import 'package:todolist/UI/title_card.dart';
import 'package:todolist/models/global.dart';


class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [darkBlueGradient, darkBlue],
                      ),
                    ),
                  ),
        TitleCard('Task List'),
      ],
    );
  }
}