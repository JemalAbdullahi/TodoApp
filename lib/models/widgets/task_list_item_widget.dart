import 'package:flutter/material.dart';

import '../global.dart';

class TaskListItemWidget extends StatelessWidget {
  final String title;
  final String keyValue;

  TaskListItemWidget({this.title, this.keyValue});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: ListTile(
        leading: Checkbox(value: false, onChanged: null),
        title: Text(title, style: toDoListTileStyle),
        subtitle: Text(
          'keyValue',
          style: toDoListSubtitleStyle,
          textAlign: TextAlign.right,
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          new BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 25.0,
          ),
        ],
        color: darkBlue,
      ),
    );
  }
}
