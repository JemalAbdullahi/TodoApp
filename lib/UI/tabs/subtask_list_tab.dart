import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:todolist/UI/title_card.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/subtasks.dart';
import 'package:todolist/models/tasks.dart';
import 'package:todolist/widgets/global_widgets/background_color_container.dart';
import 'package:todolist/widgets/task_widgets/add_subtask_widget.dart';
import 'package:todolist/widgets/task_widgets/subtask_list_item_widget.dart';

class SubtaskListTab extends StatefulWidget {
  static const routeName = '/listSubtasksTab';
  @override
  _SubtaskListTabState createState() => _SubtaskListTabState();
}

class _SubtaskListTabState extends State<SubtaskListTab> {
  //List<Subtask> subtasks;
  late SubtaskBloc subtaskBloc;
  late Task task;
  int orderBy;
  bool reorder;

  _SubtaskListTabState()
      : orderBy = 1,
        reorder = false;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as SubtaskListTabArguments;
    task = args.task;
    subtaskBloc = SubtaskBloc(task);
    return KeyboardSizeProvider(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              task.title,
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
            actions: [_popupMenuButton()],
          ),
          body: Stack(
            children: <Widget>[
              BackgroundColorContainer(
                startColor: lightGreenBlue,
                endColor: darkGreenBlue,
                widget: TitleCard(title: 'To Do', child: _buildStreamBuilder()),
              ),
              AddSubtask(
                length: task.subtasks.length,
                subtaskBloc: subtaskBloc,
              ),
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<List<Subtask>> _buildStreamBuilder() {
    return StreamBuilder(
      // Wrap our widget with a StreamBuilder
      stream: subtaskBloc.getSubtasks, // pass our Stream getter here
      initialData: task.subtasks, // provide an initial data
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            break;
          case ConnectionState.active:
            print("Active Data: " +
                snapshot.data.toString() +
                " @" +
                DateTime.now().toString());
            if (snapshot.hasData && !listEquals(task.subtasks, snapshot.data)) {
              task.subtasks = snapshot.data!;
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
        children: task.subtasks.map<Dismissible>((Subtask item) {
          return _buildListTile(item);
        }).toList(),
      ),
    );
  }

  Dismissible _buildListTile(Subtask subtask) {
    return Dismissible(
      key: Key(subtask.subtaskKey),
      child: ListTile(
        key: Key(subtask.title),
        title: SubtaskListItemWidget(
          subtask: subtask,
          subtaskBloc: subtaskBloc,
        ),
      ),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: darkRed,
        child: Icon(
          Icons.delete,
          color: lightGreenBlue,
        ),
      ),
      onDismissed: (direction) {
        deleteSubtask(subtask);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Subtask " + subtask.title + " dismissed"),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              reAddSubtask(subtask);
            },
          ),
        ));
      },
      direction: DismissDirection.endToStart,
    );
  }

  void removeSubtask(Subtask subtask) {
    if (task.subtasks.contains(subtask)) {
      setState(() {
        task.subtasks.remove(subtask);
      });
    }
  }

  void reAddSubtask(Subtask subtask) async {
    await subtaskBloc.addSubtask(
        subtask.title);
    setState(() {});
  }

  Future<Null> deleteSubtask(Subtask subtask) async {
    await subtaskBloc.deleteSubtask(subtask.subtaskKey);
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
        task.subtasks.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case 1:
        task.subtasks.sort((a, b) => b.timeUpdated.compareTo(a.timeUpdated));
        break;
      case 2:
        task.subtasks.sort((a, b) => a.timeUpdated.compareTo(b.timeUpdated));
        break;
      default:
    }
  }
}

class SubtaskListTabArguments {
  final Task task;
  SubtaskListTabArguments(this.task);
}
