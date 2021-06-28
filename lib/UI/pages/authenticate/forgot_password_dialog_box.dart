import 'package:flutter/material.dart';
import 'package:todolist/models/global.dart';

class ForgotPasswordDialogBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Stack contentBox(context) {
    return Stack(
      children: <Widget>[
        _resetPasswordContainer(context),
      ],
    );
  }

  Container _resetPasswordContainer(context) {
    return Container(
      padding: EdgeInsets.only(left: 20.0, top: 10, right: 20, bottom: 10),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff5CD6FF),
              Color(0xff57CBF2),
              Color(0xff4EB6D9),
            ],
          ),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
          ]),
      child: _resetPasswordColumn(context),
    );
  }

  Column _resetPasswordColumn(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _resetPasswordTitle(),
        SizedBox(
          height: 10,
        ),
        _resetPasswordDescription(),
        SizedBox(
          height: 15,
        ),
        _resetPasswordTextFieldColumn(),
        SizedBox(
          height: 10.0,
        ),
        _resetPasswordBtn(context),
      ],
    );
  }

  Align _resetPasswordBtn(context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 15.0),
            elevation: 5.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          onPressed: () {
            print("Reset Password");
            Navigator.of(context).pop();
          },
          child: Text(
            "Reset Password",
            style: TextStyle(
                fontSize: 18,
                color: Color(0xff4EB6D9),
                fontWeight: FontWeight.bold),
          )),
    );
  }

  Column _resetPasswordTextFieldColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Email Address",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Segoe UI')),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Color(0xff4EB6D9),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black87,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 40,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter an Email',
              hintStyle: hintTextStyle,
              prefixIcon: Icon(Icons.person, color: Colors.white),
              contentPadding: EdgeInsets.only(top: 8.0),
            ),
          ),
        )
      ],
    );
  }

  Text _resetPasswordDescription() {
    return Text(
      "Enter your email address below, a link will be sent to reset your password.",
      style: TextStyle(
          fontSize: 14, fontFamily: 'Segoe UI', color: Colors.black54),
      textAlign: TextAlign.center,
    );
  }

  Text _resetPasswordTitle() {
    return Text(
      "Reset Password",
      style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          fontFamily: 'Segoe UI',
          color: Colors.white),
      textAlign: TextAlign.center,
    );
  }
}
