import 'package:flutter/material.dart';

import 'package:todolist/UI/tabs/subtask_list_tab.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/group.dart';
import 'package:todolist/models/tasks.dart';

class TaskListItemWidget extends StatefulWidget {
  final Task task;
  final Group group;

  TaskListItemWidget({required this.group, required this.task});

  @override
  _TaskListItemWidgetState createState() => _TaskListItemWidgetState();
}

class _TaskListItemWidgetState extends State<TaskListItemWidget> {
  late SubtaskBloc subtaskBloc;
  late double unitHeightValue;
  late double height;

  @override
  void initState() {
    subtaskBloc = SubtaskBloc(widget.task);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    unitHeightValue = mediaQuery.height * 0.001;
    height = mediaQuery.height * 0.1;

    return GestureDetector(
      key: UniqueKey(),
      onTap: () => Navigator.pushNamed(context, SubtaskListTab.routeName,
          arguments: SubtaskListTabArguments(widget.group, widget.task)),
      child: Container(
        height: height,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Row(
                children: <Widget>[
                  Checkbox(
                      value: widget.task.completed,
                      onChanged: (bool? newValue) {
                        setState(() {
                          widget.task.completed = newValue!;
                          repository.updateTask(widget.task);
                        });
                      }),
                  Text(
                    widget.task.title,
                    style: toDoListTileStyle(unitHeightValue),
                    maxLines: 3,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              textDirection: TextDirection.ltr,
              children: <Widget>[
                widget.task.groupName.isNotEmpty
                    ? Text(
                        widget.task.groupName,
                        style: toDoListSubtitleStyle(unitHeightValue),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                      )
                    : Text(
                        'group',
                        style: toDoListSubtitleStyle(unitHeightValue),
                        textAlign: TextAlign.right,
                      ),
                SizedBox(height: 20 * unitHeightValue),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
