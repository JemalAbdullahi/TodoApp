import 'package:flutter/material.dart';
import 'package:todolist/models/global.dart';

class CreateTaskOverlay extends StatefulWidget {
  @override
  _CreateTaskOverlayState createState() => _CreateTaskOverlayState();
}

class _CreateTaskOverlayState extends State<CreateTaskOverlay> {
  TextEditingController _taskNameController = new TextEditingController();
  TextEditingController _groupNameController = new TextEditingController();
  TextEditingController _notesController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBlue,
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Text("Project", style: cardTitleStyle),
          Container(
            height: 350,
            margin: EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextField(
                  controller: _taskNameController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Project/Task Name',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                  ),
                ),
                TextField(
                  controller: _groupNameController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Group Name',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                  ),
                ),
                TextField(
                  controller: _notesController,
                  showCursor: true,
                  minLines: 10,
                  maxLines: 15,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Notes',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              RaisedButton(
                  child: Text(
                    "Save",
                    style: loginButtonStyle,
                  ),
                  disabledColor: darkBlueGradient,
                  color: lightBlueGradient,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.transparent),
                  ),
                  onPressed: null),
              SizedBox(width: 28.0),
            ],
          ),
        ],
      ),
    );
  }
}
