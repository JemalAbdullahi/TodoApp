import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist/models/global.dart';

class DueDateRow extends StatefulWidget {
  final viewmodel;

  DueDateRow(this.viewmodel);

  @override
  _DueDateRowState createState() => _DueDateRowState();
}

class _DueDateRowState extends State<DueDateRow> {
  late double unitHeightValue, unitWidthValue;

  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.001;
    return Row(
      children: [
        Text(
          "Due Date: ${widget.viewmodel.deadline.month}/${widget.viewmodel.deadline.day}/${widget.viewmodel.deadline.year}",
          style: labelStyle(unitHeightValue),
        ),
        SizedBox(width: 5 * unitWidthValue),
        IconButton(
            onPressed: () => _showDatePicker(context),
            icon: Icon(Icons.calendar_today,
                color: lightBlue, size: 20 * unitHeightValue))
      ],
    );
  }

  void _showDatePicker(context) {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250 * unitHeightValue,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              height: 200 * unitHeightValue,
              child: CupertinoDatePicker(
                  initialDateTime: widget.viewmodel.deadline,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (date) =>
                      widget.viewmodel.deadline = date),
            ),
            // Close the modal
            TextButton(
              child: Text(
                'Done',
                style: TextStyle(
                    color: darkGreenBlue,
                    fontSize: 20 * unitHeightValue,
                    fontFamily: 'Segoe UI',
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {});
              },
            )
          ],
        ),
      ),
    );
  }
}
