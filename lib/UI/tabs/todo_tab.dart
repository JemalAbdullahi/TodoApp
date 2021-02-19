import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';

import 'package:todolist/UI/title_card.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/group.dart';
import 'package:todolist/models/tasks.dart';
import 'package:todolist/widgets/global_widgets/background_color_container.dart';
import 'package:todolist/widgets/task_widgets/add_task_widget.dart';
import 'package:todolist/widgets/task_widgets/task_list_item_widget.dart';

class ToDoTab extends StatefulWidget {
  final Group group;

  ToDoTab({@required this.group});
  @override
  _ToDoTabState createState() => _ToDoTabState();
}

class _ToDoTabState extends State<ToDoTab> {
  List<Task> tasks;
  TaskBloc taskBloc;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    taskBloc = TaskBloc(widget.group.groupKey);
    tasks = widget.group.tasks;
    return KeyboardSizeProvider(
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: appTitle,
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.blueGrey,
            ),
          ),
          body: Stack(
            children: <Widget>[
              BackgroundColorContainer(
                startColor: lightBlue,
                endColor: lightBlueGradient,
                widget: TitleCard(
                  title: 'Projects/Tasks',
                  child: _buildStreamBuilder(),
                ),
              ),
              AddTask(
                length: tasks.length,
                taskbloc: taskBloc,
              ),
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<List<Task>> _buildStreamBuilder() {
    return StreamBuilder(
      key: UniqueKey(),
      // Wrap our widget with a StreamBuilder
      stream: taskBloc.getTasks, // pass our Stream getter here
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
            if (snapshot.data.isNotEmpty) {
              tasks = snapshot.data;
              _setIndex();
              return _buildReorderableList();
            }
            return SizedBox.shrink();
            break;
          case ConnectionState.waiting:
            //print("Waiting Data: " + snapshot.toString());
            if (tasks.length == 0) {
              return SizedBox.shrink();
            }
            break;
          case ConnectionState.done:
            //print("Done Data: " + snapshot.toString());
            if (snapshot.data.isNotEmpty) {
              tasks = snapshot.data;
              _setIndex();
              return _buildReorderableList();
            }
            return SizedBox.shrink();
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget _buildReorderableList() {
    //print("Reorderable List" + tasks.toString());
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      key: UniqueKey(),
      child: ReorderableListView(
        key: UniqueKey(),
        padding: EdgeInsets.only(top: 175),
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
              repository.updateTask(item);
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
        repository.updateTask(tasks[i]);
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
        //removeTask(item);
        //deleteTask(item);
        taskBloc.deleteTask(item.taskKey);
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Task " + item.title + " dismissed"),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              //reAddTask(item);
              //tasks.insert(item.index, item);
              //_setIndex();
              taskBloc.addTask(item.title, item.index, item.completed);
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

  /* void addTask(Task task) {
    tasks.insert(task.index, task);
  } */

  void reAddTask(Task task) async {
    await repository.addTask(
        task.title, task.groupKey, task.index, task.completed);
    setState(() {
      build(context);
    });
  }

  Future<Null> deleteTask(Task task) async {
    removeTask(task);
    await repository.deleteTask(task.taskKey);
  }
}
