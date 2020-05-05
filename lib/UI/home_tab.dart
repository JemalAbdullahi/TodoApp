import 'package:flutter/material.dart';
import 'package:todolist/UI/title_card.dart';

import 'package:todolist/models/global.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [lightBlue, lightBlueGradient],
            ),
          ),
        ),
        TitleCard('To Do'),
      ],
    );
  }
}
