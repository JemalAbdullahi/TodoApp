import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todolist/UI/pages/sidebar_pages/add_members.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/group.dart';
import 'package:todolist/models/groupmember.dart';
import 'package:todolist/widgets/global_widgets/background_color_container.dart';
import 'package:todolist/widgets/global_widgets/custom_appbar.dart';

class CreateGroupPage extends StatefulWidget {
  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  Group newGroup = new Group.blank();
  int membersLength = 0;
  bool isPublic = true;

  @override
  void initState() {
    if (newGroup.members.length == 0) {
      newGroup.addGroupMember(userBloc.getUserObject());
      membersLength = newGroup.members.length;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BackgroundColorContainer(
        startColor: lightBlue,
        endColor: lightBlueGradient,
        widget: Scaffold(
          appBar: CustomAppBar(
            "New Group/Project",
            actions: <Widget>[
              FlatButton(
                textColor: Colors.lightBlue,
                onPressed: saveGroup,
                child: Text("Save",
                    style: TextStyle(
                        fontFamily: "Segoe UI",
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                shape:
                    CircleBorder(side: BorderSide(color: Colors.transparent)),
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

  void saveGroup() async {
    String groupKey = await repository.addGroup(newGroup.name, isPublic);
    for (GroupMember member in newGroup.members) {
      try {
        await repository.addGroupMember(groupKey, member.username);
      } catch (e) {
        print(e.message);
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
      //margin: const EdgeInsets.only(left: 100.0, right: 45.0, bottom: 20.0),
      width: 250,
      padding: EdgeInsets.only(left: 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: darkBlue, borderRadius: BorderRadius.circular(25)),
      child: _buildGroupNameTF(),
    );
  }

  TextField _buildGroupNameTF() {
    return TextField(
      textAlign: TextAlign.center,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Group Name",
        hintStyle: TextStyle(
          fontFamily: 'Segoe UI',
          fontWeight: FontWeight.bold,
          color: lightBlue,
          fontSize: 30,
        ),
        suffixIcon: Icon(
          Icons.edit,
          color: lightBlue,
        ),
        isDense: true,
      ),
      style: TextStyle(
        fontFamily: 'Segoe UI',
        fontWeight: FontWeight.bold,
        color: lightBlue,
        fontSize: 30,
      ),
      onSubmitted: (groupName) => newGroup.name = groupName,
    );
  }

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
          "${newGroup.members.length}",
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
          value: isPublic,
          onChanged: (newValue) {
            setState(() {
              isPublic = newValue;
            });
          }),
    ]);
  }

  Padding _buildMembersList() {
    newGroup.addListener(() {
      setState(() {
        membersLength = newGroup.members.length;
      });
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
            newGroup.members[index].cAvatar(radius: 34),
            Text(
              newGroup.members[index].firstname,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        itemCount: membersLength,
      ),
    );
  }

  Widget _addMembers() {
    return !this.isPublic
        ? Align(
            alignment: Alignment(0.9, 0.9),
            child: FloatingActionButton(
              tooltip: "Search to Add Members",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMembersPage(
                      group: newGroup,
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
