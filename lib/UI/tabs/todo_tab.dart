import 'dart:async';

import 'package:flutter/material.dart';

import 'package:todolist/UI/title_card.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/tasks.dart';
import 'package:todolist/widgets/task_list_item_widget.dart';

class ToDoTab extends StatefulWidget {
  final VoidCallback addTaskDialog;
  final VoidCallback delTask;
  final TaskBloc tasksBloc;
  final Repository repository;

  ToDoTab(this.addTaskDialog, this.tasksBloc, this.repository, this.delTask);
  @override
  _ToDoTabState createState() => _ToDoTabState();
}

class _ToDoTabState extends State<ToDoTab> {
  List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
    print("TAB BUILD CONTEXT");
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
        TitleCard('To Do', widget.addTaskDialog),
      ],
    );
  }

  Widget _buildReorderableList(List<Task> tasks) {
    print("Reorderable List");
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      child: ListView(
        padding: EdgeInsets.only(top: 300),
        children: tasks.map((Task item) => _buildListTile(item)).toList(),
        /* onReorder: (oldIndex, newIndex) {
          setState(
            () {
              Task item = tasks[oldIndex];
              tasks.remove(item);
              item.index = newIndex;
              tasks.insert(newIndex, item);
            },
          );
        }, */
      ),
    );
  }

  Widget _buildListTile(Task item) {
    print("Build List Tile");
    return Dismissible(
      key: Key(item.title),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: darkRed,
        child: Icon(
          Icons.delete,
          color: lightBlueGradient,
        ),
      ),
      onResize: () {
        bool undo = false;
        removeTask(item);
        // Show a snackbar. This snackbar could also contain "Undo" actions.
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Task " + item.title + " dismissed"),
          duration: Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              // Some code to undo the change.
              undo = true;
              tasks.insert(item.index, item);
              widget.delTask();
            },
          ),
        ));
        Timer(Duration(seconds: 3), () {
          if (!undo) {
            deleteTask(item);
          }else{
            widget.delTask();
          }
        });
      },
      resizeDuration: Duration(seconds: 5),
      direction: DismissDirection.endToStart,
      child: ListTile(
        title: TaskListItemWidget(
          task: item,
          repository: widget.repository,
        ),
      ),
    );
  }

  void removeTask(Task task) {
    if (tasks.contains(task)) {
      setState(() {
        tasks.remove(task);
      });
    }
  }

  void addTask(Task task) {
    tasks.insert(task.index, task);
  }

  Future<Null> deleteTask(Task task) async {
    removeTask(task);
    await widget.repository.deleteUserTask(task.taskKey);
  }
}
