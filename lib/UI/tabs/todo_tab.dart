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
  final VoidCallback rebuildMainContext;
  final void Function(Task) reAddTask;
  final TaskBloc tasksBloc;
  final Repository repository;

  ToDoTab(this.addTaskDialog, this.tasksBloc, this.repository,
      this.rebuildMainContext, this.reAddTask);
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
          key: UniqueKey(),
          // Wrap our widget with a StreamBuilder
          stream: widget.tasksBloc.getTasks, // pass our Stream getter here
          initialData: tasks, // provide an initial data
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                print("None Data: " + snapshot.toString());

                return Container(
                  child: Center(
                    child: Text("No Connection Message"),
                  ),
                );
              case ConnectionState.active:
                print("Active Data: " + snapshot.toString());
                if (snapshot.data.isEmpty) {
                  return Center(
                      child: Container(child: Text("No Data Available")));
                } else {
                  tasks = snapshot.data;
                  setIndex();
                  return _buildListView();
                  //return _buildReorderableList();
                }
                break;
              case ConnectionState.waiting:
                print("Waiting Data: " + snapshot.toString());
                if (tasks.length == 0) {
                  return Container(
                    child: Center(
                      child: Text("Loading Message"),
                    ),
                  );
                }
                break;
              case ConnectionState.done:
                print("Done Data: " + snapshot.toString());
                if (snapshot.data.isEmpty) {
                  return Container(
                    child: Center(
                      child: Text("No Data Available"),
                    ),
                  );
                } else {
                  tasks = snapshot.data;
                  setIndex();
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

  Widget _buildListView() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _buildListTile(tasks[index]);
      },
      itemCount: tasks.length,
      padding: EdgeInsets.only(top: 200),
    );
  }

  Widget _buildReorderableList() {
    print("Reorderable List" + tasks.toString());
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      key: UniqueKey(),
      child: ReorderableListView(
        key: UniqueKey(),
        padding: EdgeInsets.only(top: 300),
        children: tasks.map((Task item) {
          _buildListTile(item);
        }).toList(),
        onReorder: (oldIndex, newIndex) {
          setState(
            () {
              Task item = tasks[oldIndex];
              tasks.remove(item);
              tasks.insert(newIndex, item);
              item.index = newIndex;
            },
          );
        },
      ),
    );
  }

  void setIndex() {
    for (int i = 0; i < tasks.length; i++) {
          Task item = tasks[i];
      if (item.index > -1 && item.index < tasks.length) {
        if(item.index == i+1){
            item.index = i;
            widget.repository.updateUserTask(item);
          }else if(item.index != i){
            tasks.remove(item);
            tasks.insert(item.index, item);
          }
      } else {
        item.index = i;
        widget.repository.updateUserTask(item);
      }
    }
  }

  Widget _buildListTile(Task item) {
    print("Build List Tile: " + item.title);

    return Dismissible(
      key: ValueKey(item.taskKey),
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
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Task " + item.title + " dismissed"),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              widget.reAddTask(item);
              tasks.insert(item.index, item);
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
