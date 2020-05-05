import 'package:flutter/material.dart';

class CreateListOverlay extends StatelessWidget {

  //CreateListOverlay();
  @override
  Widget build(BuildContext context) {
    print('Create List Overlay Build');
    return Positioned(
      top: 200,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
      ),
    );
  }
}