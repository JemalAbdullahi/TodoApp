import 'package:flutter/material.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/models/subtasks.dart';
import 'package:todolist/widgets/task_widgets/subtask_container_widget.dart';

class SubtaskListTab extends StatefulWidget {
  final SubTaskBloc subTaskBloc;
  final taskKey;

  SubtaskListTab(this.taskKey, this.subTaskBloc);

  @override
  _SubtaskListTabState createState() => _SubtaskListTabState();
}

class _SubtaskListTabState extends State<SubtaskListTab> {
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
        child: SubtaskContainerWidget(
            taskKey: widget.taskKey),
      ),
    );
  }
}
