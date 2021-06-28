import 'package:flutter/material.dart';
import 'package:todolist/UI/pages/authenticate/authentication.dart';
import 'package:todolist/UI/pages/authenticate/widgets/textformfield_column.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/main.dart';
import 'package:todolist/models/global.dart';

class SignupPage extends StatefulWidget {
  static const routeName = '/signup';
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _signupFormKey = GlobalKey<FormState>();

  final usernameController = new TextEditingController();
  final passwordController = new TextEditingController();
  final firstnameController = new TextEditingController();
  final lastnameController = new TextEditingController();
  final emailController = new TextEditingController();
  final phoneController = new TextEditingController();

  Widget build(BuildContext context) {
    return AuthenticationView(
      title: "Sign Up",
      form: Form(
        key: _signupFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormFieldColumn(
              label: 'Firstname',
              controller: firstnameController,
              iconData: Icons.person,
              hintText: 'Enter a firstname',
              keyboardType: TextInputType.name,
            ),
            SizedBox(height: 30),
            TextFormFieldColumn(
              label: 'Lastname',
              controller: lastnameController,
              iconData: Icons.person,
              hintText: 'Enter a lastname',
              keyboardType: TextInputType.name,
            ),
            SizedBox(height: 30),
            TextFormFieldColumn(
              label: 'Username',
              controller: usernameController,
              iconData: Icons.account_circle,
              hintText: 'Enter Username',
            ),
            SizedBox(height: 30),
            TextFormFieldColumn(
              label: 'Phone Number',
              controller: phoneController,
              iconData: Icons.phone,
              hintText: 'Enter a phone number',
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 30),
            TextFormFieldColumn(
              label: 'Email Address',
              controller: emailController,
              iconData: Icons.email,
              hintText: 'Enter an email address',
              keyboardType: TextInputType.emailAddress,
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
          ],
        ),
      ),
      onMainButtonTapped: () {
        print('Sign Up!');
        _handleSignUpInput;
      },
      mainButtonTitle: 'Sign Up',
      bottomBtn: _returnToLogin,
    );
  }

  Widget get _returnToLogin {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 0.0),
      child: TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('Back to Sign In', style: labelStyle),
      ),
    );
  }

  get _handleSignUpInput async {
    if (_signupFormKey.currentState!.validate()) {
      _signupFormKey.currentState!.save();
      await _attemptSignUp;
    } else {
      _displayInvalidFormError();
    }
  }

  Future get _attemptSignUp async {
    userBloc
        .registerUser(
            usernameController.text.trim(),
            passwordController.text.trim(),
            emailController.text.trim(),
            firstnameController.text.trim(),
            lastnameController.text.trim(),
            phoneController.text.trim(),
            null)
        .then((_) {
      Navigator.pushNamed(context, Splash.routeName);
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
