import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:todolist/models/user.dart';
//import 'package:todolist/models/global.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback login;
  final bool newUser;

  const LoginPage({Key key, this.login, this.newUser}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _newUser = false;
  TextEditingController usernameText = new TextEditingController();
  TextEditingController passwordText = new TextEditingController();
  TextEditingController emailText = new TextEditingController();

  @override
  void initState() {
    _newUser = widget.newUser;
    super.initState();
  }

  Widget _buildUsernameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Username', style: labelStyle),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxDecorationStyle,
          height: 60,
          child: TextField(
            controller: usernameText,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.account_circle, color: Colors.white),
              hintText: 'Enter your Username',
              hintStyle: hintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Password', style: labelStyle),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxDecorationStyle,
          height: 60,
          child: TextField(
            controller: passwordText,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.lock, color: Colors.white),
              hintText: 'Enter your Password',
              hintStyle: hintTextStyle,
            ),
            obscureText: true,
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: null,
        padding: EdgeInsets.only(right: 0.0),
        child: Text('Forgot Password?', style: labelStyle),
      ),
    );
  }

  Widget _buildLoginBtn(String btnText) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        autofocus: false,
        onPressed: loginFunc,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Colors.white,
        disabledColor: Colors.white,
        child: Text(
          btnText,
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

  Widget _buildSigningUpBtn(String btnText) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: signupFunc,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Colors.white,
        disabledColor: Colors.white,
        child: Text(
          btnText,
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

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _newUser = true;
        });
        //_newUser = true;
        //build(context);
        print("Sign UP");
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  loginFunc() {
    setState(() {
      if (usernameText.text != "" && passwordText.text != "") {
        userBloc.signinUser(usernameText.text, passwordText.text, "").then((_) {
          print(usernameText.text + " " + passwordText.text);
          widget.login();
        });
      } else
        print("enter name and password");
    });
  }

  signupFunc() {
    if ((usernameText.text != null ||
            passwordText.text != null ||
            emailText.text != null) &&
        (usernameText.text != "" ||
            passwordText.text != "" ||
            emailText.text != "")) {
      print(usernameText.text + passwordText.text + emailText.text);
      userBloc
          .registerUser(usernameText.text, passwordText.text, emailText.text)
          .then((_) {
        widget.login();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: _newUser ? _getSignUpScreen() : _getSigninScreen(),
      ),
    );
  }

  Widget _getSigninScreen() {
    return Stack(
      children: <Widget>[
        Container(
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
        ),
        Container(
          height: double.infinity,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 120),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Sign In',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30.0),
                _buildUsernameTF(),
                SizedBox(height: 30),
                _buildPasswordTF(),
                _buildForgotPasswordBtn(),
                _buildLoginBtn('LOGIN'),
                _buildSignupBtn(),
              ],
            ),
          ),
        )
      ],
    );
  }

//---------------------------------------
  Widget _getSignUpScreen() {
    return Stack(
      children: <Widget>[
        Container(
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
        ),
        Container(
          height: double.infinity,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 120),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Sign Up',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30.0),
                _buildUsernameTF(),
                SizedBox(height: 30),
                _buildPasswordTF(),
                SizedBox(height: 30),
                _buildEmailTF(emailText),
                _buildSigningUpBtn('SIGN UP'),
                _buildBackToSignIn()
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildEmailTF(TextEditingController emailText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Email', style: labelStyle),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxDecorationStyle,
          height: 60,
          child: TextField(
            controller: emailText,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.email, color: Colors.white),
              hintText: 'Enter your Email',
              hintStyle: hintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackToSignIn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () {
          setState(() {
            _newUser = false;
          });
        },
        padding: EdgeInsets.only(right: 0.0),
        child: Text('Back to Sign In', style: labelStyle),
      ),
    );
  }
}

/* C:\Users\Jemal\projects\flutter-app-test\todolist\pubspec.yaml
C:\Users\Jemal\projects\flutter-app-test\todolist\fonts
class _LoginPageState extends State<LoginPage> {
  bool _newUser = false;

  @override
  void initState() {
    _newUser = widget.newUser;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: darkBlue,
      body: Center(
        child: _newUser ? getSignupPage() : getSigninPage(),
      ),
    );
  }

  Widget getSigninPage() {
    TextEditingController usernameText = new TextEditingController();
    TextEditingController passwordText = new TextEditingController();
    return Container(
      margin: EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Welcome!", style: loginTitleStyle),
          Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Theme(
                  data: Theme.of(context)
                      .copyWith(splashColor: Colors.transparent),
                  child: TextField(
                    controller: usernameText,
                    onSubmitted: (value) => print(usernameText.text),
                    autofocus: false,
                    style: TextStyle(fontSize: 22.0, color: Colors.blueGrey),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Username',
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                    ),
                  ),
                ),
                Theme(
                  data: Theme.of(context)
                      .copyWith(splashColor: Colors.transparent),
                  child: TextField(
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    controller: passwordText,
                    autofocus: false,
                    style: TextStyle(fontSize: 22.0, color: Colors.blueGrey),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Password',
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                    ),
                  ),
                ),
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
                    if (usernameText.text != "" &&
                        passwordText.text != "") {
                      userBloc
                          .signinUser(usernameText.text, passwordText.text, "")
                          .then((_) {
                        print(usernameText.text + " " + passwordText.text);
                        widget.login();
                      });
                    }else print("enter name and password");
                  },
                )
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Text(
                  "No Account? No Worries!",
                  style: toDoListSubtitleStyle,
                  textAlign: TextAlign.center,
                ),
                FlatButton(
                  child: Text("Create One", style: registerButtonStyle),
                  onPressed: () {
                    _newUser = true;
                    
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getSignupPage() {
    TextEditingController emailController = new TextEditingController();
    TextEditingController usernameController = new TextEditingController();
    TextEditingController passwordController = new TextEditingController();
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          TextField(
            controller: emailController,
            decoration: InputDecoration(hintText: "Email"),
          ),
          TextField(
            controller: usernameController,
            decoration: InputDecoration(hintText: "Username"),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(hintText: "Password"),
          ),
          FlatButton(
            color: Colors.green,
            child: Text("Sign up for gods sake"),
            onPressed: () {
              if (usernameController.text != null ||
                  passwordController.text != null ||
                  emailController.text != null) {
                userBloc
                    .registerUser(usernameController.text,
                        passwordController.text, emailController.text)
                    .then((_) {
                  widget.login();
                });
              }
            },
          )
        ],
      ),
    );
  }
}
 */
