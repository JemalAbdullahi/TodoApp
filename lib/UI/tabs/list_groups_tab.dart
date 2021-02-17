import 'package:flutter/material.dart';
import 'package:todolist/UI/title_card.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/group.dart';
import 'package:todolist/models/groupmember.dart';
import 'package:todolist/widgets/global_widgets/background_color_container.dart';

class ListGroupsTab extends StatefulWidget {
  @override
  _ListGroupsTabState createState() => _ListGroupsTabState();
}

class _ListGroupsTabState extends State<ListGroupsTab> {
  List<Group> groups = [];
  Size mediaQuery;
  double groupListItemWidth;
  double groupListItemHeight;

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context).size;
    groupListItemWidth = mediaQuery.width * 0.8;
    groupListItemHeight = mediaQuery.height * 0.2;
    return Stack(
      children: [
        BackgroundColorContainer(
          startColor: lightBlue,
          endColor: lightBlueGradient,
          widget: TitleCard("To Do: Groups"),
        ),
        StreamBuilder(
          key: UniqueKey(),
          // Wrap our widget with a StreamBuilder
          stream: groupBloc.getGroups, // pass our Stream getter here
          initialData: groups, // provide an initial data
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                print("No Connection: " + snapshot.toString());
                break;
              case ConnectionState.waiting:
                print("Waiting Data: " + snapshot.toString());
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                //groups = snapshot.data;
                //return buildGroupListView();
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
            return SizedBox.shrink();
          },
        ),
        //TitleCard("To Do: Groups")
      ],
    );
  }

  Widget buildGroupListView() {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 175, left: 30, right: 30, bottom: 50),
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

  Container buildGroupListTile(int index) {
    return Container(
      height: groupListItemHeight,
      width: groupListItemWidth,
      decoration: _tileDecoration(),
      child: _buildTilePadding(index),
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
      ],
    );
  }

  Padding _buildTilePadding(int index) {
    return Padding(
      padding: EdgeInsets.only(left: 40.0, right: 14),
      child: _tileRow(index),
    );
  }

  Row _tileRow(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _groupInfoColumn(index),
        Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
        )
      ],
    );
  }

  Column _groupInfoColumn(int index) {
    int groupSize =
        groups[index].members != null ? groups[index].members.length : 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          groups[index].name,
          style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: darkBlueGradient),
        ),
        Text(
          groupSize == 1 ? "$groupSize Person" : "$groupSize People",
          style: TextStyle(fontSize: 20.0, color: Colors.blueGrey),
        ),
        SizedBox(
          height: 8.0,
        ),
        groupSize > 0
            ? _buildMemberAvatars(groups[index].members)
            : SizedBox.shrink(),
      ],
    );
  }

  Row _buildMemberAvatars(List<GroupMember> members) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (GroupMember member in members)
          Padding(
            padding: EdgeInsets.only(right: 2.0),
            child: CircleAvatar(
              backgroundImage: member.avatar,
              backgroundColor: Colors.grey,
              radius: 12.0,
            ),
          ),
      ],
    );
  }
}
