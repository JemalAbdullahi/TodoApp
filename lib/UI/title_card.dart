import 'package:flutter/material.dart';

import 'package:todolist/models/global.dart';
//import 'package:todolist/widgets/create_task_overlay.dart';

class TitleCard extends StatelessWidget {
  final String title;
  final VoidCallback addTask;

  TitleCard(this.title, this.addTask);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _TitleCardBackground(),
        _TitleCardTitle(title),
        _TitleCardButton(addTask),
      ],
    );
  }
}

class _TitleCardTitle extends StatelessWidget {
  final String title;
  _TitleCardTitle(this.title);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      height: 53,
      top: 35,
      left: 30,
      child: Text(
        title,
        style: cardTitleStyle,
      ),
    );
  }
}

class _TitleCardBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
    );
  }
}

class _TitleCardButton extends StatefulWidget {
  final VoidCallback addTaskDialog;
  

  _TitleCardButton(this.addTaskDialog);

  @override
  __TitleCardButtonState createState() => __TitleCardButtonState();
}

class __TitleCardButtonState extends State<_TitleCardButton> {
  Widget listOverlay() {
    print("In listOverlay");
    return Positioned(
      top: 200,
      child: Container(
        height: 200,
        color: red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.1,
      origin: Offset(-1800, -950),
      child: FloatingActionButton(
        tooltip: "Press to Add a Task",
        onPressed: () {
          widget.addTaskDialog();
        },
        child: Icon(Icons.add, size: 40),
      ),
    );
  }
}
