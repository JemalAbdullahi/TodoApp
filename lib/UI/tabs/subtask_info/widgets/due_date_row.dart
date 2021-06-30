import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist/models/global.dart';

class DueDateRow extends StatelessWidget {

  final viewmodel;

  DueDateRow(this.viewmodel);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
            "Due Date: ${viewmodel.deadline.month}/${viewmodel.deadline.day}/${viewmodel.deadline.year}",
            style: labelStyle),
        SizedBox(width: 5),
        IconButton(
            onPressed: () => _showDatePicker(context),
            icon: Icon(Icons.calendar_today, color: lightBlue))
      ],
    );
  }

  void _showDatePicker(context) {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              height: 200,
              child: CupertinoDatePicker(
                  initialDateTime: viewmodel.deadline,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (date) => viewmodel.deadline = date),
            ),
            // Close the modal
            TextButton(
              child: Text(
                'Done',
                style: TextStyle(
                    color: darkGreenBlue,
                    fontSize: 20,
                    fontFamily: 'Segoe UI',
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      ),
    );
  }
}