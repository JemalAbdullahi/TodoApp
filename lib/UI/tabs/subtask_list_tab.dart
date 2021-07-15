import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/UI/title_card.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/group.dart';
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
  late Group group;
  late Task task;
  late double unitHeightValue, unitWidthValue, height;
  late String orderBy;
  bool reorder;

  _SubtaskListTabState() : reorder = false {
    getOrderBy();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as SubtaskListTabArguments;
    task = args.task;
    group = args.group;
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.001;
    Size mediaQuery = MediaQuery.of(context).size;
    height = mediaQuery.height * 0.13;
    subtaskBloc = SubtaskBloc(task);
    return KeyboardSizeProvider(
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                task.title,
                style: appTitleStyle(unitHeightValue),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back,
                    size: 32.0 * unitHeightValue, color: darkBlueGradient),
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
                  widget:
                      TitleCard(title: 'To Do', child: _buildStreamBuilder()),
                ),
                AddSubtask(
                  length: task.subtasks.length,
                  subtaskBloc: subtaskBloc,
                ),
              ],
            ),
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
    _orderBy();
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      key: UniqueKey(),
      child: ListView(
        key: UniqueKey(),
        padding: EdgeInsets.only(top: height + 40, bottom: 90),
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
          group: group,
        ),
      ),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: darkRed,
        child: Icon(
          Icons.delete,
          color: lightGreenBlue,
          size: 28 * unitHeightValue,
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
    await subtaskBloc.addSubtask(subtask.title);
    setState(() {});
  }

  Future<Null> deleteSubtask(Subtask subtask) async {
    await subtaskBloc.deleteSubtask(subtask.subtaskKey);
    setState(() {});
  }

  PopupMenuButton _popupMenuButton() {
    return PopupMenuButton<String>(
      padding: EdgeInsets.symmetric(
          vertical: 8 * unitHeightValue, horizontal: 8 * unitWidthValue),
      icon: Icon(Icons.sort,
          size: 32.0 * unitHeightValue, color: darkBlueGradient),
      color: darkGreenBlue,
      offset: Offset(0, 70 * unitHeightValue),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      onSelected: (value) {
        saveOrderBy(value);
        setState(() {
          reorder = true;
        });
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: "Alphabetical",
          child: Row(children: [
            Icon(Icons.sort_by_alpha, size: 24 * unitHeightValue),
            SizedBox(width: 30.0 * unitWidthValue),
            Text(
              "Alphabetical",
              style: TextStyle(
                  color: Colors.white, fontSize: 24 * unitHeightValue),
            )
          ]),
        ),
        PopupMenuItem<String>(
          value: "Recent-Oldest",
          child: Row(children: [
            Icon(Icons.date_range, size: 24 * unitHeightValue),
            SizedBox(width: 30.0 * unitWidthValue),
            Text(
              "Recent-Oldest",
              style: TextStyle(
                  color: Colors.white, fontSize: 24 * unitHeightValue),
            )
          ]),
        ),
        PopupMenuItem<String>(
          value: "Oldest-Recent",
          child: Row(children: [
            Icon(Icons.date_range, size: 24 * unitHeightValue),
            SizedBox(width: 30.0 * unitWidthValue),
            Text(
              "Oldest-Recent",
              style: TextStyle(
                  color: Colors.white, fontSize: 24 * unitHeightValue),
            )
          ]),
        ),
        PopupMenuItem<String>(
          value: "Due Date",
          child: Row(children: [
            Icon(Icons.date_range, size: 24 * unitHeightValue),
            SizedBox(width: 30.0 * unitWidthValue),
            Text(
              "Due Date",
              style: TextStyle(
                  color: Colors.white, fontSize: 24 * unitHeightValue),
            )
          ]),
        ),
      ],
    );
  }

  _orderBy() {
    switch (orderBy) {
      case "Alphabetical":
        task.subtasks.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case "Recent-Oldest":
        task.subtasks.sort((a, b) => b.timeCreated.compareTo(a.timeCreated));
        break;
      case "Oldest-Recent":
        task.subtasks.sort((a, b) => a.timeCreated.compareTo(b.timeCreated));
        break;
      case "Due Date":
        task.subtasks.sort((a, b) => a.deadline.compareTo(b.deadline));
        break;
      default:
    }
  }

  /// Get order list from persistant storage.
  void getOrderBy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.orderBy = prefs.getString('SUBTASK_ORDER_LIST') ?? "Recent-Oldest";
  }

  /// Save orderlist to Device's persistant storage
  Future<void> saveOrderBy(String orderBy) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('SUBTASK_ORDER_LIST', orderBy);
    this.orderBy = orderBy;
  }
}

class SubtaskListTabArguments {
  final Group group;
  final Task task;
  SubtaskListTabArguments(this.group, this.task);
}
