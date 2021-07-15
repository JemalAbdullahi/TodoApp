import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final IconData iconData;
  final double textSize;
  final double height;
  final VoidCallback buttonFunction;

  MyButton(
      {required this.text,
      required this.iconData,
      required this.textSize,
      required this.height,
      required this.buttonFunction});

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    double unitWidthValue = MediaQuery.of(context).size.width * 0.001;
    return MaterialButton(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(iconData, color: Colors.black45, size: 32 * unitHeightValue),
          SizedBox(width: 10 * unitWidthValue),
          Text(
            text,
            style: TextStyle(
                color: Colors.black45, fontSize: textSize * unitHeightValue),
          )
        ],
      ),
      onPressed: () {
        buttonFunction();
      },
    );
  }
}
