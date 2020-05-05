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
        _TitleCardButton(),
        Positioned(
          height: 53,
          top: 35,
          left: 30,
          child: Text(
            title,
            style: cardTitleStyle,
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

class _TitleCardButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Positioned(
      //top: 90,
      child: Transform.scale(
        scale: 1.1,
        origin: Offset(-1800, -950),
        child: FloatingActionButton(
          onPressed: null,
          child: Icon(Icons.add, size: 40),
        ),
      ),
    );
  }
}
