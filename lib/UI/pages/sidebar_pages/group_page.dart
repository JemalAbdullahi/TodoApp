import 'package:flutter/material.dart';
import 'package:todolist/UI/pages/sidebar_pages/create_new_group_page.dart';
import 'package:todolist/UI/pages/sidebar_pages/group_info_page.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/group.dart';
import 'package:todolist/models/groupmember.dart';
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
                  //print("No Connection: " + snapshot.toString());
                  break;
                case ConnectionState.waiting:
                  //print("Waiting Data: " + snapshot.toString());
                  if (!snapshot.hasData  || snapshot.data.isEmpty)
                    return Center(child: CircularProgressIndicator());
                  break;
                case ConnectionState.active:
                  //print("Active Data: " + snapshot.toString());
                  if (snapshot.hasData) {
                    groups = snapshot.data;
                    return buildGroupListView();
                  }
                  break;
                case ConnectionState.done:
                  //print("Done Data: " + snapshot.toString());
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

  GestureDetector buildGroupListTile(int index) {
    groups[index].addListener(() {
      setState(() {});
    });
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) {
            return GroupInfoPage(group: groups[index]);
          }),
        );
      },
      child: Container(
        height: groupListItemHeight,
        width: groupListItemWidth,
        decoration: _tileDecoration(),
        child: _buildTilePadding(index),
      ),
    );
  }

  BoxDecoration _tileDecoration() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(28),
        ),
        boxShadow: [
          new BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 15.0,
          ),
        ]);
  }

  //Tile Padding
  Padding _buildTilePadding(int index) {
    return Padding(
      padding: EdgeInsets.only(left: 40.0, right: 14),
      child: _tileRow(index),
    );
  }

  //Tile Row
  Row _tileRow(int index) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      _groupInfoColumn(index),
      Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
      )
    ]);
  }

  //Group Info
  Column _groupInfoColumn(int index) {
    int groupSize =
        groups[index].members != null ? groups[index].members.length : 0;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildGroupName(index),
          _buildGroupSize(groupSize),
          groupSize > 0
              ? _buildMemberAvatars(groups[index].members)
              : SizedBox.shrink(),
        ]);
  }

  //Build Group's Size
  Text _buildGroupSize(int groupSize) {
    return Text(
      groupSize == 1 ? "Personal" : "$groupSize People",
      style: TextStyle(fontSize: 20.0, color: Colors.blueGrey),
    );
  }

  //Build Group's Name
  Text _buildGroupName(int index) {
    return Text(
      groups[index].name,
      style: TextStyle(
          fontSize: 25.0, fontWeight: FontWeight.bold, color: darkBlueGradient),
    );
  }

  //Build Member Avatar
  Row _buildMemberAvatars(List<GroupMember> members) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      for (GroupMember member in members)
        Padding(
          padding: EdgeInsets.only(top: 8.0, right: 2.0),
          child: member.cAvatar(),
        ),
    ]);
  }
}
