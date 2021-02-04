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
  TextEditingController firstnameText = new TextEditingController();
  TextEditingController lastnameText = new TextEditingController();
  TextEditingController phonenumberText = new TextEditingController();

  @override
  void initState() {
    _newUser = widget.newUser;
    super.initState();
  }

/*   Widget _buildUsernameTF() {
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
  } */
  Widget _buildTF(
      String label,
      TextEditingController controller,
      TextInputType keyboardType,
      IconData iconData,
      String hintText,
      bool obscureText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: labelStyle),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxDecorationStyle,
          height: 60,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(iconData, color: Colors.white),
              hintText: hintText,
              hintStyle: hintTextStyle,
            ),
            obscureText: obscureText,
          ),
        ),
      ],
    );
  }

/*   Widget _buildPasswordTF() {
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
 */
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
      if (usernameText.text.isNotEmpty && passwordText.text.isNotEmpty) {
        userBloc
            .signinUser(usernameText.text.trim(), passwordText.text.trim(), "")
            .then((_) {
          widget.login();
        });
      } else
        print("enter name and password");
    });
  }

  signupFunc() {
    if (usernameText.text.isNotEmpty &&
        passwordText.text.isNotEmpty &&
        emailText.text.isNotEmpty) {
      print(usernameText.text + passwordText.text + emailText.text);
      userBloc
          .registerUser(
              usernameText.text.trim(),
              passwordText.text.trim(),
              emailText.text.trim(),
              firstnameText.text.trim(),
              lastnameText.text.trim(),
              phonenumberText.text.trim(),
              null)
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
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          List: [
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
            _buildTF('Username', usernameText, TextInputType.text,
                Icons.account_circle, 'Enter Username', false),
            SizedBox(height: 30),
            _buildTF('Password', passwordText, TextInputType.text, Icons.lock,
                'Enter a Password', true),
            _buildForgotPasswordBtn(),
            _buildLoginBtn('LOGIN'),
            _buildSignupBtn(),
          ],
        ),
      ),
    );
  }

//---------------------------------------
  Widget _getSignUpScreen() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          List: [
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
            _buildTF('Firstname', firstnameText, TextInputType.name,
                Icons.person, 'Enter a Firstname', false),
            SizedBox(height: 30.0),
            _buildTF('Lastname', lastnameText, TextInputType.name, Icons.person,
                'Enter a Lastname', false),
            SizedBox(height: 30.0),
            _buildTF('Username', usernameText, TextInputType.text,
                Icons.account_circle, 'Enter a Username', false),
            SizedBox(height: 30),
            _buildTF('Phone Number', phonenumberText, TextInputType.phone,
                Icons.phone, 'Enter a Phone Number', false),
            SizedBox(height: 30),
            _buildTF('Email', emailText, TextInputType.emailAddress,
                Icons.email, 'Enter an Email', false),
            SizedBox(height: 30),
            _buildTF('Password', passwordText, TextInputType.text, Icons.lock,
                'Enter a Password', true),
            _buildSigningUpBtn('SIGN UP'),
            _buildBackToSignIn()
          ],
        ),
      ),
    );
  }

  /* Widget _buildEmailTF(TextEditingController emailText) {
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
  } */

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
