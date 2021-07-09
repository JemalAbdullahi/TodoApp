import 'package:flutter/material.dart';
//import 'package:todolist/UI/pages/home_page.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/main.dart';

class AuthenticationView extends StatefulWidget {
  //final _scaffoldKey = GlobalKey<ScaffoldState>();
  final String title;
  final String mainButtonTitle;
  final Widget form;
  final Function? onForgotPasswordTapped;
  final String? validationMessage;
  final Function? onBackPressed;
  final Widget? bottomBtn;
  final Map<String, TextEditingController> controllers;
  final GlobalKey<FormState> formKey;

  const AuthenticationView(
      {required this.title,
      required this.form,
      required this.mainButtonTitle,
      required this.controllers,
      required this.formKey,
      this.validationMessage,
      this.onForgotPasswordTapped,
      this.onBackPressed,
      this.bottomBtn});

  @override
  _AuthenticationViewState createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView> {
  final submitFocusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff5CD6FF),
              Color(0xff57CBF2),
              Color(0xff4EB6D9),
              Color(0xff2F80ED),
            ],
          ),
        ),
        child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 120),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _signText(),
                SizedBox(height: 30),
                widget.form,
                _buildMainBtn(),
                widget.bottomBtn!,
              ],
            )),
      ),
    );
  }

  Text _signText() {
    return Text(
      widget.title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 30.0,
        color: Colors.white,
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildMainBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          padding: EdgeInsets.all(15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          primary: Colors.white,
        ),
        autofocus: false,
        onPressed: () async {
          await _handleInput;
        },
        child: Text(
          widget.mainButtonTitle,
          style: TextStyle(
              color: Color(0xff527daa),
              letterSpacing: 1.5,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 18.0),
        ),
      ),
    );
  }

  Future get _handleInput async {
    if (widget.formKey.currentState!.validate()) {
      widget.formKey.currentState!.save();
      switch (widget.mainButtonTitle) {
        case "Login":
          print("Login");
          await _attemptLogin;
          break;
        case "Sign Up":
          print("Sign Up");
          await _attemptSignUp;
      }
    } else {
      _displayInvalidFormError();
    }
  }

  Future get _attemptLogin async {
    try {
      await userBloc.signinUser(widget.controllers["username"]!.text,
          widget.controllers["password"]!.text, "");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Successful Login",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
        ),
      );
      await groupBloc
          .updateGroups()
          .then((_) => Navigator.pushReplacementNamed(context, "/home"));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future get _attemptSignUp async {
    userBloc
        .registerUser(
            widget.controllers["username"]!.text.trim(),
            widget.controllers["password"]!.text.trim(),
            widget.controllers["email"]!.text.trim(),
            widget.controllers["firstname"]!.text.trim(),
            widget.controllers["lastname"]!.text.trim(),
            widget.controllers["phone"]!.text.trim(),
            null)
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Successful Sign Up",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, Splash.routeName);
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$e"),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  void _displayInvalidFormError() => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fill the Form Completely'),
          backgroundColor: Colors.red,
        ),
      );
}
