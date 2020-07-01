import 'package:flutter/material.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/subtasks.dart';
import 'package:todolist/widgets/subtask_container_widget.dart';

class TaskListTab extends StatefulWidget {
  final SubTaskBloc subTaskBloc;
  final Repository repository;
  final taskKey;

  TaskListTab(this.repository, this.taskKey, this.subTaskBloc);

  @override
  _TaskListTabState createState() => _TaskListTabState();
}

class _TaskListTabState extends State<TaskListTab> {
  List<SubTask> subtasks = [];

  @override
  Widget build(BuildContext context) {
    print("Building TaskList Context");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.blueGrey,
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.account_circle), onPressed: null)
        ],
      ),
      body: Container(
        child: SubtaskContainerWidget(taskKey: widget.taskKey, repository: widget.repository),
      ),
    );
  }
}
