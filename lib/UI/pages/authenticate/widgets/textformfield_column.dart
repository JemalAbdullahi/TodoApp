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
    required this.unitHeightValue,
  }) : super(key: key);

  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final IconData iconData;
  final String hintText;
  final bool obscureText;
  final TextInputAction textInputAction;
  final double unitHeightValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: labelStyle(unitHeightValue)),
        SizedBox(height: 10 * unitHeightValue),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxDecorationStyle(),
          height: 60 * unitHeightValue,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            style:
                TextStyle(color: Colors.white, fontSize: 16 * unitHeightValue),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(iconData,
                  color: Colors.white, size: 24 * unitHeightValue),
              hintText: hintText,
              hintStyle: hintTextStyle(unitHeightValue),
              errorStyle: TextStyle(fontSize: 14.0 * unitHeightValue),
            ),
            validator: (value) {
              return (value != null && value.isEmpty)
                  ? 'Fill the Form Completely.'
                  : null;
            },
            obscureText: obscureText,
          ),
        )
      ],
    );
  }
}
