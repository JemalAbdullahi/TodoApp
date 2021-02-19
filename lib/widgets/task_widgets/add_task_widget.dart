import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';

import 'dropdown.dart';
//import 'package:todolist/models/global.dart';

class AddTask extends StatefulWidget {
  const AddTask(
      {Key key,
      @required this.length,
      @required this.taskbloc,
      @required this.groupKey})
      : super(key: key);

  final int length;
  final String groupKey;
  final TaskBloc taskbloc;

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  //GlobalKey<_CustomDropdownState> _keyCustomDropdown = GlobalKey();
  TextEditingController controller = new TextEditingController();

  double height = 60.0;
  double width = 250.0;
  double bottom = 0;
  double focusWidth, marginH;
  Size size;
  bool isFocused = false;
  bool _isDropdownOpen = false;

  _selectGroupTapFormat(bool dropdownBool) {
    setState(() {
      _isDropdownOpen = dropdownBool;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    focusWidth = size.width * 0.9;
    width = (isFocused) ? focusWidth : 250;
    bottom = (!isFocused && _isDropdownOpen) ? 230 : 0;
    marginH = (size.width - width) / 2;
    return Consumer<ScreenHeight>(builder: (context, _res, child) {
      //bottom = (isFocused && !_res.isOpen) ? 100 : 0;
      return CustomDropdown(
        parentAction: _selectGroupTapFormat,
        child: Positioned(
          bottom: bottom,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: marginH, vertical: 25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            height: height,
            width: width,
            padding: EdgeInsets.all(12.0),
            child: Focus(
              onFocusChange: (focus) {
                setState(() {
                  isFocused = focus;
                  //if (isFocused) _keyCustomDropdown.currentState.closeCustomDropdown();
                });
              },
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: controller,
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.go,
                      onSubmitted: (_) {
                        setState(() {
                          addTask();
                        });
                      },
                      decoration: InputDecoration(
                        suffixIcon: isFocused
                            ? IconButton(
                                icon: Icon(Icons.add), onPressed: addTask)
                            : SizedBox.shrink(),
                        //contentPadding: EdgeInsets.only(left: 12.0,),
                        border: InputBorder.none,
                        hintText: "Write a Task",
                        hintStyle: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                  //DropDownViewController()
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void addTask() async {
    await widget.taskbloc.addTask(controller.text, widget.length, false);
    controller.clear();
  }
}