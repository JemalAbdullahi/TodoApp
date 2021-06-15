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
  int orderBy;

  @override
  void initState() {
    taskBloc = TaskBloc(widget.group.groupKey);
    orderBy = 1;
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
              icon: Icon(Icons.arrow_back, size: 32.0, color: darkBlueGradient),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.blueGrey,
            ),
            actions: [
              _popupMenuButton(),
            ],
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
              return _buildList();
            }
            return SizedBox.shrink();
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget _buildList() {
    _orderBy(orderBy);
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
  }

  PopupMenuButton _popupMenuButton() {
    return PopupMenuButton<int>(
      icon: Icon(Icons.sort, size: 32.0, color: darkBlueGradient),
      iconSize: 24.0,
      color: darkGreenBlue,
      offset: Offset(0, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      onSelected: (value) {
        setState(() {
          orderBy = value;
        });
      },
      itemBuilder: (context) => [
        PopupMenuItem<int>(
          value: 0,
          child: Row(children: [
            Icon(Icons.sort_by_alpha),
            SizedBox(width: 6.0),
            Text(
              "Alphabetical",
              style: TextStyle(color: Colors.white),
            )
          ]),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Row(children: [
            Icon(Icons.date_range),
            SizedBox(width: 6.0),
            Text(
              "Recent-Oldest",
              style: TextStyle(color: Colors.white),
            )
          ]),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Row(children: [
            Icon(Icons.date_range),
            SizedBox(width: 6.0),
            Text(
              "Oldest-Recent",
              style: TextStyle(color: Colors.white),
            )
          ]),
        ),
      ],
    );
  }

  _orderBy(int value) {
    orderBy = value;
    switch (value) {
      case 0:
        widget.group.tasks.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case 1:
        widget.group.tasks
            .sort((a, b) => b.timeUpdated.compareTo(a.timeUpdated));
        print(widget.group.tasks.toString());
        break;
      case 2:
        widget.group.tasks
            .sort((a, b) => a.timeUpdated.compareTo(b.timeUpdated));
        print(widget.group.tasks.toString());
        break;
      default:
    }
  }
}
