import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback login;
  final bool newUser;

  const LoginPage({Key key, this.login, this.newUser}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _newUser = false;
  final _signInFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: _newUser ? _getSignUpScreen : _getSigninScreen,
      ),
    );
  }

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
        _label(label),
        SizedBox(height: 10),
        _buildContainer(
            controller, keyboardType, iconData, hintText, obscureText),
      ],
    );
  }

  Text _label(String label) => Text(label, style: labelStyle);

  Container _buildContainer(
      TextEditingController controller,
      TextInputType keyboardType,
      IconData iconData,
      String hintText,
      bool obscureText) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: boxDecorationStyle,
      height: 60,
      child: _buildTextFormField(
          controller, keyboardType, iconData, hintText, obscureText),
    );
  }

  TextFormField _buildTextFormField(
      TextEditingController controller,
      TextInputType keyboardType,
      IconData iconData,
      String hintText,
      bool obscureText) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
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
        if (value.isEmpty) {
          return '\t\tPlease Enter some text';
        }
        return null;
      },
      obscureText: obscureText,
    );
  }

  Widget get _buildForgotPasswordBtn {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 0.0),
      child: TextButton(
        onPressed: null,
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
    if (_signInFormKey.currentState.validate()) {
      await _attemptLogin;
    } else {
      _displayInvalidFormError();
    }
  }

  Future get _attemptLogin async {
    try {
      await userBloc.signinUser(
          usernameText.text.trim(), passwordText.text.trim(), "");
      widget.login();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
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
        _buildTF('Username', usernameText, TextInputType.text,
            Icons.account_circle, 'Enter Username', false),
        SizedBox(height: 30),
        _buildTF('Password', passwordText, TextInputType.text, Icons.lock,
            'Enter a Password', true),
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
        _buildTF('Firstname', firstnameText, TextInputType.name, Icons.person,
            'Enter a Firstname', false),
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
        _buildTF('Email', emailText, TextInputType.emailAddress, Icons.email,
            'Enter an Email', false),
        SizedBox(height: 30),
        _buildTF('Password', passwordText, TextInputType.text, Icons.lock,
            'Enter a Password', true),
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
    if (_signUpFormKey.currentState.validate()) {
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
        widget.login();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
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
}
