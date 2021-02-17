import 'package:flutter/material.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/subtasks.dart';
import 'package:todolist/widgets/task_widgets/subtask_container_widget.dart';
import 'package:todolist/widgets/task_widgets/subtask_list_item_widget.dart';

class SubtaskListTile extends StatefulWidget {
  const SubtaskListTile({
    @required this.key,
    @required this.widget,
    @required this.context,
    @required this.subtasks,
    @required this.item,
    @required this.setIndex,
    @required this.updateIndex,
    @required this.reAddSubTask,
    @required this.deleteSubTask,
  });

  final Key key;
  final SubtaskContainerWidget widget;
  final BuildContext context;
  final List<SubTask> subtasks;
  final SubTask item;
  final VoidCallback setIndex;
  final VoidCallback updateIndex;
  final void Function(SubTask) reAddSubTask;
  final Future<Null> Function(SubTask) deleteSubTask;

  @override
  _SubtaskListTileState createState() => _SubtaskListTileState();
}

class _SubtaskListTileState extends State<SubtaskListTile> {
  @override
  Widget build(BuildContext context) {
    //print("Build List Tile: " + item.title);
    return Dismissible(
      key: widget.key,
      child: ListTile(
        key: Key(widget.item.title),
        title: SubTaskListItemWidget(
            subTask: widget.item),
      ),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: darkRed,
        child: Icon(
          Icons.delete,
          color: darkBlueGradient,
        ),
      ),
      onDismissed: (direction) {
        //removeSubTask(item);
        widget.deleteSubTask(widget.item);
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Task " + widget.item.title + " dismissed"),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              widget.reAddSubTask(widget.item);
              widget.subtasks.insert(widget.item.index, widget.item);
              widget.setIndex();
            },
          ),
        ));
        //widget.updateIndex();
      },
      direction: DismissDirection.endToStart,
    );
  }
}
