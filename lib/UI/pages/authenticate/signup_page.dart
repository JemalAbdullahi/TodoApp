import 'package:flutter/material.dart';
import 'package:todolist/UI/pages/authenticate/authentication.dart';
import 'package:todolist/UI/pages/authenticate/widgets/textformfield_column.dart';

import 'package:todolist/models/global.dart';

class SignupPage extends StatefulWidget {
  static const routeName = '/signup';
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _signupFormKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> controllers = {
    "username": new TextEditingController(),
    "password": new TextEditingController(),
    "firstname": new TextEditingController(),
    "lastname": new TextEditingController(),
    "email": new TextEditingController(),
    "phone": new TextEditingController(),
  };

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
              controller: controllers["firstname"]!,
              iconData: Icons.person,
              hintText: 'Enter a firstname',
              keyboardType: TextInputType.name,
            ),
            SizedBox(height: 30),
            TextFormFieldColumn(
              label: 'Lastname',
              controller: controllers["lastname"]!,
              iconData: Icons.person,
              hintText: 'Enter a lastname',
              keyboardType: TextInputType.name,
            ),
            SizedBox(height: 30),
            TextFormFieldColumn(
              label: 'Username',
              controller: controllers["username"]!,
              iconData: Icons.account_circle,
              hintText: 'Enter Username',
            ),
            SizedBox(height: 30),
            TextFormFieldColumn(
              label: 'Phone Number',
              controller: controllers["phone"]!,
              iconData: Icons.phone,
              hintText: 'Enter a phone number',
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 30),
            TextFormFieldColumn(
              label: 'Email Address',
              controller: controllers["email"]!,
              iconData: Icons.email,
              hintText: 'Enter an email address',
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 30),
            TextFormFieldColumn(
              label: 'Password',
              controller: controllers["password"]!,
              iconData: Icons.lock,
              hintText: 'Enter a Password',
              obscureText: true,
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
      ),
      formKey: _signupFormKey,
      controllers: controllers,
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
}
