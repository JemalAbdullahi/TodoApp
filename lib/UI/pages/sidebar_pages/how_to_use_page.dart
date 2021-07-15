import 'package:flutter/material.dart';
import 'package:todolist/models/global.dart';

// ignore: must_be_immutable
class HowToPage extends StatelessWidget {
  late double unitHeightValue;
  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    return Scaffold(
      backgroundColor: lightBlueGradient,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [lightBlueGradient, lightBlue],
          ),
        ),
        child: RichText(
          text: TextSpan(
            text: 'How to Use:',
            style: cardTitleStyle(unitHeightValue),
            children: <TextSpan>[
              TextSpan(
                text: '\nAdd: ',
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontWeight: FontWeight.bold,
                  color: darkBlueGradient,
                  fontSize: 26 * unitHeightValue,
                ),
              ),
              TextSpan(
                text: '\nClick the large + sign to add a task',
                style: TextStyle(
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                    fontSize: 18 * unitHeightValue,
                    height: 1.8),
              ),
              TextSpan(
                text: '\nDelete:',
                style: TextStyle(
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.bold,
                    color: darkBlueGradient,
                    fontSize: 26 * unitHeightValue),
              ),
              TextSpan(
                text: '\nSwipe Left on a List Item.',
                style: TextStyle(
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                    fontSize: 18 * unitHeightValue,
                    height: 1.8),
              ),
              TextSpan(
                text: '\nUndo Delete: ',
                style: TextStyle(
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.bold,
                    color: darkBlueGradient,
                    fontSize: 26 * unitHeightValue),
              ),
              TextSpan(
                text:
                    '\nSelect "Undo" after deleting an item (Careful, it only appears for a short while at the bottom of the screen!)',
                style: TextStyle(
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                    fontSize: 18 * unitHeightValue,
                    height: 1.8),
              ),
              TextSpan(
                text: '\nComplete: ',
                style: TextStyle(
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.bold,
                    color: darkBlueGradient,
                    fontSize: 26 * unitHeightValue),
              ),
              TextSpan(
                text:
                    '\nClick the empty checkbox within an item, to mark it as complete',
                style: TextStyle(
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                    fontSize: 18 * unitHeightValue,
                    height: 1.8),
              ),
              TextSpan(
                text: '\nSubtasks: ',
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontWeight: FontWeight.bold,
                  color: darkBlueGradient,
                  fontSize: 26 * unitHeightValue,
                ),
              ),
              TextSpan(
                text: '\nClick a task to view it\'s subtasks',
                style: TextStyle(
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                    fontSize: 18 * unitHeightValue,
                    height: 1.8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
