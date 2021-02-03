import 'dart:async';

import 'package:flutter/material.dart';

import 'package:todolist/UI/title_card.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/tasks.dart';
import 'package:todolist/widgets/global_widgets/background_color_container.dart';
import 'package:todolist/widgets/task_widgets/task_list_item_widget.dart';

class ToDoTab extends StatefulWidget {
  final TaskBloc tasksBloc;
  final Repository repository;
  final VoidCallback addTaskDialog;
  final void Function(Task) reAddTask;

  ToDoTab(this.addTaskDialog, this.tasksBloc, this.repository, this.reAddTask);
  @override
  _ToDoTabState createState() => _ToDoTabState();
}

class _ToDoTabState extends State<ToDoTab> {
  List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        BackgroundColorContainer(startColor: lightBlue, endColor: lightBlueGradient,),
        StreamBuilder(
          key: UniqueKey(),
          // Wrap our widget with a StreamBuilder
          stream: widget.tasksBloc.getTasks, // pass our Stream getter here
          initialData: tasks, // provide an initial data
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                //print("None Data: " + snapshot.toString());
                return Container(
                  child: Center(
                    child: Text("No Connection Message"),
                  ),
                );
              case ConnectionState.active:
                //print("Active Data: " + snapshot.toString());
                if (snapshot.data.isEmpty) {
                  return Center(
                      child: Container(child: Text("No Data Available")));
                } else {
                  tasks = snapshot.data;
                  _setIndex();
                  return _buildReorderableList();
                }
                break;
              case ConnectionState.waiting:
                //print("Waiting Data: " + snapshot.toString());
                if (tasks.length == 0) {
                  return Container(
                    child: Center(
                      child: Text(""),
                    ),
                  );
                }
                break;
              case ConnectionState.done:
                //print("Done Data: " + snapshot.toString());
                if (snapshot.data.isEmpty) {
                  return Container(
                    child: Center(
                      child: Text("No Data Available"),
                    ),
                  );
                } else {
                  tasks = snapshot.data;
                  _setIndex();
                  return _buildReorderableList();
                }
            }
            return CircularProgressIndicator();
          },
        ),
        TitleCard('To Do', widget.addTaskDialog),
      ],
    );
  }

  Widget _buildReorderableList() {
    //print("Reorderable List" + tasks.toString());
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      key: UniqueKey(),
      child: ReorderableListView(
        key: UniqueKey(),
        padding: EdgeInsets.only(top: 300),
        children: tasks.map<Dismissible>((Task item) {
          return _buildListTile(item);
        }).toList(),
        onReorder: (oldIndex, newIndex) {
          setState(
            () {
              Task item = tasks[oldIndex];
              tasks.remove(item);
              tasks.insert(newIndex, item);
              item.index = newIndex;
              widget.repository.updateUserTask(item);
            },
          );
        },
      ),
    );
  }

  void _setIndex() {
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].index != i) {
        tasks[i].index = i;
        widget.repository.updateUserTask(tasks[i]);
      }
    }
  }

  Widget _buildListTile(Task item) {
    //print("Build List Tile: " + item.title);
    return Dismissible(
      key: Key(item.taskKey),
      child: ListTile(
        key: Key(item.title),
        title: TaskListItemWidget(
          task: item,
          repository: widget.repository,
        ),
      ),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: darkRed,
        child: Icon(
          Icons.delete,
          color: lightBlueGradient,
        ),
      ),
      onDismissed: (direction) {
        removeTask(item);
        deleteTask(item);
        Scaffold.of( context).showSnackBar(SnackBar(
          content: Text("Task " + item.title + " dismissed"),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              widget.reAddTask(item);
              tasks.insert(item.index, item);
              _setIndex();
            },
          ),
        ));
      },
      direction: DismissDirection.endToStart,
    );
  }

  void removeTask(Task task) {
    if (tasks.contains(task)) {
      setState(() {
        tasks.remove(task);
        _setIndex();
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


