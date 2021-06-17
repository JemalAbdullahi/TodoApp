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
  final Task task;

  SubtaskListTab({@required this.task});

  @override
  _SubtaskListTabState createState() => _SubtaskListTabState();
}

class _SubtaskListTabState extends State<SubtaskListTab> {
  //List<Subtask> subtasks;
  SubtaskBloc subtaskBloc;
  int orderBy;

  @override
  void initState() {
    subtaskBloc = SubtaskBloc(widget.task.taskKey);
    orderBy = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardSizeProvider(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.task.title,
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
                length: widget.task.subtasks.length,
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
      initialData: widget.task.subtasks, // provide an initial data
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
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
              widget.task.subtasks = snapshot.data;
              print("Group Task List: " +
                  widget.task.subtasks.toString() +
                  " @" +
                  DateTime.now().toString());

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
              widget.task.subtasks = snapshot.data;

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
        children: widget.task.subtasks.map<Dismissible>((Subtask item) {
          return _buildListTile(item);
        }).toList(),
      ),
    );
  }

  Widget _buildListTile(Subtask subtask) {
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
    if (widget.task.subtasks.contains(subtask)) {
      setState(() {
        widget.task.subtasks.remove(subtask);
      });
    }
  }

  void reAddSubtask(Subtask subtask) async {
    await subtaskBloc.addSubtask(
        subtask.title, subtask.index, subtask.completed);
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
        widget.task.subtasks.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case 1:
        widget.task.subtasks
            .sort((a, b) => b.timeUpdated.compareTo(a.timeUpdated));
        break;
      case 2:
        widget.task.subtasks
            .sort((a, b) => a.timeUpdated.compareTo(b.timeUpdated));
        break;
      default:
    }
  }
}
