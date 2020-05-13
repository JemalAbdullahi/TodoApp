import 'package:flutter/material.dart';

import 'package:todolist/models/global.dart';
//import 'package:todolist/widgets/create_task_overlay.dart';

class TitleCard extends StatelessWidget {
  final String title;
  final VoidCallback addTask;

  TitleCard(this.title, this.addTask);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _TitleCardBackground(),
        _TitleCardTitle(title),
        _TitleCardButton(addTask),
      ],
    );
  }
}

class _TitleCardTitle extends StatelessWidget {
  final String title;
  _TitleCardTitle(this.title);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      height: 53,
      top: 35,
      left: 30,
      child: Text(
        title,
        style: cardTitleStyle,
      ),
    );
  }
}

class _TitleCardBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
    );
  }
}

class _TitleCardButton extends StatefulWidget {
  final VoidCallback addTask;
  

  _TitleCardButton(this.addTask);

  @override
  __TitleCardButtonState createState() => __TitleCardButtonState();
}

class __TitleCardButtonState extends State<_TitleCardButton> {
  Widget listOverlay() {
    print("In listOverlay");
    return Positioned(
      top: 200,
      child: Container(
        height: 200,
        color: red,
        /*decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),*/
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.1,
      origin: Offset(-1800, -950),
      child: FloatingActionButton(
        onPressed: () {
          _addTaskDialog();
          /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateTaskOverlay(),
            ),
          );*/
        },
        child: Icon(Icons.add, size: 40),
      ),
    );
  }

  void _addTaskDialog() {
    TextEditingController _taskNameController = new TextEditingController();
    TextEditingController _groupNameController = new TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: lightBlue,
          content: Container(
            height: 250,
            width: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("Add New Task", style: loginTitleStyle),
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
                      onPressed: (){
                        if(_taskNameController.text != null){
                          widget.addTask(_taskNameController.text, _groupNameController.text);
                          Navigator.pop(context);
                        }
                      },
                    ),
                    SizedBox(width: 8.0),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


}
