import 'package:flutter/material.dart';
import 'package:todolist/UI/tabs/list_groups_tab.dart';

//import 'package:todolist/UI/tabs/todo_tab.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/tasks.dart';
//import 'package:todolist/models/user.dart';
import 'package:todolist/widgets/global_widgets/avatar.dart';
import 'package:todolist/widgets/sidebar_widgets/sidebar_menu.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';

class HomePage extends StatefulWidget {
  final VoidCallback logout;
  final VoidCallback addTaskDialog;
  final void Function(Task) reAddTask;
  final TaskBloc tasksBloc;
  final String title;
  final Repository repository;

  final GroupBloc groupBloc;

  HomePage(
      {this.repository,
      this.title,
      this.logout,
      this.addTaskDialog,
      this.tasksBloc,
      this.groupBloc,
      this.reAddTask});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isMenuOpen = false;
  //User _user = userBloc.getUserObject();

  @override
  Widget build(BuildContext context) {
    print("Home Page State");
    return SafeArea(
      child: KeyboardSizeProvider(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            leading: IconButton(
              icon: isMenuOpen ? Icon(Icons.arrow_back) : Avatar(),
              onPressed: () {
                setState(() {
                  isMenuOpen = !isMenuOpen;
                });
              },
            ),
          ),
          body: Container(
            child: Stack(
              children: <Widget>[
                ListGroupsTab(
                    groupBloc: widget.groupBloc, repository: widget.repository),
                //ToDoTab(widget.addTaskDialog, widget.tasksBloc, widget.repository, widget.reAddTask),
                SideBarMenu(
                  isMenuOpen: isMenuOpen,
                  logout: widget.logout,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
