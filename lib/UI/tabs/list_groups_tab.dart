import 'package:flutter/material.dart';
import 'package:todolist/UI/tabs/todo_tab.dart';
import 'package:todolist/UI/title_card.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/widgets/global_widgets/background_color_container.dart';
import 'package:todolist/widgets/group_widgets/group_list_widget.dart';

class ListGroupsTab extends StatelessWidget {
  static const routeName = '/listGroupsTab';

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    double height = mediaQuery.height * 0.17;
    return Stack(children: [
      BackgroundColorContainer(
        startColor: lightBlue,
        endColor: lightBlueGradient,
        widget: TitleCard(
            title: "Groups",
            child: GroupList(tileNavigatesTo: ToDoTab.routeName, top: height)),
      )
    ]);
  }
}
