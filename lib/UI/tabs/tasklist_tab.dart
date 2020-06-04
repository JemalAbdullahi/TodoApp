import 'package:flutter/material.dart';
import 'package:todolist/UI/title_card.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/subtasks.dart';
import 'package:todolist/widgets/subtask_list_item_widget.dart';

class TaskListTab extends StatefulWidget {
  final Repository repository;
  final taskKey;
  final SubTaskBloc subTaskBloc;

  TaskListTab(this.repository, this.taskKey, this.subTaskBloc);

  @override
  _TaskListTabState createState() => _TaskListTabState();
}

class _TaskListTabState extends State<TaskListTab> {
  List<SubTask> subTasks = [];

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
              initialData: [], // provide an initial data
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot != null) {
                  if (snapshot.data.length > 0) {
                    return _buildReorderableList(context, snapshot.data);
                  } else if (snapshot.data.length == 0) {
                    return Center(child: Text(''));
                  }
                } else if (snapshot.hasError) {
                  return Container();
                }
                return CircularProgressIndicator();
              }, // access the data in our Stream here
            ),
            TitleCard('Task List', addSubTaskDialog),
          ],
        ),
      ),
    );
  }

  Widget _buildReorderableList(BuildContext context, List<SubTask> subTasks) {
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
  }

  Widget _buildListTile(BuildContext context, SubTask item) {
    print(item.group);
    return ListTile(
      key: Key(item.subtaskId.toString()),
      title:
          SubTaskListItemWidget(subTask: item, repository: widget.repository),
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
    await widget.repository.addSubTask(taskKey, subtaskName, notes, index);
    setState(() {
      build(this.context);
    });
  }
}
