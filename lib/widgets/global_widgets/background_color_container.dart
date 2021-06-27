import 'package:flutter/material.dart';

class BackgroundColorContainer extends StatelessWidget {
  const BackgroundColorContainer({
    Key? key,
    required this.startColor,
    required this.endColor,
    required this.widget,
  }) : super(key: key);

  final Color startColor;
  final Color endColor;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
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
