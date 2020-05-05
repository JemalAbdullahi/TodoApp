import 'package:flutter/material.dart';

class Tasks extends StatelessWidget {
  final List<String> tasks;

  Tasks([this.tasks = const [] ]);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(tasks[index]),
          );
        });
  }
}