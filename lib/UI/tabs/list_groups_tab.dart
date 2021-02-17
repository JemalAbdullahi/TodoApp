import 'package:flutter/material.dart';
import 'package:todolist/UI/title_card.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/group.dart';
import 'package:todolist/widgets/global_widgets/background_color_container.dart';

class ListGroupsTab extends StatefulWidget {
  final GroupBloc groupBloc;
  final Repository repository;

  const ListGroupsTab({Key key, this.groupBloc, this.repository})
      : super(key: key);

  @override
  _ListGroupsTabState createState() => _ListGroupsTabState();
}

class _ListGroupsTabState extends State<ListGroupsTab> {
  List<Group> groups = [];
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundColorContainer(
          startColor: lightBlue,
          endColor: lightBlueGradient,
          //widget: TitleCard("To Do: Groups"),
        ),
        StreamBuilder(
          key: UniqueKey(),
          // Wrap our widget with a StreamBuilder
          stream: widget.groupBloc.getGroups, // pass our Stream getter here
          initialData: groups, // provide an initial data
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                print("None Data: " + snapshot.toString());
                break;
              case ConnectionState.waiting:
                print("Waiting Data: " + snapshot.toString());
                if (!snapshot.data.isEmpty) {
                  groups = snapshot.data;
                  return buildGroupContainer();
                }
                break;
              case ConnectionState.active:
                if (!snapshot.data.isEmpty) {
                  groups = snapshot.data;
                  return buildGroupContainer();
                }
                break;
              case ConnectionState.done:
                if (!snapshot.data.isEmpty) {
                  groups = snapshot.data;
                  return buildGroupContainer();
                }
                break;
            }
            return SizedBox.shrink();
          },
        ),
        TitleCard("To Do: Groups")
      ],
    );
  }

  Center buildGroupContainer() {
    return Center(
      child: Container(
        height: 150,
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 32.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 100,
                width: 5,
                margin: EdgeInsets.only(right: 8.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(groups[0].name,
                      style: TextStyle(
                          color: darkBlue,
                          fontSize: 24.0,
                          fontFamily: "Segoe UI",
                          fontWeight: FontWeight.bold)),
                  Text(
                    "2 People",
                    style: TextStyle(color: Colors.grey, fontSize: 20.0),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        minRadius: 8.0,
                        maxRadius: 15.0,
                      ),
                      CircleAvatar(
                        minRadius: 8.0,
                        maxRadius: 15.0,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(width: 40),
              Icon(Icons.chevron_right, size: 36.0)
            ],
          ),
        ),
      ),
    );
  }
}
