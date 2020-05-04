import 'package:flutter/material.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
                icon: new Icon(Icons.home),
              ),
              Tab(
                icon: new Icon(Icons.settings),
              )
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.blue,
            labelPadding: EdgeInsets.all(2.0),
          ),
          backgroundColor: Color(0xffbf0426),
          body: Stack(
            children: <Widget>[
              TabBarView(
                children: [
                  new Container(
                    color: Color(0xffceecf2),
                  ),
                  new Container(
                    color: Color(0xff023059),
                  ),
                ],
              ),
              Container(
                height: 120,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              Positioned(
                top: 90,
                left: 175,
                child: FloatingActionButton(
                  onPressed: null,
                  child: Icon(Icons.add),
                ),
              ),
              Positioned(
                width: 110,
                height: 53,
                top: 45,
                left: 20,
                child: Text('To Do',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffbf0426),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
