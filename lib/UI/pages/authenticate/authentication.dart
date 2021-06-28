import 'package:flutter/material.dart';

class AuthenticationView extends StatefulWidget {
  //final _scaffoldKey = GlobalKey<ScaffoldState>();
  final String title;
  final String mainButtonTitle;
  final Widget form;
  final Function onMainButtonTapped;
  final Function? onForgotPasswordTapped;
  final String? validationMessage;
  final Function? onBackPressed;
  final Widget? bottomBtn;

  const AuthenticationView(
      {required this.title,
      required this.form,
      required this.onMainButtonTapped,
      required this.mainButtonTitle,
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
        onPressed: () {
          //print("Login");
          widget.onMainButtonTapped();
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
}
