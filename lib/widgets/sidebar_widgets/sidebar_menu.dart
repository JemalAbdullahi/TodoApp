import 'package:flutter/material.dart';
import 'package:todolist/widgets/sidebar_widgets/sidebar_button_list.dart';
import 'package:todolist/widgets/sidebar_widgets/sidebar_username.dart';

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
                    SideBarUsername(mediaQuery: mediaQuery),
                    Divider(thickness: 1),
                    SideBarButtonList(
                        offset: _offset,
                        menuContainerHeight: menuContainerHeight),
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
