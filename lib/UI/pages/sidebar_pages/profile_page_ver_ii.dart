import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/user.dart';

//import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
//import 'package:todolist/models/global.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  User _user = userBloc.getUserObject();

  String _currentPassword, _newPassword, _confirmPassword, _emailAddress;

  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _emailAddressController = TextEditingController();

  final profileLabelStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
  );

  final profileBoxDecorationStyle = BoxDecoration(
    color: darkBlue,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 12.0,
        offset: Offset(0, 4),
      ),
    ],
  );

  final passwordValidator = MultiValidator([
    MinLengthValidator(8,
        errorText: 'password must be at least 8 characters long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'passwords must have at least one special character')
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBlueGradient,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _buildFormContainer(),
    );
  }

  Widget _buildFormContainer() {
    return Builder(builder: (BuildContext context) {
      return Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [lightBlueGradient, lightBlue],
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: _buildForm(context),
        ),
      );
    });
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _currentPasswordField(),
          SizedBox(height: 20),
          _emailAddressField(),
          SizedBox(height: 20),
          _newPasswordField(),
          SizedBox(height: 20),
          _confirmPasswordField(),
          SizedBox(height: 20),
          _buildSaveButton(context)
        ],
      ),
    );
  }

  Widget _currentPasswordField() {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: profileBoxDecorationStyle,
      child: TextFormField(
        controller: _currentPasswordController,
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14.0, left: 14.0),
            prefixIcon: Icon(Icons.lock_outline, color: Colors.white),
            hintText: 'Current Password',
            hintStyle: hintTextStyle,
            errorMaxLines: 2,
            errorStyle: TextStyle(fontSize: 16)),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Current Password is Required';
          }
          if (value != _user.password) {
            return 'Incorrect Password';
          }
          return null;
        },
        onSaved: (newValue) => _currentPassword = newValue,
      ),
    );
  }

  Widget _emailAddressField() {
    _emailAddressController.text = _user.emailAddress;
    return Container(
      alignment: Alignment.centerLeft,
      decoration: profileBoxDecorationStyle,
      child: TextFormField(
        controller: _emailAddressController,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14.0, left: 14.0),
            prefixIcon: Icon(Icons.email, color: Colors.white),
            hintText: 'Email Address',
            hintStyle: hintTextStyle,
            errorMaxLines: 2,
            errorStyle: TextStyle(fontSize: 16)),
        validator: EmailValidator(errorText: 'Enter a Valid Email'),
        onSaved: (newValue) => _emailAddress = newValue,
      ),
    );
  }

  Widget _newPasswordField() {
    _newPasswordController.text = _user.password;
    return Container(
      alignment: Alignment.centerLeft,
      decoration: profileBoxDecorationStyle,
      child: TextFormField(
        controller: _newPasswordController,
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14.0, left: 14.0),
            prefixIcon: Icon(Icons.lock, color: Colors.white),
            hintText: 'New Password',
            hintStyle: hintTextStyle,
            errorMaxLines: 2,
            errorStyle: TextStyle(fontSize: 16)),
        validator: passwordValidator,
        onChanged: (newValue) => _newPassword = newValue,
      ),
    );
  }

  Widget _confirmPasswordField() {
    _confirmPasswordController.text = _user.password;
    return Container(
      alignment: Alignment.centerLeft,
      decoration: profileBoxDecorationStyle,
      child: TextFormField(
        controller: _confirmPasswordController,
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14.0, left: 14.0),
            prefixIcon: Icon(Icons.lock, color: Colors.white),
            hintText: 'Re-Enter New Password',
            hintStyle: hintTextStyle,
            errorMaxLines: 2,
            errorStyle: TextStyle(fontSize: 16)),
        validator: (val) => MatchValidator(errorText: 'passwords do not match')
            .validateMatch(val, _newPassword),
        onSaved: (newValue) => _confirmPassword = newValue,
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        autofocus: false,
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            try {
              _formKey.currentState.save();
              await userBloc.updateUserProfile(_currentPassword, _confirmPassword,
                  _emailAddress, _user.apiKey);
              print("Successful");
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Success: Profile Updated!'),
                  backgroundColor: Colors.green,
                ),
              );
            } catch (e) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(e.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
            return;
          } else {
            print("Unsuccessfull");
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Failure: Profile Did Not Update!'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Colors.white,
        disabledColor: Colors.white,
        child: Text(
          'Update Profile',
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
