import 'package:flutter/material.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/models/user.dart';

class SideBarUsername extends StatefulWidget {
  SideBarUsername({
    Key? key,
    required this.height,
  }) : super(key: key);

  final double height;

  @override
  _SideBarUsernameState createState() => _SideBarUsernameState();
}

class _SideBarUsernameState extends State<SideBarUsername> {
  User _user = userBloc.getUserObject();
  late double height, radius;
  late double unitHeightValue;

  @override
  Widget build(BuildContext context) {
    height = widget.height * 0.6;
    radius = height * 0.3;
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    return Container(
      height: height,
      child: Center(
        child: Column(
          children: <Widget>[
            _user.cAvatar(radius: radius, unitHeightValue: unitHeightValue),
            SizedBox(height: 8.0),
            Text(
              "${_user.firstname} ${_user.lastname}",
              style: TextStyle(
                  color: Colors.black45, fontSize: 18 * unitHeightValue),
            )
          ],
        ),
      ),
    );
  }
}
