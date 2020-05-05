import 'package:flutter/material.dart';
import 'package:todolist/UI/tasks.dart';

class Board extends StatefulWidget {
  final String startingTask;

  Board(this.startingTask);

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  List<String> _tasks = [];

  @override
  void initState() {
    _tasks.add(widget.startingTask);
    super.initState();
  }
/*
  void _addTasks(String task) {
    setState(() {
      _tasks.add(task);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Tasks(_tasks);
  }
}
