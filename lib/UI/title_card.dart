import 'package:flutter/material.dart';
import 'package:todolist/models/global.dart';

class TitleCard extends StatelessWidget {
  final String title;

  TitleCard(this.title);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _TitleCardBackground(),
        Positioned(
          height: 53,
          top: 35,
          left: 30,
          child: Text(
            title,
            style: cardTitleStyle,
          ),
        ),
        Transform.scale(
          scale: 1.1,
          origin: Offset(-1800, -950),
          child: FloatingActionButton(
            onPressed: () {
              Text("New Container");
            },
            child: Icon(Icons.add, size: 40),
          ),
        ),
      ],
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
  @override
  __TitleCardButtonState createState() => __TitleCardButtonState();
}

class __TitleCardButtonState extends State<_TitleCardButton> {
  __TitleCardButtonState();

  Widget listOverlay() {
    return Positioned(
      top: 200,
      child: Container(
        height: 200,
        color: red,
        /*decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),*/
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.1,
      origin: Offset(-1800, -950),
      child: FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.add, size: 40),
      ),
    );
  }
}
