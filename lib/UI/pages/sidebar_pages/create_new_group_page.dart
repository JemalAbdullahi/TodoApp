import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/widgets/global_widgets/background_color_container.dart';
import 'package:todolist/widgets/global_widgets/custom_appbar.dart';

class CreateGroupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BackgroundColorContainer(
        startColor: lightBlue,
        endColor: lightBlueGradient,
        widget: Scaffold(
          appBar: CustomAppBar(
            "New Group",
            actions: [],
          ),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.only(top: 36.0),
            child: _buildStack(),
          ),
        ),
      ),
    );
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
        _buildGroupNameContainer(),
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
      margin: const EdgeInsets.only(left: 60.0, right: 60.0, bottom: 20.0),
      alignment: Alignment.topCenter,
      child: _buildGroupNameTF(),
    );
  }

  TextField _buildGroupNameTF() {
    return TextField(
      textAlign: TextAlign.center,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        hintText: "Group Name",
        hintStyle: TextStyle(
          fontFamily: 'Segoe UI',
          fontWeight: FontWeight.bold,
          color: darkBlue,
          fontSize: 30,
        ),
      ),
      style: TextStyle(
        fontFamily: 'Segoe UI',
        fontWeight: FontWeight.bold,
        color: darkBlue,
        fontSize: 30,
      ),
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
        children: [_buildMembersLabelRow(), _addMembers()],
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
          "8",
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Segoe UI',
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ),
    ]);
  }

  Align _addMembers() {
    return Align(
      alignment: Alignment(0.9, 0.9),
      child: FloatingActionButton(
        tooltip: "Search to Add Members",
        onPressed: null,
        child: Icon(Icons.arrow_forward, size: 36),
      ),
    );
  }
}
