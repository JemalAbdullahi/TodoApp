import 'package:flutter/material.dart';
import 'package:todolist/UI/title_card.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/subtasks.dart';
import 'package:todolist/widgets/subtask_list_item_widget.dart';

class TaskListTab extends StatefulWidget {
  final SubTaskBloc subTaskBloc;
  final Repository repository;
  //final void Function(SubTask) reAddSubTask;
  //final VoidCallback addTaskDialog;
  final taskKey;

  TaskListTab(this.repository, this.taskKey, this.subTaskBloc);

  @override
  _TaskListTabState createState() => _TaskListTabState();
}

class _TaskListTabState extends State<TaskListTab> {
  List<SubTask> subtasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.blueGrey,
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.account_circle), onPressed: null)
        ],
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [darkBlueGradient, darkBlue],
                ),
              ),
            ),
            StreamBuilder(
              // Wrap our widget with a StreamBuilder
              stream:
                  widget.subTaskBloc.getSubTasks, // pass our Stream getter here
              initialData: subtasks, // provide an initial data
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
                      subtasks = snapshot.data;
                      _setIndex();
                      return _buildReorderableList();
                    }
                    break;
                  case ConnectionState.waiting:
                    print("Waiting Data: " + snapshot.toString());
                    if (subtasks.length == 0) {
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
                      subtasks = snapshot.data;
                      _setIndex();
                      return _buildReorderableList();
                    }
                }
                return CircularProgressIndicator();
              },
            ),
            TitleCard('SubTask List', addSubTaskDialog),
          ],
        ),
      ),
    );
  }

  Widget _buildReorderableList() {
    print("Reorderable List" + subtasks.toString());
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      key: UniqueKey(),
      child: ReorderableListView(
        key: UniqueKey(),
        padding: EdgeInsets.only(top: 300),
        children: subtasks.map<Dismissible>((SubTask item) {
          return _buildListTile(item);
        }).toList(),
        onReorder: (oldIndex, newIndex) {
          setState(
            () {
              SubTask item = subtasks[oldIndex];
              subtasks.remove(item);
              subtasks.insert(newIndex, item);
              item.index = newIndex;
              widget.repository.updateSubTask(item);
            },
          );
        },
      ),
    );
  }

  /* Widget _buildReorderableList(BuildContext context, List<SubTask> subTasks) {
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      child: ReorderableListView(
        padding: EdgeInsets.only(top: 300),
        children: subTasks
            .map((SubTask item) => _buildListTile(context, item))
            .toList(),
        onReorder: (oldIndex, newIndex) {
          setState(
            () {
              SubTask item = subTasks[oldIndex];
              subTasks.remove(item);
              subTasks.insert(newIndex, item);
            },
          );
        },
      ),
    );
  } */

  /* Widget _buildListTile(SubTask item) {
    print(item.group);
    return ListTile(
      key: Key(item.subtaskId.toString()),
      title:
          SubTaskListItemWidget(subTask: item, repository: widget.repository),
    );
  } */

  Widget _buildListTile(SubTask item) {
    print("Build List Tile: " + item.title);

    return Dismissible(
      key: Key(item.subtaskKey),
      child: ListTile(
        key: Key(item.title),
        title:
            SubTaskListItemWidget(subTask: item, repository: widget.repository),
      ),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: darkRed,
        child: Icon(
          Icons.delete,
          color: darkBlueGradient,
        ),
      ),
      onDismissed: (direction) {
        removeSubTask(item);
        deleteSubTask(item);
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Task " + item.title + " dismissed"),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              reAddSubTask(item);
              subtasks.insert(item.index, item);
              _setIndex();
            },
          ),
        ));
      },
      direction: DismissDirection.endToStart,
    );
  }

  void addSubTaskDialog() {
    TextEditingController _subtaskNameController = new TextEditingController();
    TextEditingController _noteController = new TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: lightBlue,
          content: Container(
            height: 350,
            width: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("Add New SubTask", style: loginTitleStyle),
                TextField(
                  controller: _subtaskNameController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'SubTask Name',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                  ),
                ),
                TextField(
                  controller: _noteController,
                  minLines: 3,
                  maxLines: 5,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Notes',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                      child: Text(
                        "Save",
                        style: loginButtonStyle,
                      ),
                      disabledColor: darkBlueGradient,
                      color: lightBlueGradient,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.transparent),
                      ),
                      onPressed: () {
                        if (_subtaskNameController.text != null) {
                          addSubTask(
                              widget.taskKey,
                              _subtaskNameController.text,
                              _noteController.text,
                              -1);
                          Navigator.pop(context);
                        }
                      },
                    ),
                    SizedBox(width: 8.0),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void addSubTask(
      String taskKey, String subtaskName, String notes, int index) async {
    await widget.repository
        .addSubTask(taskKey, subtaskName, notes, index)
        .then((_) => setState(() {
              build(this.context);
            }));
  }

  void reAddSubTask(SubTask subtask) {
    addSubTask(widget.taskKey, subtask.title, subtask.note, subtask.index);
  }

  void removeSubTask(SubTask subtask) {
    if (subtasks.contains(subtask)) {
      setState(() {
        subtasks.remove(subtask);
        _setIndex();
      });
    }
  }

  Future<Null> deleteSubTask(SubTask subtask) async {
    removeSubTask(subtask);
    await widget.repository.deleteSubTask(subtask.subtaskKey);
  }

  /* void reAddSubTask(SubTask subtask) {
    addSubTask(subtask.title, subtask.note, subtask.index);
  } */

  void _setIndex() {
    for (int i = 0; i < subtasks.length; i++) {
      if (subtasks[i].index != i) {
        subtasks[i].index = i;
        widget.repository.updateSubTask(subtasks[i]);
      }
    }
  } //unused so far
}
