import 'package:flutter/material.dart';
import 'package:todolist/UI/tabs/list_groups_tab.dart';

import 'package:todolist/models/global.dart';
import 'package:todolist/widgets/global_widgets/avatar.dart';
import 'package:todolist/widgets/sidebar_widgets/sidebar_menu.dart';

class HomePage extends StatefulWidget {
  final VoidCallback logout;
  final String title;

  HomePage(
      {this.title,
      this.logout});

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
      child: Scaffold(
        appBar: AppBar(
          title: appTitle,
          centerTitle: true,
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
              ListGroupsTab(),
              //ToDoTab(widget.addTaskDialog, widget.tasksBloc, widget.reAddTask),
              SideBarMenu(
                isMenuOpen: isMenuOpen,
                logout: widget.logout,
              )
            ],
          ),
        ),
      ),
    );
  }
}
