import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';

import 'package:todolist/UI/title_card.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
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
  TaskBloc taskBloc;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    taskBloc = TaskBloc(widget.group.groupKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardSizeProvider(
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
              widget.group.name,
              style: appTitleStyle,
            ),
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
                length: widget.group.tasks.length,
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
      initialData: widget.group.tasks, // provide an initial data
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            print("None Data");
            return Container(
              child: Center(
                child: Text("No Connection Message"),
              ),
            );
          case ConnectionState.active:
            print("Active Data: " +
                snapshot.data.toString() +
                " @" +
                DateTime.now().toString());
            if (snapshot.data.isNotEmpty) {
              widget.group.tasks = snapshot.data;
              print("Group Task List: " +
                  widget.group.tasks.toString() +
                  " @" +
                  DateTime.now().toString());
              //_setIndex();
              return _buildList();
            }
            return SizedBox.shrink();
            break;
          case ConnectionState.waiting:
            print("Waiting Data" +
                snapshot.data.toString() +
                " @" +
                DateTime.now().toString());
            return Center(child: CircularProgressIndicator());
            break;
          case ConnectionState.done:
            print("Done Data: " + snapshot.toString());
            if (snapshot.data.isNotEmpty) {
              widget.group.tasks = snapshot.data;
              //_setIndex();
              return _buildList();
            }
            return SizedBox.shrink();
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget _buildList() {
    //print("Reorderable List" + widget.group.tasks.toString());
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      key: UniqueKey(),
      child: ListView(
        key: UniqueKey(),
        padding: EdgeInsets.only(top: 175, bottom: 90),
        children: widget.group.tasks.map<Dismissible>((Task item) {
          return _buildListTile(item);
        }).toList(),
      ),
    );
  }

  /* void _setIndex() {
    for (int i = 0; i < widget.group.tasks.length; i++) {
      if (tasks[i].index != i) {
        widget.group.tasks[i].index = i;
        repository.updateTask(tasks[i]);
      }
    }
  } */

  Widget _buildListTile(Task item) {
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
        deleteTask(item);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Task " + item.title + " dismissed"),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                reAddTask(item);
              },
            ),
          ),
        );
      },
      direction: DismissDirection.endToStart,
    );
  }

  void removeTask(Task task) {
    if (widget.group.tasks.contains(task)) {
      setState(() {
        widget.group.tasks.remove(task);
        //_setIndex();
      });
    }
  }

  void reAddTask(Task task) async {
    await taskBloc.addTask(task.title, task.index, task.completed);
    setState(() {});
  }

  Future<Null> deleteTask(Task task) async {
    await taskBloc.deleteTask(task.taskKey);
    setState(() {});
    //removeTask(task);
  }
}
