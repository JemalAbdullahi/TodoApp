import 'package:flutter/material.dart';

import 'package:todolist/models/global.dart';
//import 'package:todolist/widgets/create_task_overlay.dart';

class TitleCard extends StatelessWidget {
  final String title;
  final Widget child;
  //final VoidCallback addTask;

  TitleCard({this.title, this.child});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        _titleCardBackground(),
      ],
    );
  }

  Container _titleCardBackground() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          new BoxShadow(
            color: Colors.black.withOpacity(0.7),
            blurRadius: 25.0,
          ),
        ],
      ),
      child: _titleCardTitle(),
      padding: EdgeInsets.only(bottom: 20, left: 15.0),
    );
  }

  Align _titleCardTitle() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Text(
        title,
        style: cardTitleStyle,
      ),
    );
  }
}
