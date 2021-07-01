import 'package:flutter/material.dart';
import 'package:todolist/UI/tabs/subtask_info/subtask_info_tab.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/group.dart';
import 'package:todolist/models/subtasks.dart';

class SubtaskListItemWidget extends StatefulWidget {
  final Subtask subtask;
  final SubtaskBloc subtaskBloc;
  final Group group;

  SubtaskListItemWidget({required this.subtask, required this.subtaskBloc, required this.group});
  @override
  _SubtaskListItemWidgetState createState() => _SubtaskListItemWidgetState();
}

class _SubtaskListItemWidgetState extends State<SubtaskListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: UniqueKey(),
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return SubtaskInfo(
          subtask: widget.subtask,
          subtaskBloc: widget.subtaskBloc,
          members: widget.group.members,
        );
      })),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: darkerGreenBlue,
          boxShadow: [
            new BoxShadow(
              color: Colors.white12,
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
                  onChanged: (bool? newValue) {
                    setState(() {
                      widget.subtask.completed = newValue!;
                      repository.updateSubtask(widget.subtask);
                    });
                  }),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text(
                  widget.subtask.title,
                  style: toDoListTileStyle,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  textDirection: TextDirection.ltr,
                  children: <Widget>[
                    widget.subtask.note.isNotEmpty
                        ? Text(
                            widget.subtask.note,
                            style: toDoListSubtitleStyle,
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                          )
                        : SizedBox.shrink(),
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
