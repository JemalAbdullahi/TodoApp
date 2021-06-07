import 'package:flutter/material.dart';
import 'package:todolist/UI/pages/sidebar_pages/create_new_group_page.dart';
import 'package:todolist/UI/tabs/list_groups_tab.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';

import 'package:todolist/models/global.dart';
import 'package:todolist/widgets/global_widgets/avatar.dart';
import 'package:todolist/widgets/sidebar_widgets/sidebar_menu.dart';

class HomePage extends StatefulWidget {
  final String title;

  HomePage({this.title});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isMenuOpen = false;
  @override
  void initState() {
    groupBloc.updateGroups();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("TODO List", style: appTitleStyle),
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
          actions: [
            IconButton(
              icon: Icon(
                Icons.group_add,
                color: Colors.black,
                size: 32.0,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateGroupPage(),
                  ),
                );
              }, //will go to Create a group Page
            )
          ],
        ),
        body: Container(
          child: Stack(
            children: <Widget>[
              ListGroupsTab(),
              //ToDoTab(widget.addTaskDialog, widget.tasksBloc, widget.reAddTask),
              SideBarMenu(isMenuOpen: isMenuOpen)
            ],
          ),
        ),
      ),
    );
  }
}
