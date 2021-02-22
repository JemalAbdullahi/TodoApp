import 'package:flutter/material.dart';
import 'package:todolist/UI/pages/sidebar_pages/create_new_group_page.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/group.dart';
import 'package:todolist/widgets/global_widgets/background_color_container.dart';
import 'package:todolist/widgets/global_widgets/custom_appbar.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({Key key}) : super(key: key);

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  List<Group> groups = [];
  Size mediaQuery;
  double groupListItemWidth;
  double groupListItemHeight;

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context).size;
    groupListItemWidth = mediaQuery.width * 0.8;
    groupListItemHeight = mediaQuery.height * 0.2;
    return SafeArea(
      child: BackgroundColorContainer(
        startColor: lightBlue,
        endColor: lightBlueGradient,
        widget: Scaffold(
          appBar: CustomAppBar(
            "Groups",
            actions: [
              IconButton(
                icon: Icon(
                  Icons.group_add,
                  color: Colors.black,
                  size: 32.0,
                ),
                onPressed: () {
                  print("Create Group Page Push");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateGroupPage(),
                    ),
                  );
                }, //will go to Create a group Page
              )
            ],
          ),
          backgroundColor: Colors.transparent,
          body: StreamBuilder(
            key: UniqueKey(),
            stream: groupBloc.getGroups,
            initialData: groups,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  print("No Connection: " + snapshot.toString());
                  break;
                case ConnectionState.waiting:
                  print("Waiting Data: " + snapshot.toString());
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  groups = snapshot.data;
                  return buildGroupListView();
                  break;
                case ConnectionState.active:
                  print("Active Data: " + snapshot.toString());
                  if (snapshot.hasData) {
                    groups = snapshot.data;
                    return buildGroupListView();
                  }
                  break;
                case ConnectionState.done:
                  print("Done Data: " + snapshot.toString());
                  if (snapshot.hasData) {
                    groups = snapshot.data;
                    return buildGroupListView();
                  }
              }
              return SizedBox();
            },
          ), //buildGroupListView(),
        ),
      ),
    );
  }

  Container buildGroupListTile(int index) {
    return Container(
      height: groupListItemHeight,
      width: groupListItemWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(28),
        ),
        boxShadow: [
          new BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 15.0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 40.0,
          right: 14,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  groups[index].name,
                  style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: darkBlueGradient),
                ),
                Text(
                  "People",
                  style: TextStyle(fontSize: 20.0, color: Colors.blueGrey),
                ),
                CircleAvatar(backgroundColor: Colors.grey, radius: 10.0)
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  Widget buildGroupListView() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
      itemCount: groups.length,
      itemBuilder: (BuildContext context, int index) {
        return buildGroupListTile(index);
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(
        height: 20,
        color: Colors.transparent,
      ),
    );
  }
}
