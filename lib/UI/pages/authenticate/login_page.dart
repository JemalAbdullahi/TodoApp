import 'package:flutter/material.dart';
import 'package:todolist/UI/pages/authenticate/authentication.dart';
import 'package:todolist/UI/pages/authenticate/forgot_password_dialog_box.dart';
import 'package:todolist/UI/pages/authenticate/signup_page.dart';
import 'package:todolist/UI/pages/authenticate/widgets/textformfield_column.dart';
import 'package:todolist/models/global.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Map<String, TextEditingController> controllers = {
    "username": new TextEditingController(),
    "password": new TextEditingController(),
  };
  final _signInFormKey = GlobalKey<FormState>();
  late double unitHeightValue;

  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    return AuthenticationView(
      title: "Sign In",
      form: Form(
        key: _signInFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormFieldColumn(
              label: 'Username',
              controller: controllers["username"]!,
              iconData: Icons.account_circle,
              hintText: 'Enter Username',
              unitHeightValue: unitHeightValue,
            ),
            SizedBox(height: 30),
            TextFormFieldColumn(
              label: 'Password',
              controller: controllers["password"]!,
              iconData: Icons.lock,
              hintText: 'Enter a Password',
              obscureText: true,
              textInputAction: TextInputAction.done,
              unitHeightValue: unitHeightValue,
            ),
            _buildForgotPasswordBtn,
          ],
        ),
      ),
      formKey: _signInFormKey,
      mainButtonTitle: 'Login',
      bottomBtn: _signupBtn,
      controllers: controllers,
    );
  }

  Widget get _signupBtn {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        SignupPage.routeName,
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0 * unitHeightValue,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0 * unitHeightValue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _buildForgotPasswordBtn {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 0.0),
      child: TextButton(
        onPressed: () {
          print("Forgot Password");
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return ForgotPasswordDialogBox();
              });
        },
        child: Text('Forgot Password?', style: labelStyle(unitHeightValue)),
      ),
    );
  }
}
