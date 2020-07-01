import 'package:flutter/material.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/widgets/my_button.dart';

class SideBarMenu extends StatefulWidget {
  const SideBarMenu({
    Key key,
    @required this.isMenuOpen,
  }) : super(key: key);

  final bool isMenuOpen;

  @override
  _SideBarMenuState createState() => _SideBarMenuState();
}

class _SideBarMenuState extends State<SideBarMenu> {
  Offset _offset = Offset(0, 0);
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
    double size = (_offset.dy >= limits[x] &&
            (x == limits.length - 1 || _offset.dy < limits[x + 1]))
        ? 25
        : 20;
    return size;
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    double sideBarSize = mediaQuery.width * 0.65;
    double menuContainerHeight = mediaQuery.height / 2;
    return AnimatedPositioned(
      duration: Duration(milliseconds: 2000),
      left: widget.isMenuOpen ? 0 : -sideBarSize,
      top: 0,
      curve: Curves.elasticOut,
      child: SizedBox(
        width: sideBarSize,
        child: GestureDetector(
          onPanUpdate: (details) {
            if (details.localPosition.dx <= sideBarSize) {
              setState(() {
                _offset = details.localPosition;
              });
            }
          },
          onPanEnd: (details) {
            setState(() {
              _offset = Offset(0, 0);
            });
          },
          child: Stack(
            children: <Widget>[
              CustomPaint(
                size: Size(sideBarSize, mediaQuery.height),
                painter: DrawerPainter(offset: _offset),
              ),
              Container(
                height: mediaQuery.height,
                width: sideBarSize,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
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
                    ),
                    Divider(thickness: 1),
                    Container(
                      key: globalKey,
                      width: double.infinity,
                      height: menuContainerHeight,
                      child: Column(
                        children: <Widget>[
                          MyButton(
                              text: "Profile",
                              iconData: Icons.person,
                              textSize: getSize(0),
                              height: (menuContainerHeight) / 5),
                          MyButton(
                              text: "How to Use",
                              iconData: Icons.info,
                              textSize: getSize(1),
                              height: (menuContainerHeight) / 5),
                          MyButton(
                              text: "Credits",
                              iconData: Icons.people,
                              textSize: getSize(2),
                              height: (menuContainerHeight) / 5),
                          MyButton(
                              text: "Settings",
                              iconData: Icons.settings,
                              textSize: getSize(3),
                              height: (menuContainerHeight) / 5),
                          MyButton(
                              text: "Logout",
                              iconData: Icons.exit_to_app,
                              textSize: getSize(4),
                              height: (menuContainerHeight) / 5),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerPainter extends CustomPainter {
  final Offset offset;
  DrawerPainter({this.offset});

  double getControlPointX(double width) {
    if (offset.dx == 0) {
      return width;
    } else {
      return offset.dx > width ? offset.dx : width + 75;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Path path = Path();
    path.moveTo(-size.width, 0);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(
        getControlPointX(size.width), offset.dy, size.width, size.height);
    path.lineTo(-size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
