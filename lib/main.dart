import 'package:flutter/material.dart';

import 'package:todolist/UI/todo_tab.dart';
import 'package:todolist/UI/tasklist_tab.dart';


main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      //theme: ThemeData(primaryColor: Color(0xffbf0426)),
      home: HomePage(title: 'To Do App'),
    );
  }
}

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
