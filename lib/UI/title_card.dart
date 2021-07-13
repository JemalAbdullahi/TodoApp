import 'package:flutter/material.dart';
import 'package:todolist/models/global.dart';

class TitleCard extends StatelessWidget {
  final String title;
  final Widget child;
  late final double unitHeightValue;
  late final double height;

  TitleCard({required this.title, required this.child});
  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    unitHeightValue = mediaQuery.height * 0.01;
    height = unitHeightValue * 13;
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
          bottomLeft: Radius.circular(40*unitHeightValue),
          bottomRight: Radius.circular(40*unitHeightValue),
        ),
        boxShadow: [
          new BoxShadow(
            color: Colors.black.withOpacity(0.7),
            blurRadius: 25.0*unitHeightValue,
          ),
        ],
      ),
      child: _titleCardTitle(),
      padding: EdgeInsets.only(bottom: 20*unitHeightValue, left: 15.0*unitHeightValue),
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
