import 'package:flutter/material.dart';
import 'package:todolist/UI/pages/sidebar_pages/add_members.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/group.dart';
import 'package:todolist/models/groupmember.dart';
import 'package:todolist/widgets/global_widgets/background_color_container.dart';
import 'package:todolist/widgets/global_widgets/custom_appbar.dart';

class GroupInfoPage extends StatefulWidget {
  final Group group;

  const GroupInfoPage({Key key, @required this.group}) : super(key: key);

  @override
  _GroupInfoPageState createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int membersLength = 0;
  List<GroupMember> initialMembers;

  @override
  void initState() {
    initialMembers = widget.group.members;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BackgroundColorContainer(
        startColor: lightBlue,
        endColor: lightBlueGradient,
        widget: Scaffold(
          key: _scaffoldKey,
          appBar: CustomAppBar(
            widget.group.name,
            actions: <Widget>[
              TextButton(
                onPressed: updateGroup,
                child: Text(
                  "Update",
                  style: TextStyle(
                      color: Colors.lightBlue,
                      fontFamily: "Segoe UI",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
            fontSize: 24,
          ),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: _buildStack(),
          ),
        ),
      ),
    );
  }

  void updateGroup() async {
    String groupKey = widget.group.groupKey;
    //delete from members
    for (GroupMember member in initialMembers) {
      if (!widget.group.members.contains(member)) {
        //delete memeber from group dbtable
        try {
          await repository.deleteGroupMember(groupKey, member.username);
        } catch (e) {
          print(e.message);
        }
      }
    }
    //add to members
    for (GroupMember member in widget.group.members) {
      if (!initialMembers.contains(member)) {
        try {
          await repository.addGroupMember(groupKey, member.username);
        } catch (e) {
          print(e.message);
        }
      }
    }
  }

  Stack _buildStack() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        _buildColumn(),
      ],
    );
  }

  Column _buildColumn() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildAvatar(),
        SizedBox(height: 10),
        _buildGroupNameContainer(),
        SizedBox(height: 20),
        _buildExpandedCard(),
      ],
    );
  }

  CircleAvatar _buildAvatar() {
    return CircleAvatar(
      radius: 50.0,
      child: Icon(
        Icons.group,
        size: 62.0,
      ),
    );
  }

  Container _buildGroupNameContainer() {
    return Container(
      width: double.infinity,
      alignment: Alignment.topCenter,
      child: Text(
        widget.group.name,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Segoe UI',
          fontWeight: FontWeight.bold,
          color: darkBlue,
          fontSize: 30,
        ),
      ),
    );
  }

  /* TextField _buildGroupNameTF() {
    return TextField(
      textAlign: TextAlign.center,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Group Name",
        hintStyle: TextStyle(
          fontFamily: 'Segoe UI',
          fontWeight: FontWeight.bold,
          color: darkBlue,
          fontSize: 30,
        ),
        suffixIcon: Icon(Icons.edit),
      ),
      style: TextStyle(
        fontFamily: 'Segoe UI',
        fontWeight: FontWeight.bold,
        color: darkBlue,
        fontSize: 30,
      ),
      onSubmitted: (groupName) => newGroup.name = groupName,
    );
  } */

  Expanded _buildExpandedCard() {
    return Expanded(
      child: _buildMembersContainer(),
    );
  }

  Container _buildMembersContainer() {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(left: 24.0, top: 18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(50.0),
        ),
      ),
      child: Stack(
        children: [_buildMembersLabelRow(), _buildMembersList(), _addMembers()],
      ),
    );
  }

  Row _buildMembersLabelRow() {
    return Row(children: [
      Text(
        "MEMBERS",
        style: TextStyle(
            fontFamily: 'Segoe UI',
            fontWeight: FontWeight.bold,
            color: darkBlue,
            fontSize: 22),
      ),
      SizedBox(width: 15),
      CircleAvatar(
        radius: 16,
        backgroundColor: darkBlue,
        child: Text(
          "${widget.group.members.length}",
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Segoe UI',
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ),
      Spacer(),
      Text(
        "Personal",
        style: TextStyle(
            fontFamily: 'Segoe UI',
            fontWeight: FontWeight.bold,
            color: Colors.black54,
            fontSize: 20),
      ),
      Switch(
          value: !widget.group.isPublic,
          onChanged: (newValue) {
            if (!widget.group.isPublic || widget.group.members.length == 1) {
              setState(() {
                print("Switch to ${!newValue}");
                widget.group.isPublic = !newValue;
              });
            }
            if (widget.group.members.length > 1) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Personal Groups are Limited to 1 Member Only"),
                ),
              );
            }
          }),
    ]);
  }

  Padding _buildMembersList() {
    widget.group.addListener(() {
      setState(() {});
    });
    return Padding(
      padding: EdgeInsets.only(top: 44.0, right: 24.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 110,
            childAspectRatio: 0.75,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10.0),
        itemBuilder: (context, index) => Column(
          children: [
            widget.group.members[index].cAvatar(radius: 34),
            Text(
              widget.group.members[index].firstname,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        itemCount: widget.group.members.length,
      ),
    );
  }

  Widget _addMembers() {
    return this.widget.group.isPublic
        ? Align(
            alignment: Alignment(0.9, 0.9),
            child: FloatingActionButton(
              tooltip: "Search to Add Members",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMembersPage(
                      group: widget.group,
                    ),
                  ),
                );
              },
              child: Icon(Icons.arrow_forward, size: 36),
            ),
          )
        : SizedBox.shrink();
  }
}
