import 'package:flutter/material.dart';

import 'package:todolist/UI/tabs/tasklist_tab.dart';
import 'package:todolist/UI/tabs/todo_tab.dart';

class HomePage extends StatefulWidget {
  final String title;

  HomePage({this.title});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: new Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(icon: Icon(Icons.menu), onPressed: null),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.account_circle), onPressed: null)
            ],
          ),
          /*bottomNavigationBar: new TabBar(
            tabs: [
              Tab(icon: new Icon(Icons.menu, color: lightBlue)),
              Tab(icon: new Icon(Icons.account_circle, color: lightBlue))
            ],
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.transparent,
          ),*/
          //backgroundColor: red,
          body: Container(
            child: TabBarView(children: [ToDoTab(), TaskListTab()]),
          ),
        ),
      ),
    );
  }
}
