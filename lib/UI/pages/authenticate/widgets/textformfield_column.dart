import 'package:flutter/material.dart';
import 'package:todolist/models/global.dart';

class TextFormFieldColumn extends StatelessWidget {
  const TextFormFieldColumn({
    Key? key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    required this.iconData,
    required this.hintText,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
  }) : super(key: key);

  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final IconData iconData;
  final String hintText;
  final bool obscureText;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: labelStyle),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxDecorationStyle,
          height: 60,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            textInputAction: textInputAction,            
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(iconData, color: Colors.white),
              hintText: hintText,
              hintStyle: hintTextStyle,
              errorStyle: TextStyle(fontSize: 14.0),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return '\t\tPlease Enter some text';
              }
              return null;
            },
            obscureText: obscureText,
          ),
        )
      ],
    );
  }
}
