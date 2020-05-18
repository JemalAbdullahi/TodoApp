import 'package:flutter/material.dart';
import 'package:todolist/UI/tabs/tasklist_tab.dart';

import 'package:todolist/models/global.dart';

class TaskListItemWidget extends StatelessWidget {
  final String title;
  final String keyValue;
    final VoidCallback addTaskDialog;


  TaskListItemWidget({this.title, this.keyValue, this.addTaskDialog});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TaskListTab(addTaskDialog),
        ),
      ),
      child: Container(
        height: 90,
        //color: Theme.of(context).primaryColorDark,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: darkBlue, //Theme.of(context).primaryColorDark,
          boxShadow: [
            new BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 25.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Row(
            children: <Widget>[
              Text(title, style: toDoListTileStyle),
              SizedBox(width: 180.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'Group',
                    style: toDoListSubtitleStyle,
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
ListTile(
        leading: Checkbox(value: false, onChanged: null),
        title: Text(title, style: toDoListTileStyle),
        subtitle: Text(
          'Group',
          style: toDoListSubtitleStyle,
          textAlign: TextAlign.right,
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          new BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 25.0,
          ),
        ],
        color: darkBlue,
      ),

*/
