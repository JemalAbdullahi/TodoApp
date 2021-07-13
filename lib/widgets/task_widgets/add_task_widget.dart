import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';

class AddTask extends StatefulWidget {
  const AddTask({
    Key? key,
    required this.length,
    required this.taskbloc,
  }) : super(key: key);

  final int length;
  final TaskBloc taskbloc;

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController controller = new TextEditingController();
  FocusNode textfieldFocus = new FocusNode();

  double bottom = 0;
  late double unitValueHeight, unitValueWidth, height, defaultWidth, focusWidth, marginH;
  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    unitValueHeight = size.height * 0.001;
    unitValueWidth = size.width * 0.001;
    focusWidth = unitValueWidth * 900;
    defaultWidth = unitValueWidth * 250;
    height = unitValueHeight * 60;
    double width = (textfieldFocus.hasPrimaryFocus) ? focusWidth : defaultWidth;
    marginH = (size.width - width) / 2;
    return Consumer<ScreenHeight>(builder: (context, _res, child) {
      return Positioned(
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
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  focusNode: textfieldFocus,
                  controller: controller,
                  textAlign: TextAlign.left,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.go,
                  onTap: () {
                    if (width != focusWidth) {
                      setState(() {
                        width = focusWidth;
                      });
                    }
                  },
                  onSubmitted: (_) {
                    setState(() {
                      addTask();
                    });
                  },
                  decoration: InputDecoration(
                    suffixIcon: textfieldFocus.hasPrimaryFocus
                        ? IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                addTask();
                              });
                            })
                        : SizedBox.shrink(),
                    //contentPadding: EdgeInsets.only(left: 12.0,),
                    border: InputBorder.none,
                    hintText: "Write a Task",
                    hintStyle: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void addTask() async {
    if (controller.text.isNotEmpty) {
      String title = controller.text;
      controller.clear();
      textfieldFocus.unfocus();
      await widget.taskbloc.addTask(title);
      //widget.taskbloc.updateTasks();
    }
  }
}
