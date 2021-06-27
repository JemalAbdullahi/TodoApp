import 'package:flutter/material.dart';

import 'package:todolist/UI/tabs/subtask_list_tab.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/tasks.dart';

class TaskListItemWidget extends StatefulWidget {
  final Task task;

  TaskListItemWidget({required this.task});

  @override
  _TaskListItemWidgetState createState() => _TaskListItemWidgetState();
}

class _TaskListItemWidgetState extends State<TaskListItemWidget> {
  late SubtaskBloc subtaskBloc;

  @override
  void initState() {
    subtaskBloc = SubtaskBloc(widget.task.taskKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: UniqueKey(),
      onTap: () => Navigator.pushNamed(context, SubtaskListTab.routeName,
          arguments: SubtaskListTabArguments(widget.task)),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: darkGreenBlue,
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
                  onChanged: (bool? newValue) {
                    setState(() {
                      widget.task.completed = newValue!;
                      repository.updateTask(widget.task);
                    });
                  }),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text(
                  widget.task.title,
                  style: toDoListTileStyle,
                  maxLines: 3,
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
