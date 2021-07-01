import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:todolist/models/global.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;
  final List<Widget> actions;
  final double fontSize;
  final Widget? leading;

  CustomAppBar(
    this.title, {
    Key? key,
    this.actions = const [],
    this.leading,
    this.fontSize = 32.0,
  })  : preferredSize = Size.fromHeight(100.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: "Segoe UI",
          fontSize: fontSize,
        ),
      ),
      leading: leading,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0.0,
      toolbarHeight: 100.0,
      actions: actions,
      iconTheme: IconThemeData(color: Colors.black, size: 32.0, opacity: 1.0),
      automaticallyImplyLeading: true,
    );
  }
}
