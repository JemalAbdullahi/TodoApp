import 'package:flutter/material.dart';
//import 'package:todolist/UI/title_card.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/subtasks.dart';
import 'package:todolist/widgets/global_widgets/background_color_container.dart';
import 'package:todolist/widgets/task_widgets/subtask_list_tile.dart';

class SubtaskContainerWidget extends StatefulWidget {
  SubtaskContainerWidget(
      {Key key, @required this.taskKey})
      : super(key: key);

  final String taskKey;

  @override
  _SubtaskContainerWidgetState createState() => _SubtaskContainerWidgetState();
}

class _SubtaskContainerWidgetState extends State<SubtaskContainerWidget> {
  List<SubTask> subtasks = [];
  SubTaskBloc sBloc;

  @override
  Widget build(BuildContext context) {
    sBloc = new SubTaskBloc(widget.taskKey);
    return Stack(
      children: <Widget>[
        BackgroundColorContainer(
          startColor: darkBlueGradient,
          endColor: darkBlue,
        ),
        StreamBuilder(
          // Wrap our widget with a StreamBuilder
          stream: sBloc.getSubTasks, // pass our Stream getter here
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
                if (snapshot.data.isEmpty) {
                  return Center(
                      child: Container(child: Text("No Data Available")));
                } else {
                  subtasks = snapshot.data;
                  setIndex();
                  return _buildReorderableList();
                }
                break;
              case ConnectionState.waiting:
                //print("Waiting Data: " + snapshot.toString());
                if (subtasks.length == 0) {
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
                  subtasks = snapshot.data;
                  setIndex();
                  return _buildReorderableList();
                }
            }
            return CircularProgressIndicator();
          },
        ),
        //TitleCard('SubTask List', addSubTaskDialog),
      ],
    );
  }

  Widget _buildReorderableList() {
    //print("Reorderable List" + subtasks.toString());
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      key: UniqueKey(),
      child: ReorderableListView(
        key: UniqueKey(),
        padding: EdgeInsets.only(top: 300),
        children: subtasks.map((SubTask item) {
          return SubtaskListTile(
            key: Key(item.subtaskKey),
            widget: widget,
            context: context,
            subtasks: subtasks,
            item: item,
            setIndex: setIndex,
            updateIndex: updateIndex,
            reAddSubTask: reAddSubTask,
            deleteSubTask: deleteSubTask,
          );
        }).toList(),
        onReorder: (oldIndex, newIndex) {
          setState(
            () {
              SubTask item = subtasks[oldIndex];
              subtasks.remove(item);
              if (newIndex < subtasks.length) {
                subtasks.insert(newIndex, item);
              } else if (newIndex == subtasks.length) {
                subtasks.add(item);
              }
              item.index = newIndex;
              repository.updateSubTask(item);
              updateIndex();
            },
          );
        },
      ),
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
                        if (_subtaskNameController.text.isNotEmpty) {
                          addSubTask(
                              widget.taskKey,
                              _subtaskNameController.text,
                              _noteController.text,
                              -1,
                              false);
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

  void addSubTask(String taskKey, String subtaskName, String notes, int index,
      bool completed) async {
    await repository
        .addSubTask(taskKey, subtaskName, notes, index, completed)
        .then((_) => setState(() {
              build(this.context);
            }));
  }

  void reAddSubTask(SubTask subtask) {
    addSubTask(widget.taskKey, subtask.title, subtask.note, subtask.index,
        subtask.completed);
  }

  void setIndex() {
    for (int i = 0; i < subtasks.length; i++) {
      SubTask item = subtasks[i];
      if (item.index != i) {
        subtasks.remove(item);
        if (item.index >= subtasks.length || item.index == -1) {
          subtasks.add(item);
          item.index = subtasks.length - 1;
          repository.updateSubTask(item);
        } else {
          subtasks.insert(item.index, item);
        }
        print("Set Subtask: " +
            subtasks[i].title +
            " | " +
            subtasks[i].index.toString());
      }
    }
  }

  void updateIndex() {
    for (int i = 0; i < subtasks.length; i++) {
      if (subtasks[i].index != i) {
        subtasks[i].index = i;
        repository.updateSubTask(subtasks[i]);
        print("Updated Subtask: " +
            subtasks[i].title +
            " | " +
            subtasks[i].index.toString());
      }
    }
  }

  void removeSubTask(SubTask subtask) {
    if (subtasks.contains(subtask)) {
      setState(() {
        subtasks.remove(subtask);
        updateIndex();
      });
    }
  }

  Future<Null> deleteSubTask(SubTask subtask) async {
    await repository.deleteSubTask(subtask.subtaskKey);
    removeSubTask(subtask);
  }
}
