import 'package:flutter/material.dart';
import 'package:todolist/UI/title_card.dart';

import 'package:todolist/models/global.dart';

class ToDoTab extends StatefulWidget {
  @override
  _ToDoTabState createState() => _ToDoTabState();
}

class _ToDoTabState extends State<ToDoTab> {
  List<String> tasks = [
    'Shopping List',
    'Shopping List',
    'Shopping List',
    'Shopping List',
    'Shopping List',
    'Shopping List',
    'Shopping List',
    'Shopping List'
  ];
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
        _getList(),
        TitleCard('To Do'),
      ],
    );
  }

  Widget _getList() {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 160, left: 25, right: 25),
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 80,
          child: ListTile(
            title: Text(tasks[index], style: toDoListTileStyle),
            subtitle: Text(
              'Family',
              style: toDoListSubtitleStyle,
              textAlign: TextAlign.right,
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: darkBlue,
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }
}
