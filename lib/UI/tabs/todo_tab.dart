import 'package:flutter/material.dart';


import 'package:todolist/UI/title_card.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/tasks.dart';
import 'package:todolist/widgets/task_list_item_widget.dart';

class ToDoTab extends StatefulWidget {
  final VoidCallback addTaskDialog;
  final TaskBloc tasksBloc;
  final Repository repository;

  ToDoTab(this.addTaskDialog, this.tasksBloc, this.repository);
  @override
  _ToDoTabState createState() => _ToDoTabState();
}

class _ToDoTabState extends State<ToDoTab> {
  List<Task> tasks = [];

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
        StreamBuilder( // Wrap our widget with a StreamBuilder
          stream: widget.tasksBloc.getTasks, // pass our Stream getter here
          initialData: [], // provide an initial data
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot != null) {
                  if (snapshot.data.length > 0) {
                    return _buildReorderableList(context, snapshot.data);
                  }
                  else if (snapshot.data.length==0){
                    return Center(child: Text(''));
                  }
                } else if (snapshot.hasError) {
                  return Container();
                }
                return CircularProgressIndicator();
            }, // access the data in our Stream here
        ),
        //_buildReorderableList(context, tasks),
        TitleCard('To Do', widget.addTaskDialog),
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
        task: item,
        repository: widget.repository,
      ),
    );
  }
}
