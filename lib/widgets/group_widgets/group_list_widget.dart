import 'package:flutter/material.dart';
import 'package:todolist/UI/pages/sidebar_pages/group_info_page.dart';
import 'package:todolist/UI/tabs/todo_tab.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/group.dart';
import 'package:todolist/models/groupmember.dart';

class GroupList extends StatefulWidget {
  /// The Page which the list tile will navigate to upon being clicked.
  ///
  /// Available Pages to Navigate To:
  /// * "ToDoTab"
  /// * "GroupInfoPage"
  final String tileNavigatesTo;

  /// The offset from the top.
  final double top;

  /// The offset from the left.
  final double left;

  /// The offset from the right.
  final double right;

  /// The offset from the bottom.
  final double bottom;

  /// Creates a visual Group List.
  GroupList(
      {@required this.tileNavigatesTo,
      this.top = 50,
      this.left = 30,
      this.right = 30,
      this.bottom = 50});

  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  List<Group> groups = groupBloc.getGroupList();

  Size mediaQuery;

  double groupListItemWidth;

  double groupListItemHeight;

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context).size;
    groupListItemWidth = mediaQuery.width * 0.85;
    groupListItemHeight = mediaQuery.height * 0.2;
    return _buildStreamBuilder();
  }

  StreamBuilder<List<Group>> _buildStreamBuilder() {
    return StreamBuilder(
      key: UniqueKey(),
      // Wrap our widget with a StreamBuilder
      stream: groupBloc.getGroups, // pass our Stream getter here
      initialData: groups, // provide an initial data
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            print("No Connection");
            return buildGroupListView();
            break;
          case ConnectionState.waiting:
            if (!snapshot.hasData || snapshot.data.isEmpty) {
              print("Waiting Data");
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              groups = snapshot.data;
              return buildGroupListView();
            }
            break;
          case ConnectionState.active:
            print("Active Data: " + snapshot.data.toString());
            if (snapshot.hasData) {
              groups = snapshot.data;
            }
            return buildGroupListView();
            break;
          case ConnectionState.done:
            print("Done Data: " + snapshot.toString());
            if (snapshot.hasData) {
              groups = snapshot.data;
            }
            return buildGroupListView();
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget buildGroupListView() {
    return ListView.separated(
      padding: EdgeInsets.only(
          top: widget.top,
          left: widget.left,
          right: widget.right,
          bottom: widget.bottom),
      itemCount: groups.length,
      itemBuilder: (BuildContext context, int index) {
        return buildGroupListTile(groups[index]);
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(
        height: 20,
        color: Colors.transparent,
      ),
    );
  }

  Dismissible buildGroupListTile(Group group) {
    group.addListener(() {
      setState(() {});
    });
    return Dismissible(
      key: Key(group.groupKey),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: darkRed,
        child: Icon(Icons.delete, color: lightBlueGradient),
      ),
      onDismissed: (direction) async {
        if (group.members.length == 1) {
          await groupBloc.deleteGroup(group.groupKey);
        } else if (group.members.length > 1) {
          try {
            await repository.deleteGroupMember(
                group.groupKey, userBloc.getUserObject().username);
          } catch (e) {
            print(e.message);
          }
        }
      },
      direction: DismissDirection.endToStart,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) {
              switch (widget.tileNavigatesTo) {
                case "ToDoTab":
                  return ToDoTab(group: group);
                case "GroupInfoPage":
                  return GroupInfoPage(group: group);
                default:
                  return null;
              }
            }),
          );
        },
        child: Container(
          height: groupListItemHeight,
          width: groupListItemWidth,
          decoration: _tileDecoration(),
          child: _buildTilePadding(group),
        ),
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

  ///Tile Padding
  Padding _buildTilePadding(Group group) {
    return Padding(
      padding: EdgeInsets.only(left: 40.0, right: 14),
      child: _tileRow(group),
    );
  }

  ///Tile Row
  Row _tileRow(Group group) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      _groupInfoColumn(group),
      Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
      )
    ]);
  }

  ///Group Info
  Column _groupInfoColumn(Group group) {
    int groupSize = group.members != null ? group.members.length : 0;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildGroupName(group),
          _buildGroupSize(groupSize),
          groupSize > 0
              ? _buildMemberAvatars(group.members)
              : SizedBox.shrink(),
        ]);
  }

  ///Build Group's Size
  Text _buildGroupSize(int groupSize) {
    return Text(
      groupSize == 1 ? "Personal" : "$groupSize People",
      style: TextStyle(fontSize: 20.0, color: Colors.blueGrey),
    );
  }

  ///Build Group's Name
  Text _buildGroupName(Group group) {
    return Text(
      group.name,
      style: TextStyle(
          fontSize: 25.0, fontWeight: FontWeight.bold, color: darkBlueGradient),
    );
  }

  ///Build Member Avatar
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
