import 'package:flutter/material.dart';
import 'package:todolist/UI/pages/sidebar_pages/group_page.dart';
import 'package:todolist/UI/pages/sidebar_pages/profile_page.dart';
import 'package:todolist/widgets/sidebar_widgets/my_button.dart';

class SideBarButtonList extends StatefulWidget {
  const SideBarButtonList({
    Key key,
    @required this.offset,
    @required this.menuContainerHeight,
    @required this.logout,
  }) : super(key: key);

  final Offset offset;
  final double menuContainerHeight;
  final VoidCallback logout;

  @override
  _SideBarButtonListState createState() => _SideBarButtonListState();
}

class _SideBarButtonListState extends State<SideBarButtonList> {
  GlobalKey globalKey = GlobalKey();
  List<double> limits = [];

  @override
  void initState() {
    limits = [0, 0, 0, 0, 0];
    WidgetsBinding.instance.addPostFrameCallback(getPosition);
    super.initState();
  }

  getPosition(duration) {
    RenderBox renderBox = globalKey.currentContext.findRenderObject();
    final position = renderBox.localToGlobal(Offset.zero);
    double start = position.dy - 60;
    double contLimit = position.dy + renderBox.size.height - 60;
    double step = (contLimit - start) / 5;
    limits = [];
    for (double x = start; x <= contLimit; x = x + step) {
      limits.add(x);
    }
    //print(limits.length);
    setState(() {
      limits = limits;
    });
  }

  double getSize(int x) {
    double size = (widget.offset.dy >= limits[x] &&
            (x == limits.length - 1 || widget.offset.dy < limits[x + 1]))
        ? 30
        : 25;
    return size;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: globalKey,
      width: double.infinity,
      height: widget.menuContainerHeight,
      padding: EdgeInsets.only(top: widget.menuContainerHeight * 0.1),
      child: Column(
        children: <Widget>[
          MyButton(
            text: "Profile",
            iconData: Icons.person,
            textSize: getSize(0),
            height: (widget.menuContainerHeight) / 4,
            buttonFunction: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              ).then((value) => setState(() {}));
            },
          ),
          /* MyButton(
            text: "Friends",
            iconData: Icons.person,
            textSize: getSize(1),
            height: (widget.menuContainerHeight) / 5,
            buttonFunction: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HowToPage()),
              );
            },
          ), */
          MyButton(
            text: "Groups",
            iconData: Icons.group,
            textSize: getSize(1),
            height: (widget.menuContainerHeight) / 4,
            buttonFunction: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GroupPage()),
              );
            },
          ),
          /* MyButton(
              text: "Settings",
              iconData: Icons.settings,
              textSize: getSize(3),
              height: (widget.menuContainerHeight) / 5), */
          MyButton(
            text: "Logout",
            iconData: Icons.exit_to_app,
            textSize: getSize(2),
            height: (widget.menuContainerHeight) / 4,
            buttonFunction: widget.logout,
          ),
        ],
      ),
    );
  }
}
