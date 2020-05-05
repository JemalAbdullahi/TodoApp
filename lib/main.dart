import 'package:flutter/material.dart';
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
          backgroundColor: darkRed,
          body: Stack(
            children: <Widget>[
              TabBarView(
                children: [
                  new Container(
                    color: lightBlue,
                  ),
                  new Container(
                    color: darkBlue,
                  ),
                ],
              ),
              Container(
                height: 120,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
              Positioned(
                top: 90,
                child: Center(
                  widthFactor: 7.2,
                  child: FloatingActionButton(
                    onPressed: null,
                    child: Icon(Icons.add),
                  ),
                ),
                //left: MediaQuery.of(context).size.width * 0.5,
              ),
              Positioned(
                height: 53,
                top: 45,
                left: 30,
                child: Text(
                  'To Do',
                  style: cardTitleStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
