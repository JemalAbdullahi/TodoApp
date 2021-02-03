import 'package:flutter/material.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/widgets/global_widgets/background_color_container.dart';
import 'package:todolist/widgets/global_widgets/custom_appbar.dart';


class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    double groupListItemWidth = mediaQuery.width * 0.8;
    double groupListItemHeight = mediaQuery.height * 0.15;
    return BackgroundColorContainer(
      startColor: lightBlue,
      endColor: lightBlueGradient,
      widget: Scaffold(
        appBar: CustomAppBar(
          "Groups",
          actions: [
            IconButton(
              icon: Icon(
                Icons.group_add,
                color: Colors.black,
                size: 32.0,
              ),
              onPressed: null, //will go to Create a group Page
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          height: groupListItemHeight,
          width: groupListItemWidth,
          decoration: BoxDecoration(
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
          ),
          child: Padding(
            padding: EdgeInsets.only( left: 40.0,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Group",
                  style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      color: darkBlueGradient),
                ),
                Text("People", style: TextStyle(fontSize: 16.0, color: Colors.blueGrey),),
                CircleAvatar(backgroundColor: Colors.grey, radius: 10.0)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
