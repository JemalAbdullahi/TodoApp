import 'package:flutter/material.dart';

import 'package:todolist/UI/tabs/subtask_list_tab.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/tasks.dart';

class TaskListItemWidget extends StatefulWidget {
  final Task task;
  final String keyValue;
  final Repository repository;

  TaskListItemWidget({this.task, this.repository, this.keyValue});

  @override
  _TaskListItemWidgetState createState() => _TaskListItemWidgetState();
}

class _TaskListItemWidgetState extends State<TaskListItemWidget> {
  SubTaskBloc subTaskBloc;

  @override
  void initState() {
    subTaskBloc = SubTaskBloc(widget.task.taskKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: UniqueKey(),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SubtaskListTab(
                widget.repository, widget.task.taskKey, subTaskBloc);
          });
        }),
      ),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: darkBlue,
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
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Checkbox(
                  value: widget.task.completed,
                  onChanged: (bool newValue) {
                    setState(() {
                      widget.task.completed = newValue;
                      widget.repository.updateUserTask(widget.task);
                    });
                  }),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text(
                  widget.task.title,
                  style: toDoListTileStyle,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  textDirection: TextDirection.ltr,
                  children: <Widget>[
                    widget.task.groupName.isNotEmpty
                        ? Text(
                            widget.task.groupName,
                            style: toDoListSubtitleStyle,
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                          )
                        : Text(
                            'group',
                            style: toDoListSubtitleStyle,
                            textAlign: TextAlign.right,
                          ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
