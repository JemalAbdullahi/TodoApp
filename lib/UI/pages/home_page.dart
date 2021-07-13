import 'package:flutter/material.dart';
import 'package:todolist/UI/pages/sidebar_pages/create_new_group_page.dart';
import 'package:todolist/UI/tabs/list_groups_tab.dart';

import 'package:todolist/models/global.dart';
import 'package:todolist/widgets/sidebar_widgets/sidebar_menu.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isMenuOpen = false;
  late double unitHeightValue;

  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("TODO List", style: appTitleStyle(unitHeightValue)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: isMenuOpen
                ? Icon(Icons.arrow_back,
                    color: darkBlueGradient, size: 32.0 * unitHeightValue)
                : Icon(
                    Icons.settings,
                    size: 32.0 * unitHeightValue,
                    color: darkBlueGradient,
                  ),
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
                color: darkBlueGradient,
                size: 32 * unitHeightValue,
              ),
              onPressed: () {
                Navigator.pushNamed(context, CreateGroupPage.routeName);
              }, //will go to Create a group Page
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
        body: Container(
          child: Stack(
            children: <Widget>[
              ListGroupsTab(),
              SideBarMenu(isMenuOpen: isMenuOpen)
            ],
          ),
        ),
      ),
    );
  }
}
