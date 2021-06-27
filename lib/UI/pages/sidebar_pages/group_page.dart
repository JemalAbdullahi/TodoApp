import 'package:flutter/material.dart';
import 'package:todolist/UI/pages/sidebar_pages/create_new_group_page.dart';
import 'package:todolist/UI/pages/sidebar_pages/group_info_page.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/widgets/global_widgets/background_color_container.dart';
import 'package:todolist/widgets/global_widgets/custom_appbar.dart';
import 'package:todolist/widgets/group_widgets/group_list_widget.dart';

class GroupPage extends StatefulWidget {
  static const routeName = '/group_page';

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BackgroundColorContainer(
        startColor: lightBlue,
        endColor: lightBlueGradient,
        widget: Scaffold(
          appBar: CustomAppBar("Groups", actions: [
            IconButton(
                icon: Icon(Icons.group_add, color: Colors.black, size: 32.0),
                onPressed: () {
                  Navigator.pushNamed(context, CreateGroupPage.routeName);
                })
          ]),
          backgroundColor: Colors.transparent,
          body: GroupList(tileNavigatesTo: GroupInfoPage.routeName),
        ),
      ),
    );
  }
}
