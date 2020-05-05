import 'package:flutter/material.dart';
import 'package:todolist/UI/home_tab.dart';
import 'package:todolist/UI/task_list.dart';
import 'package:todolist/UI/title_card.dart';
import 'package:todolist/models/global.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      theme: ThemeData(
        primaryColor: Color(0xffbf0426),
      ),
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
          appBar: new TabBar(
            tabs: [
              Tab(
                icon: new Icon(Icons.menu, color: lightBlue),
              ),
              Tab(
                icon: new Icon(Icons.account_circle, color: lightBlue),
              )
            ],
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.transparent,
          ),
          backgroundColor: red,
          body: Container(
            child: TabBarView(children: [HomeTab(), TaskList()]),
          ),
        ),
      ),
    );
  }
}
