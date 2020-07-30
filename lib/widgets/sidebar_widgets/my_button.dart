import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final IconData iconData;
  final double textSize;
  final double height;

  MyButton({this.text, this.iconData, this.textSize, this.height});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(iconData, color: Colors.black45),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(color: Colors.black45, fontSize: textSize),
          )
        ],
      ),
      onPressed: () {},
    );
  }
}
