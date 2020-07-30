import 'package:flutter/material.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';

class SideBarUsername extends StatelessWidget {
  const SideBarUsername({
    Key key,
    @required this.mediaQuery,
  }) : super(key: key);

  final Size mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mediaQuery.height * 0.25,
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              //"Hi",
              userBloc.getUserObject() != null
                  ? userBloc.getUserObject().username
                  : "",
              style: TextStyle(color: Colors.black45),
            )
          ],
        ),
      ),
    );
  }
}
