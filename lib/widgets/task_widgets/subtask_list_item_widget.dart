import 'package:flutter/material.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/subtasks.dart';

class SubtaskListItemWidget extends StatefulWidget {
  final Subtask subtask;

  SubtaskListItemWidget({this.subtask});
  @override
  _SubtaskListItemWidgetState createState() => _SubtaskListItemWidgetState();
}

class _SubtaskListItemWidgetState extends State<SubtaskListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: darkGreenBlue,
        boxShadow: [
          new BoxShadow(
            color: Colors.black.withOpacity(1),
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
                value: widget.subtask.completed,
                onChanged: (bool newValue) {
                  setState(() {
                    widget.subtask.completed = newValue;
                    repository.updateSubtask(widget.subtask);
                  });
                }),
            Text(widget.subtask.title, style: toDoListTileStyle),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                widget.subtask.note.isNotEmpty
                    ? Text(
                        widget.subtask.note,
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
