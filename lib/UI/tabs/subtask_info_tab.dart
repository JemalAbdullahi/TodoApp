import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/groupmember.dart';
import 'package:todolist/models/subtasks.dart';
import 'package:todolist/widgets/global_widgets/background_color_container.dart';
import 'package:todolist/widgets/global_widgets/custom_appbar.dart';

class SubtaskInfo extends StatefulWidget {
  final SubtaskBloc subtaskBloc;
  final Subtask subtask;

  const SubtaskInfo({Key key, this.subtaskBloc, this.subtask})
      : super(key: key);

  @override
  _SubtaskInfoState createState() => _SubtaskInfoState();
}

class _SubtaskInfoState extends State<SubtaskInfo> {
  DateTime _chosenDateTime = DateTime.now();
  List<GroupMember> members = [
    GroupMember(
        firstname: "Jemal",
        lastname: "Abdullahi",
        emailaddress: "jebdi12@gmail.com",
        username: "jebdi12",
        phonenumber: "123",
        avatar: null)
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BackgroundColorContainer(
        startColor: lightGreenBlue,
        endColor: darkGreenBlue,
        widget: Scaffold(
          appBar: CustomAppBar(
            widget.subtask.title,
            /* actions: <Widget>[
              TextButton(
                onPressed: updateSubtask,
                child: Text(
                  "Update",
                  style: TextStyle(
                      color: Colors.lightBlue,
                      fontFamily: "Segoe UI",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ], */
            fontSize: 24,
          ),
          backgroundColor: Colors.transparent,
          body: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: _subtaskInfoColumn(context),
              ),
              _buildExpandedCard()
            ],
          ),
        ),
      ),
    );
  }

  /// Column containing pertinent Subtask Info
  Column _subtaskInfoColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Notes/Description", style: labelStyle),
        SizedBox(height: 10.0),
        _notesContainer(),
        SizedBox(height: 20),
        _dueDateRow(context),
        SizedBox(height: 15),
      ],
    );
  }

  /// Container for Notes
  ///
  /// Contains
  /// * Container
  /// * Textfield for editing notes
  Container _notesContainer() {
    return Container(
      height: 150,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        minLines: 4,
        decoration: InputDecoration(border: InputBorder.none),
      ),
    );
  }

  /// Row displaying the due date
  ///
  /// Contains
  /// * Text of the Due Date
  /// * Icon Button to display Calendar
  Row _dueDateRow(BuildContext context) {
    return Row(
      children: [
        Text(
            "Due Date: ${_chosenDateTime.month}/${_chosenDateTime.day}/${_chosenDateTime.year}",
            style: labelStyle),
        SizedBox(width: 5),
        IconButton(
            onPressed: () => _showDatePicker(context),
            icon: Icon(Icons.calendar_today, color: lightBlue))
      ],
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
        children: [_buildMembersLabelRow(), _buildMembersList()],
      ),
    );
  }

  Row _buildMembersLabelRow() {
    return Row(children: [
      Text(
        "Assigned To: (1 or More)",
        style: TextStyle(
            fontFamily: 'Segoe UI',
            fontWeight: FontWeight.bold,
            color: darkerGreenBlue,
            fontSize: 22),
      ),
      SizedBox(width: 15),
      CircleAvatar(
        radius: 16,
        backgroundColor: darkerGreenBlue,
        child: Text(
          "10",
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Segoe UI',
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ),
    ]);
  }

  Padding _buildMembersList() {
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
            members[index].cAvatar(radius: 34, color: darkerGreenBlue),
            Text(
              members[index].firstname,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        itemCount: members.length,
      ),
    );
  }

  void _showDatePicker(context) {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              height: 200,
              child: CupertinoDatePicker(
                  initialDateTime: _chosenDateTime,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (val) {
                    setState(() {
                      _chosenDateTime = val;
                    });
                  }),
            ),
            // Close the modal
            TextButton(
              child: Text(
                'Done',
                style: TextStyle(
                    color: darkGreenBlue,
                    fontSize: 20,
                    fontFamily: 'Segoe UI',
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      ),
    );
  }
}
