import 'package:flutter/material.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/models/user.dart';

class SideBarUsername extends StatefulWidget {
  SideBarUsername({
    Key key,
    @required this.mediaQuery,
  }) : super(key: key);

  final Size mediaQuery;

  @override
  _SideBarUsernameState createState() => _SideBarUsernameState();
}

class _SideBarUsernameState extends State<SideBarUsername> {
  User _user = userBloc.getUserObject();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.mediaQuery.height * 0.25,
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              _user != null ? (_user.firstname + " " + _user.lastname) : "",
              style: TextStyle(color: Colors.black45),
            )
          ],
        ),
      ),
    );
  }
}
