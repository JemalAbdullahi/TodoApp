import 'package:flutter/material.dart';

import 'package:todolist/UI/tabs/todo_tab.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/bloc/resources/repository.dart';

class HomePage extends StatefulWidget {
  final VoidCallback logout;
  final VoidCallback addTaskDialog;
  final TaskBloc tasksBloc;
  final String title;
  final Repository repository;

  HomePage(
      {this.repository,
      this.title,
      this.logout,
      this.addTaskDialog,
      this.tasksBloc});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(icon: Icon(Icons.menu), onPressed: null),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.account_circle, color: Colors.black),
                onPressed: () {
                  widget.logout();
                })
          ],
        ),
        body: Container(
          child: ToDoTab(widget.addTaskDialog, widget.tasksBloc, widget.repository),
        ),
      ),
    );
  }
}
