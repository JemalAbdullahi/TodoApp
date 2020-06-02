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
        StreamBuilder(
          // Wrap our widget with a StreamBuilder
          stream: widget.tasksBloc.getTasks, // pass our Stream getter here
          initialData: [], // provide an initial data
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot != null) {
              if (snapshot.data.length > 0) {
                return _buildReorderableList(snapshot.data);
              } else if (snapshot.data.length == 0) {
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

  Widget _buildReorderableList(List<Task> tasks) {
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      child: ReorderableListView(
        padding: EdgeInsets.only(top: 300),
        children:
            tasks.map((Task item) => _buildListTile(item)).toList(),
        onReorder: (oldIndex, newIndex) {
          setState(
            () {
              Task item = tasks[oldIndex];
              tasks.remove(item);
              item.index = newIndex;
              tasks.insert(newIndex, item);
            },
          );
        },
      ),
    );
  }

  Widget _buildListTile(Task item) {
    return Dismissible(
      key: Key(item.taskId.toString()),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: darkRed,
        child: Icon(
          Icons.delete,
          color: lightBlueGradient,
        ),
      ),
      onDismissed: (direction){
        setState(() {
          //int index = item.index;
          deleteTask(item);
          widget.tasksBloc.updateTasks();
          //tasks.removeAt(index);
        });
      },
      child: TaskListItemWidget(
        task: item,
        repository: widget.repository,
      ),
    );
  }

  void deleteTask(Task task) async {
    await widget.repository.deleteUserTask(task.taskKey);
    //tasks.removeAt(task.index);
    // setState(() {
    //   build(context);
    // });
  }
}
