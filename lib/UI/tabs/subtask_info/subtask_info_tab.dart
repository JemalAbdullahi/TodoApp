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
  late final double unitHeightValue;
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
    unitHeightValue = MediaQuery.of(context).size.height * 0.01;
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
                  padding: const EdgeInsets.only(
                      top: 26.0, bottom: 20.0, right: 8.0),
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
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
              fontSize: 24,
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
        SizedBox(height: 10.0),
        _notesContainer(),
        SizedBox(height: 20),
        DueDateRow(viewmodel),
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
        controller: notesController..text = viewmodel.note,
        onChanged: (val) {
          viewmodel.note = val;
        },
        keyboardType: TextInputType.multiline,
        maxLines: null,
        minLines: 4,
        decoration: InputDecoration(border: InputBorder.none),
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
            fontSize: 22),
      ),
      SizedBox(width: 15),
      CircleAvatar(
        radius: 16,
        backgroundColor: darkerGreenBlue,
        child: Text(
          "${viewmodel.subtask.assignedTo.length}",
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
          mainAxisSpacing: 10.0,
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
                viewmodel.members[index]
                    .cAvatar(radius: 34, color: darkerGreenBlue),
                Text(
                  viewmodel.members[index].firstname,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontWeight: FontWeight.bold,
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
