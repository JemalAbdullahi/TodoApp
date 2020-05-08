import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/models/authentication/auth_service.dart';
import 'package:todolist/models/global.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback login;
  final bool newUser;

  LoginPage({this.login, this.newUser});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //final _formKey = GlobalKey<FormState>();
  //String _password;
  //String _email;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: loginBlue,
        body: Center(
            child: widget.newUser
                ? getSignup()
                : getSignin(widget, widget.login, context)),
      ),
    );
  }
}

Widget getSignin(LoginPage widget, Function login, BuildContext context) {
  final _formKey = GlobalKey<FormState>();
  String _password;
  String _username;
  return Form(
    key: _formKey,
    child: Stack(
      //margin: EdgeInsets.only(top: 100, bottom: 100, left: 70, right: 70),
      children: <Widget>[
        Column(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome!',
              style: loginTitleStyle,
            ),
            SizedBox(height: 20.0), // <= NEW
            Container(
              width: 300,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    onSaved: (value) => _username = value,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Username',
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.0), // <= NEW
                  TextFormField(
                    onSaved: (value) => _password = value,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Password',
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0), // <= NEW
               
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    "Login",
                    style: loginButtonStyle,
                  ),
                  color: darkBlueGradient,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.blue)),
                  onPressed: () {
                    final form = _formKey.currentState;
                    form.save();
                    if (form.validate()) {
                      Provider.of<AuthService>(context, listen: false)
                          .loginUser(username: _username, password: _password);
                      /*userBloc.signinUser(_username, _password, "").then((_) {
                     login();
                     
                  });*/
                    }
                  },
                ),
              ],
            ),
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Text('Register', style: registerButtonStyle),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.black54)),
                  onPressed: () {
                    getSignup();
                  },
                  color: red,
                ),
              ],
            ),
             ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget getSignup() {
  return Container();
}
/*
appBar: AppBar(
        title: Text("Login Page Flutter Firebase"),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0), // <= NEW
              Text(
                'Login Information',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20.0), // <= NEW
              TextFormField(
                  onSaved: (value) => _email = value,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "Email Address")),
              TextFormField(
                  onSaved: (value) => _password = value,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Password")),
              SizedBox(height: 20.0), // <= NEW
              RaisedButton(
                  child: Text("LOGIN"),
                  onPressed: () {
                    final form = _formKey.currentState;
                    form.save();

                    // Validate will return true if is valid, or false if invalid.
                    if (form.validate()) {
                      print("$_email $_password");
                      Provider.of<AuthService>(context, listen: false).loginUser(username: _email, password: _password);
                    }
                  }),
            ],
          ),
        ),
      ),
*/
