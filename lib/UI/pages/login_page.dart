import 'package:flutter/material.dart';
import 'package:todolist/UI/pages/home_page.dart';
//import 'package:flutter/services.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/widgets/forgot_password_dialog_box.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _newUser = false;
  final _signInFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();
  //final _forgotPasswordFormKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController usernameText = new TextEditingController();
  final _userFocusNode = new FocusNode();
  TextEditingController passwordText = new TextEditingController();
  final _passwordFocusNode = new FocusNode();
  TextEditingController emailText = new TextEditingController();
  final _emailFocusNode = new FocusNode();
  TextEditingController firstnameText = new TextEditingController();
  final _firstnameFocusNode = new FocusNode();
  TextEditingController lastnameText = new TextEditingController();
  final _lastnameFocusNode = new FocusNode();
  TextEditingController phonenumberText = new TextEditingController();
  final _phoneFocusNode = new FocusNode();
  final _loginFocusNode = new FocusNode();
  final _signupFocusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _newUser ? _getSignUpScreen : _getSigninScreen,
    );
  }

  Widget _buildTF(
      String label,
      TextEditingController controller,
      TextInputType keyboardType,
      IconData iconData,
      String hintText,
      bool obscureText,
      TextInputAction textInputAction,
      FocusNode currentFocusNode,
      FocusNode nextFocusNode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _label(label),
        SizedBox(height: 10),
        _buildContainer(controller, keyboardType, iconData, hintText,
            obscureText, textInputAction, currentFocusNode, nextFocusNode)
      ],
    );
  }

  Text _label(String label) => Text(label, style: labelStyle);

  Container _buildContainer(
      TextEditingController controller,
      TextInputType keyboardType,
      IconData iconData,
      String hintText,
      bool obscureText,
      TextInputAction textInputAction,
      FocusNode currentFocusNode,
      FocusNode nextFocusNode) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: boxDecorationStyle,
      height: 60,
      child: _buildTextFormField(controller, keyboardType, iconData, hintText,
          obscureText, textInputAction, currentFocusNode, nextFocusNode),
    );
  }

  TextFormField _buildTextFormField(
      TextEditingController controller,
      TextInputType keyboardType,
      IconData iconData,
      String hintText,
      bool obscureText,
      TextInputAction textInputAction,
      FocusNode currentFocusNode,
      FocusNode nextFocusNode) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      focusNode: currentFocusNode,
      onFieldSubmitted: (value) {
        _fieldFocusChange(context, currentFocusNode, nextFocusNode);
      },
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(top: 14.0),
        prefixIcon: Icon(iconData, color: Colors.white),
        hintText: hintText,
        hintStyle: hintTextStyle,
        errorStyle: TextStyle(fontSize: 14.0),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return '\t\tPlease Enter some text';
        }
        return null;
      },
      obscureText: obscureText,
    );
  }

  Future<void> _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) async {
    currentFocus.unfocus();
    if (nextFocus == _loginFocusNode) {
      await _handleLoginInput;
    } else if (nextFocus == _signupFocusNode) {
      await _handleSignUpInput;
    } else
      FocusScope.of(context).requestFocus(nextFocus);
  }

  Widget get _buildForgotPasswordBtn {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 0.0),
      child: TextButton(
        onPressed: () {
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

  Widget _buildLoginBtn(String btnText) {
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
          await _handleLoginInput;
        },
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

  Future get _handleLoginInput async {
    if (_signInFormKey.currentState!.validate()) {
      await _attemptLogin;
    } else {
      _displayInvalidFormError();
    }
  }

  Future get _attemptLogin async {
    try {
      await userBloc.signinUser(
          usernameText.text.trim(), passwordText.text.trim(), "");
      await groupBloc.updateGroups();
      Navigator.pushNamed(context, HomePage.routeName);
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

  Widget get _getSigninScreen {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: _boxDecorationGradient,
      child: _buildSignInSingleChildScrollView,
    );
  }

  SingleChildScrollView get _buildSignInSingleChildScrollView {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 120),
      child: _buildSignInForm,
    );
  }

  Form get _buildSignInForm {
    return Form(
      key: _signInFormKey,
      child: _buildSignInFormColumn,
    );
  }

  Column get _buildSignInFormColumn {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _signText("Sign In"),
        SizedBox(height: 30.0),
        _buildTF(
            'Username',
            usernameText,
            TextInputType.text,
            Icons.account_circle,
            'Enter Username',
            false,
            TextInputAction.next,
            _userFocusNode,
            _passwordFocusNode),
        SizedBox(height: 30),
        _buildTF(
            'Password',
            passwordText,
            TextInputType.text,
            Icons.lock,
            'Enter a Password',
            true,
            TextInputAction.done,
            _passwordFocusNode,
            _loginFocusNode),
        _buildForgotPasswordBtn,
        _buildLoginBtn('LOGIN'),
        _buildSignupBtn,
      ],
    );
  }

  Widget get _buildSignupBtn {
    return GestureDetector(
      onTap: () {
        setState(() {
          _newUser = true;
        });
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

  Text _signText(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 30.0,
        color: Colors.white,
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.bold,
      ),
    );
  }

  BoxDecoration get _boxDecorationGradient {
    return BoxDecoration(
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
    );
  }

  //---------------------------------------
  /// Get Sign Up Screen
  Widget get _getSignUpScreen {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: _boxDecorationGradient,
      child: _buildSignUpSingleChildScrollView,
    );
  }

  SingleChildScrollView get _buildSignUpSingleChildScrollView {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 120),
      child: _buildSignUpForm,
    );
  }

  Form get _buildSignUpForm {
    return Form(
      key: _signUpFormKey,
      child: _buildSignUpFormColumn,
    );
  }

  Column get _buildSignUpFormColumn {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _signText("Sign Up"),
        SizedBox(height: 30.0),
        _buildTF(
            'Firstname',
            firstnameText,
            TextInputType.name,
            Icons.person,
            'Enter a Firstname',
            false,
            TextInputAction.next,
            _firstnameFocusNode,
            _lastnameFocusNode),
        SizedBox(height: 30.0),
        _buildTF(
            'Lastname',
            lastnameText,
            TextInputType.name,
            Icons.person,
            'Enter a Lastname',
            false,
            TextInputAction.next,
            _lastnameFocusNode,
            _userFocusNode),
        SizedBox(height: 30.0),
        _buildTF(
            'Username',
            usernameText,
            TextInputType.text,
            Icons.account_circle,
            'Enter a Username',
            false,
            TextInputAction.next,
            _userFocusNode,
            _phoneFocusNode),
        SizedBox(height: 30),
        _buildTF(
            'Phone Number',
            phonenumberText,
            TextInputType.phone,
            Icons.phone,
            'Enter a Phone Number',
            false,
            TextInputAction.next,
            _phoneFocusNode,
            _emailFocusNode),
        SizedBox(height: 30),
        _buildTF(
            'Email',
            emailText,
            TextInputType.emailAddress,
            Icons.email,
            'Enter an Email',
            false,
            TextInputAction.next,
            _emailFocusNode,
            _passwordFocusNode),
        SizedBox(height: 30),
        _buildTF(
            'Password',
            passwordText,
            TextInputType.text,
            Icons.lock,
            'Enter a Password',
            true,
            TextInputAction.go,
            _passwordFocusNode,
            _signupFocusNode),
        _buildSigningUpBtn('SIGN UP'),
        _buildBackToSignIn
      ],
    );
  }

  Widget _buildSigningUpBtn(String btnText) {
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
        onPressed: () async {
          await _handleSignUpInput;
        },
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

  get _handleSignUpInput async {
    if (_signUpFormKey.currentState!.validate()) {
      await _attemptSignUp;
    } else {
      _displayInvalidFormError();
    }
  }

  Future get _attemptSignUp async {
    try {
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
        _newUser = false;
        Navigator.pushNamed(context, '/splash');
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget get _buildBackToSignIn {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 0.0),
      child: TextButton(
        onPressed: () {
          setState(() {
            _newUser = false;
          });
        },
        child: Text('Back to Sign In', style: labelStyle),
      ),
    );
  }

  //-----------------------------------------
  /// Get Forgot Password Screen
  /* void _showForgotPasswordAlertDialog(BuildContext context) {
    ForgotPasswordDialogBox();
    /* return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: _boxDecorationGradient,
      child: _buildForgotPasswordSingleChildScrollView,
    ); */
  } */
/* 
  SingleChildScrollView get _buildForgotPasswordSingleChildScrollView {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 120),
      child: _buildForgotPasswordForm,
    );
  }

  Form get _buildForgotPasswordForm {
    return Form(
      key: _forgotPasswordFormKey,
      child: _buildForgotPasswordColumn,
    );
  }

  Column get _buildForgotPasswordColumn {
    return null;
  }
  
  Widget _buildResetPasswordpBtn(String btnText) {
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
        onPressed: () async {
          await _handleSignUpInput;
        },
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

  get _handleResetPasswordInput async {
    if (_signUpFormKey.currentState.validate()) {
      await _attemptSignUp;
    } else {
      _displayInvalidFormError();
    }
  }

  Future get _attemptResetPassword async {
    try {
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
        Navigator.pushNamed(context, '/splash');
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  } */
}
