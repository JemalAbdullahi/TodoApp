import 'package:flutter/material.dart';

class BackgroundColorContainer extends StatelessWidget {
  const BackgroundColorContainer({
    Key key,
    @required this.startColor,
    @required this.endColor,
    this.widget,
  }) : super(key: key);

  final Color startColor;
  final Color endColor;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [startColor, endColor],
        ),
      ),
      child: widget,
    );
  }
}
