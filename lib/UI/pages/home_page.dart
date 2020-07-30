import 'package:flutter/material.dart';

import 'package:todolist/UI/tabs/todo_tab.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/tasks.dart';
import 'package:todolist/widgets/sidebar_widgets/sidebar_menu.dart';

class HomePage extends StatefulWidget {
  final VoidCallback logout;
  final VoidCallback addTaskDialog;
  final void Function(Task) reAddTask;
  final TaskBloc tasksBloc;
  final String title;
  final Repository repository;

  HomePage(
      {this.repository,
      this.title,
      this.logout,
      this.addTaskDialog,
      this.tasksBloc,
      this.reAddTask});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    print("Home Page State");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          leading: IconButton(
            icon: isMenuOpen ? Icon(Icons.arrow_back) : Icon(Icons.menu),
            onPressed: () {
              setState(() {
                isMenuOpen = !isMenuOpen;
              });
            },
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {
                  widget.logout();
                })
          ],
        ),
        body: Container(
          child: Stack(
            children: <Widget>[
              ToDoTab(widget.addTaskDialog, widget.tasksBloc, widget.repository,
                  widget.reAddTask),
              SideBarMenu(isMenuOpen: isMenuOpen)
            ],
          ),
        ),
      ),
    );
  }
}
