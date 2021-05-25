import 'package:flutter/material.dart';
import 'package:todolist/UI/title_card.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/widgets/global_widgets/background_color_container.dart';
import 'package:todolist/widgets/group_widgets/group_list_widget.dart';

class ListGroupsTab extends StatefulWidget {
  @override
  _ListGroupsTabState createState() => _ListGroupsTabState();
}

class _ListGroupsTabState extends State<ListGroupsTab> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      BackgroundColorContainer(
        startColor: lightBlue,
        endColor: lightBlueGradient,
        widget: TitleCard(
            title: "Groups",
            child: GroupList(tileNavigatesTo: "ToDoTab", top: 175)),
      )
    ]);
  }
}
