import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist/UI/tabs/subtask_info/viewmodel/subtask_view_model.dart';
import 'package:todolist/UI/tabs/subtask_info/widgets/due_date_row.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/groupmember.dart';
import 'package:todolist/models/subtasks.dart';
import 'package:todolist/widgets/global_widgets/background_color_container.dart';
import 'package:todolist/widgets/global_widgets/custom_appbar.dart';

class SubtaskInfo extends StatefulWidget {
  final SubtaskBloc subtaskBloc;
  final Subtask subtask;
  final List<GroupMember> members;

  const SubtaskInfo({
    Key? key,
    required this.subtaskBloc,
    required this.subtask,
    required this.members,
  }) : super(key: key);

  @override
  _SubtaskInfoState createState() => _SubtaskInfoState();
}

class _SubtaskInfoState extends State<SubtaskInfo> {
  late final SubtaskViewModel viewmodel;
  late double unitHeightValue, unitWidthValue;
  TextEditingController notesController = new TextEditingController();
  bool buffering = true;
  bool updating = false;

  @override
  void initState() {
    viewmodel = SubtaskViewModel(
        subtask: widget.subtask,
        subtaskBloc: widget.subtaskBloc,
        members: widget.members);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.001;
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: BackgroundColorContainer(
          startColor: lightGreenBlue,
          endColor: darkGreenBlue,
          widget: Scaffold(
            appBar: CustomAppBar(
              widget.subtask.title,
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: 40.0 * unitHeightValue,
                      bottom: 40.0 * unitHeightValue,
                      right: 8.0 * unitWidthValue),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.white,
                      elevation: 9.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                    onPressed: () {
                      setState(() {
                        updating = true;
                      });
                      viewmodel.note = notesController.text;
                      viewmodel
                          .updateSubtaskInfo()
                          .then((_) => Navigator.pop(context));
                    },
                    child: updating
                        ? _buildProgressIndicator()
                        : Text(
                            "Update",
                            style: TextStyle(
                                color: lightGreenBlue,
                                fontFamily: "Segoe UI",
                                fontSize: 24 * unitHeightValue,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.transparent,
            body: FutureBuilder(
              future: viewmodel.getUsersAssignedtoSubtask(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  buffering = true;
                else
                  buffering = false;
                return _buildBody();
              },
            ),
          ),
        ),
      ),
    );
  }

  Center _buildProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(color: lightGreenBlue),
    );
  }

  Column _buildBody() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _subtaskInfoColumn(),
        ),
        _buildExpandedCard()
      ],
    );
  }

  /// Column containing pertinent Subtask Info
  Column _subtaskInfoColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Notes/Description", style: labelStyle(unitHeightValue)),
        SizedBox(height: 10.0 * unitHeightValue),
        _notesContainer(),
        SizedBox(height: 20 * unitHeightValue),
        DueDateRow(viewmodel),
        SizedBox(height: 15 * unitHeightValue),
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
        controller: notesController..text = viewmodel.note,
        onChanged: (val) {
          viewmodel.note = val;
        },
        keyboardType: TextInputType.multiline,
        maxLines: null,
        minLines: 4,
        decoration: InputDecoration(border: InputBorder.none),
        style: TextStyle(fontSize: 16 * unitHeightValue),
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
        children: [
          _buildMembersLabelRow(),
          buffering ? _buildProgressIndicator() : _buildMembersList(),
        ],
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
            fontSize: 22 * unitHeightValue),
      ),
      SizedBox(width: 15 * unitWidthValue),
      CircleAvatar(
        radius: 20 * unitHeightValue,
        backgroundColor: darkerGreenBlue,
        child: Text(
          "${viewmodel.subtask.assignedTo.length}",
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Segoe UI',
              fontWeight: FontWeight.bold,
              fontSize: 16 * unitHeightValue),
        ),
      ),
    ]);
  }

  Padding _buildMembersList() {
    return Padding(
      padding: EdgeInsets.only(
          top: 75.0 * unitHeightValue, right: 24.0 * unitWidthValue),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200 * unitWidthValue,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10 * unitWidthValue,
          mainAxisSpacing: 10 * unitHeightValue,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              try {
                viewmodel.alreadySelected(index)
                    ? await viewmodel.unassignSubtaskToUser(index)
                    : await viewmodel.assignSubtaskToUser(index);
                setState(() {});
                print(viewmodel.members[index].firstname +
                    " " +
                    viewmodel.members[index].selectedForAssignment.toString());
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("$e"), backgroundColor: Colors.red),
                );
              }
            },
            child: Column(
              children: [
                viewmodel.members[index].cAvatar(
                    radius: 34,
                    color: darkerGreenBlue,
                    unitHeightValue: unitHeightValue),
                Text(
                  viewmodel.members[index].firstname,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontWeight: FontWeight.bold,
                    fontSize: 16 * unitHeightValue,
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: viewmodel.members.length,
      ),
    );
  }
}
