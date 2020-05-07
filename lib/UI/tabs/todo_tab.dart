import 'package:flutter/material.dart';


import 'package:todolist/UI/title_card.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/tasks.dart';
import 'package:todolist/widgets/task_list_item_widget.dart';

class ToDoTab extends StatefulWidget {
  @override
  _ToDoTabState createState() => _ToDoTabState();
}

class _ToDoTabState extends State<ToDoTab> {
  List<Task> tasks = [];
  @override
  void initState() {
    _getList();
    super.initState();
  }

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
        _buildReorderableList(context, tasks),
        TitleCard('To Do'),
      ],
    );
  }

  Widget _buildReorderableList(BuildContext context, List<Task> tasks) {
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
        child: ReorderableListView(
          padding: EdgeInsets.only(top: 300),
          children:
              tasks.map((Task item) => _buildListTile(context, item)).toList(),
          onReorder: (oldIndex, newIndex) {
            setState(
              () {
                Task item = tasks[oldIndex];
                tasks.remove(item);
                tasks.insert(newIndex, item);
              },
            );
          },
      ),
    );
  }

  Widget _buildListTile(BuildContext context, Task item) {
    return ListTile(
      key: Key(item.taskId.toString()),
      title: TaskListItemWidget(
        title: item.title,
      ),
    );
  }

  void _getList() {
    for (int i = 0; i < 3; i++) {
      tasks.add(Task('To Do: ' + i.toString(), false, i));
    }
  }
}
