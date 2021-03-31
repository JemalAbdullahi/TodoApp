import 'package:flutter/material.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/models/user.dart';

class SideBarUsername extends StatefulWidget {
  SideBarUsername({
    Key key,
    @required this.height,
  }) : super(key: key);

  final double height;

  @override
  _SideBarUsernameState createState() => _SideBarUsernameState();
}

class _SideBarUsernameState extends State<SideBarUsername> {
  User _user;
  double height, radius;

  @override
  Widget build(BuildContext context) {
    _user = userBloc.getUserObject();
    height = widget.height * 0.6;
    radius = height * 0.4;
    return _user != null
        ? Container(
            height: height,
            child: Center(
              child: Column(
                children: <Widget>[
                  _user.cAvatar(radius: radius),
                  SizedBox(height: 8.0),
                  Text(
                    "${_user.firstname} ${_user.lastname}",
                    style: TextStyle(color: Colors.black45),
                  )
                ],
              ),
            ),
          )
        : SizedBox.shrink();
  }
}
