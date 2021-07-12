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

  double height = 60.0;
  double width = 250.0;
  double bottom = 0;
  late double focusWidth, marginH;
  late Size size;

  FocusNode textfieldFocus = new FocusNode();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    focusWidth = size.width * 0.9;
    width = (textfieldFocus.hasPrimaryFocus) ? focusWidth : 250;
    marginH = (size.width - width) / 2;
    return Consumer<ScreenHeight>(builder: (context, _res, child) {
      //bottom = (isFocused && !_res.isOpen) ? 100 : 0;
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

  Future<void> addSubtask() async {
    if (controller.text.isNotEmpty) {
      String title = controller.text;
      controller.clear();
      textfieldFocus.unfocus();
      await widget.subtaskBloc.addSubtask(title);
    }
  }
}
