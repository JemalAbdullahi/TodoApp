import 'package:flutter/material.dart';
import 'package:todolist/UI/pages/authenticate/authentication.dart';
import 'package:todolist/UI/pages/authenticate/forgot_password_dialog_box.dart';
import 'package:todolist/UI/pages/authenticate/signup_page.dart';
import 'package:todolist/UI/pages/authenticate/widgets/textformfield_column.dart';
import 'package:todolist/UI/pages/home_page.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/models/global.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = new TextEditingController();
  final passwordController = new TextEditingController();
  final _signInFormKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return AuthenticationView(
      title: "Sign In",
      form: Form(
        key: _signInFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormFieldColumn(
              label: 'Username',
              controller: usernameController,
              iconData: Icons.account_circle,
              hintText: 'Enter Username',
            ),
            SizedBox(height: 30),
            TextFormFieldColumn(
              label: 'Password',
              controller: passwordController,
              iconData: Icons.lock,
              hintText: 'Enter a Password',
              obscureText: true,
              textInputAction: TextInputAction.done,
            ),
            _buildForgotPasswordBtn,
          ],
        ),
      ),
      onMainButtonTapped: () {
        print('Login');
        _handleLoginInput;
      },
      mainButtonTitle: 'Login',
      bottomBtn: _signupBtn,
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
        child: Text('Forgot Password?', style: labelStyle),
      ),
    );
  }

  Future get _handleLoginInput async {
    if (_signInFormKey.currentState!.validate()) {
      _signInFormKey.currentState!.save();
      await _attemptLogin;
    } else {
      _displayInvalidFormError();
    }
  }

  Future get _attemptLogin async {
    try {
      await userBloc.signinUser(
          usernameController.text.trim(), passwordController.text.trim(), "");
      await groupBloc.updateGroups();
      Navigator.pushReplacementNamed(context, HomePage.routeName);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _displayInvalidFormError() => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fill the Form Completely'),
          backgroundColor: Colors.red,
        ),
      );
}
