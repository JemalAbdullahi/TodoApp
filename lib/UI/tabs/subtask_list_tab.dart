import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:todolist/UI/title_card.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/bloc/resources/repository.dart';
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
  List<Subtask> subtasks = [];
  SubtaskBloc subtaskBloc;

  @override
  Widget build(BuildContext context) {
    print("Building SubtaskList Context");
    subtaskBloc = SubtaskBloc(widget.task.taskKey);
    subtasks = widget.task.subtasks;
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
                startColor: darkBlueGradient,
                endColor: darkBlue,
                widget:
                    TitleCard(title: 'Subtasks', child: _buildStreamBuilder()),
              ),
              AddSubtask(
                length: subtasks.length,
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
      initialData: subtasks, // provide an initial data
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
              subtasks = snapshot.data;
              _setIndex();
              return _buildList();
            }
            return SizedBox.shrink();
            break;
          case ConnectionState.waiting:
            //print("Waiting Data: " + snapshot.toString());
            /* if (subtasks.length == 0) {
              return SizedBox.shrink();
            } */
            if (!snapshot.hasData || snapshot.data.isEmpty)
              return Center(child: CircularProgressIndicator());
            break;
          case ConnectionState.done:
            //print("Done Data: " + snapshot.toString());
            if (snapshot.data.isNotEmpty) {
              subtasks = snapshot.data;
              _setIndex();
              return _buildList();
            }
            return SizedBox.shrink();
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget _buildList() {
    //print("Reorderable List" + subtasks.toString());
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      key: UniqueKey(),
      child: ListView(
        key: UniqueKey(),
        padding: EdgeInsets.only(top: 175, bottom: 90),
        children: subtasks.map<Dismissible>((Subtask item) {
          return _buildListTile(item);
        }).toList(),
      ),
    );
  }

  void _setIndex() {
    for (int i = 0; i < subtasks.length; i++) {
      if (subtasks[i].index != i) {
        subtasks[i].index = i;
        repository.updateSubtask(subtasks[i]);
      }
    }
  }

  Widget _buildListTile(Subtask subtask) {
    //print("Build List Tile: " + item.title);
    return Dismissible(
      key: Key(subtask.subtaskKey),
      child: ListTile(
        key: Key(subtask.title),
        title: SubtaskListItemWidget(
          subtask: subtask,
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
        subtaskBloc.deleteSubtask(subtask.subtaskKey);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Subtask " + subtask.title + " dismissed"),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              subtaskBloc.addSubtask(
                  subtask.title, subtask.index, subtask.completed);
            },
          ),
        ));
      },
      direction: DismissDirection.endToStart,
    );
  }

  void removeSubtask(Subtask subtask) {
    if (subtasks.contains(subtask)) {
      setState(() {
        subtasks.remove(subtask);
        _setIndex();
      });
    }
  }

  void reAddSubtask(Subtask subtask) async {
    await subtaskBloc.addSubtask(
        subtask.title, subtask.index, subtask.completed);
    setState(() {
      build(context);
    });
  }

  Future<Null> deleteTask(Subtask subtask) async {
    await subtaskBloc.deleteSubtask(subtask.subtaskKey);
  }
}
