import 'package:flutter/material.dart';

import 'package:todolist/UI/tabs/tasklist_tab.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/tasks.dart';

class TaskListItemWidget extends StatefulWidget {
  final Task task;
  final String keyValue;
  final VoidCallback addTaskDialog;

  TaskListItemWidget({this.task, this.keyValue, this.addTaskDialog});

  @override
  _TaskListItemWidgetState createState() => _TaskListItemWidgetState();
}

class _TaskListItemWidgetState extends State<TaskListItemWidget> {
  @override
  Widget build(BuildContext context) {
    //print(widget.task.group);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TaskListTab(widget.addTaskDialog),
        ),
      ),
      child: Container(
        height: 90,
        //width: 20,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Checkbox(
                  value: widget.task.completed,
                  onChanged: (bool newValue) {
                    setState(() {
                      widget.task.completed = newValue;
                    });
                  }),
              Text(widget.task.title, style: toDoListTileStyle),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  widget.task.group != null
                      ? Text(
                          widget.task.group,
                          style: toDoListSubtitleStyle,
                          textAlign: TextAlign.right,
                        )
                      : Text(
                          'group',
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
