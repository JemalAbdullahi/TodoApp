import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';

//import 'package:todolist/models/global.dart';

class AddSubtask extends StatefulWidget {
  const AddSubtask({
    Key? key,
    required this.length,
    required this.subtaskBloc,
  }) : super(key: key);

  final int length;
  final SubtaskBloc subtaskBloc;

  @override
  _AddSubtaskState createState() => _AddSubtaskState();
}

class _AddSubtaskState extends State<AddSubtask> {
  TextEditingController controller = new TextEditingController();
  FocusNode textfieldFocus = new FocusNode();
  late double unitValueHeight,
      unitValueWidth,
      height,
      defaultWidth,
      focusWidth,
      marginH;
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
        bottom: 0,
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
                  style: TextStyle(fontSize: 16 * unitValueHeight),
                  onTap: () {
                    setState(() {});
                  },
                  onSubmitted: (_) {
                    setState(() {
                      addSubtask();
                    });
                  },
                  decoration: InputDecoration(
                    suffixIcon: textfieldFocus.hasPrimaryFocus
                        ? IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                addSubtask();
                              });
                            })
                        : SizedBox.shrink(),
                    border: InputBorder.none,
                    hintText: "Write a Subtask",
                    hintStyle: TextStyle(
                        color: Colors.black54, fontSize: 16 * unitValueHeight),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> addSubtask() async {
    if (controller.text.isNotEmpty) {
      String title = controller.text;
      controller.clear();
      textfieldFocus.unfocus();
      await widget.subtaskBloc.addSubtask(title);
    }
  }
}
