import 'package:flutter/material.dart';
import 'package:todolist/widgets/sidebar_widgets/my_button.dart';

class SideBarButtonList extends StatefulWidget {
  const SideBarButtonList({
    Key key,
    @required this.offset,
    @required this.menuContainerHeight,
  }) : super(key: key);

  final Offset offset;
  final double menuContainerHeight;

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
    print(limits.length);
    setState(() {
      limits = limits;
    });
  }

  double getSize(int x) {
    double size = (widget.offset.dy >= limits[x] &&
            (x == limits.length - 1 || widget.offset.dy < limits[x + 1]))
        ? 25
        : 20;
    return size;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: globalKey,
      width: double.infinity,
      height: widget.menuContainerHeight,
      child: Column(
        children: <Widget>[
          MyButton(
              text: "Profile",
              iconData: Icons.person,
              textSize: getSize(0),
              height: (widget.menuContainerHeight) / 5),
          MyButton(
              text: "How to Use",
              iconData: Icons.info,
              textSize: getSize(1),
              height: (widget.menuContainerHeight) / 5),
          MyButton(
              text: "Credits",
              iconData: Icons.people,
              textSize: getSize(2),
              height: (widget.menuContainerHeight) / 5),
          MyButton(
              text: "Settings",
              iconData: Icons.settings,
              textSize: getSize(3),
              height: (widget.menuContainerHeight) / 5),
          MyButton(
              text: "Logout",
              iconData: Icons.exit_to_app,
              textSize: getSize(4),
              height: (widget.menuContainerHeight) / 5),
        ],
      ),
    );
  }
}
