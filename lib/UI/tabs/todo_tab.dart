import 'dart:async';

import 'package:flutter/foundation.dart';
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

/// Argument that can be passed when navigating to ToDoTab
/// * group
class ToDoTab extends StatefulWidget {
  static const routeName = '/list_tasks';
  @override
  _ToDoTabState createState() => _ToDoTabState();
}

class _ToDoTabState extends State<ToDoTab> {
  late TaskBloc taskBloc;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late Group group;
  int orderBy;
  bool reorder;

  _ToDoTabState()
      : orderBy = 1,
        reorder = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ToDoTabArguments;
    group = args.group;
    taskBloc = TaskBloc(group.groupKey);
    return KeyboardSizeProvider(
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
              group.name,
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
                length: group.tasks.length,
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
      initialData: group.tasks, // provide an initial data
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            print("None Data");
            break;
          case ConnectionState.active:
            print("Active Data: " +
                snapshot.data.toString() +
                " @" +
                DateTime.now().toString());
            if (snapshot.hasData && !listEquals(group.tasks, snapshot.data)) {
              group.tasks = snapshot.data!;
            }
            if (reorder) {
              reorder = false;
            }
            return _buildList();
          case ConnectionState.waiting:
            return Center(
                child: CircularProgressIndicator(color: Colors.black54));
          case ConnectionState.done:
            print("Done Data: " + snapshot.toString());
            break;
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
        children: group.tasks.map<Dismissible>((Task item) {
          return _buildListTile(item);
        }).toList(),
      ),
    );
  }

  Dismissible _buildListTile(Task item) {
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
      onDismissed: (direction) async {
        await deleteTask(item);
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

  /* void removeTask(Task task) {
    if (group.tasks.contains(task)) {
      setState(() {
        group.tasks.remove(task);
      });
    }
  } */

  void reAddTask(Task task) async {
    await taskBloc
        .addTask(task.title)
        .then((value) {
      setState(() {});
    });
  }

  Future<Null> deleteTask(Task task) async {
    await taskBloc.deleteTask(task.taskKey).then((value) {
      setState(() {});
    });
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
          reorder = true;
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
        group.tasks.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case 1:
        group.tasks.sort((a, b) => b.timeUpdated.compareTo(a.timeUpdated));
        break;
      case 2:
        group.tasks.sort((a, b) => a.timeUpdated.compareTo(b.timeUpdated));
        break;
      default:
    }
  }
}

class ToDoTabArguments {
  final Group group;

  ToDoTabArguments(this.group);
}
