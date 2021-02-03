import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  Avatar({Key key, this.imageProvider, this.radius = 16.0}) : super(key: key);

  final ImageProvider imageProvider;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.blue,
      radius: radius,
      backgroundImage: imageProvider,
      
    );
  }
}
