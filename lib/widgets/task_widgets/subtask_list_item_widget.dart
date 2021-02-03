import 'package:flutter/material.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/subtasks.dart';

class SubTaskListItemWidget extends StatefulWidget {
  final SubTask subTask;
  final Repository repository;

  SubTaskListItemWidget({this.subTask, this.repository});
  @override
  _SubTaskListItemWidgetState createState() => _SubTaskListItemWidgetState();
}

class _SubTaskListItemWidgetState extends State<SubTaskListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.blue,
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
                value: widget.subTask.completed,
                onChanged: (bool newValue) {
                  setState(() {
                    widget.subTask.completed = newValue;
                    widget.repository.updateSubTask(widget.subTask);
                  });
                }),
            Text(widget.subTask.title, style: toDoListTileStyle),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                widget.subTask.note.isNotEmpty
                    ? Text(
                        widget.subTask.note,
                        style: toDoListSubtitleStyle,
                        textAlign: TextAlign.right,
                      )
                    : Text(
                        '',
                        style: toDoListSubtitleStyle,
                        textAlign: TextAlign.right,
                      ),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
