import 'package:flutter/material.dart';
import 'package:todolist/models/global.dart';

// ignore: must_be_immutable
class TitleCard extends StatelessWidget {
  final String title;
  final Widget child;
  late double unitHeightValue;
  late double height;

  TitleCard({required this.title, required this.child});
  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    unitHeightValue = mediaQuery.height * 0.001;
    height = mediaQuery.height * 0.13;
    return Stack(
      children: <Widget>[
        child,
        _titleCardBackground(),
      ],
    );
  }

  Container _titleCardBackground() {
    return Container(
      height: height,
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
        style: cardTitleStyle(unitHeightValue),
      ),
    );
  }
}
