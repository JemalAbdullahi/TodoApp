import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/user.dart';
import 'package:todolist/widgets/global_widgets/background_color_container.dart';
import 'package:todolist/widgets/global_widgets/custom_appbar.dart';

//import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
//import 'package:todolist/models/global.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile';
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  User _user = userBloc.getUserObject();

  late String _currentPassword,
      _newPassword,
      _confirmPassword,
      _emailAddress,
      _username,
      _firstname,
      _lastname,
      _phonenumber;

  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _emailAddressController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _phonenumberController = TextEditingController();

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
    return SafeArea(
      child: BackgroundColorContainer(
        startColor: lightBlue,
        endColor: lightBlueGradient,
        widget: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar('Edit Profile'),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 40),
            physics: AlwaysScrollableScrollPhysics(),
            child: _buildForm(context),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Center(child: _user.cAvatar(radius: 56.0)),
          SizedBox(height: 20),
          _firstnameField(),
          SizedBox(height: 20),
          _lastnameField(),
          SizedBox(height: 20),
          _phonenumberField(),
          SizedBox(height: 20),
          _usernameField(),
          SizedBox(height: 20),
          _emailAddressField(),
          SizedBox(height: 20),
          _newPasswordField(),
          SizedBox(height: 20),
          _confirmPasswordField(),
          SizedBox(height: 20),
          _currentPasswordField(),
          SizedBox(height: 20),
          _buildSaveButton(context)
        ],
      ),
    );
  }

  Widget _currentPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Current Password", style: labelStyle),
        SizedBox(height: 10),
        Container(
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
              errorStyle: TextStyle(fontSize: 16, color: Colors.red),
            ),
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Current Password is Required';
              }
              if (value != _user.password) {
                return 'Incorrect Password';
              }
              return null;
            },
            onSaved: (newValue) => _currentPassword = newValue!.trim(),
          ),
        )
      ],
    );
  }

  Widget _usernameField() {
    _usernameController.text = _user.username;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Username", style: labelStyle),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: profileBoxDecorationStyle,
          child: TextFormField(
            controller: _usernameController,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0, left: 14.0),
                prefixIcon: Icon(Icons.person, color: Colors.white),
                hintText: 'Username',
                hintStyle: hintTextStyle,
                errorMaxLines: 2,
                errorStyle: TextStyle(fontSize: 16)),
            onSaved: (newValue) => _username = newValue!.trim(),
          ),
        ),
      ],
    );
  }

  Widget _firstnameField() {
    _firstnameController.text = _user.firstname;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("First Name", style: labelStyle),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: profileBoxDecorationStyle,
          child: TextFormField(
            controller: _firstnameController,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0, left: 14.0),
                prefixIcon: Icon(Icons.person_outline, color: Colors.white),
                hintText: 'Firstname',
                hintStyle: hintTextStyle,
                errorMaxLines: 2,
                errorStyle: TextStyle(fontSize: 16)),
            onSaved: (newValue) => _firstname = newValue!.trim(),
          ),
        ),
      ],
    );
  }

  Widget _lastnameField() {
    _lastnameController.text = _user.lastname;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Last Name", style: labelStyle),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: profileBoxDecorationStyle,
          child: TextFormField(
            controller: _lastnameController,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0, left: 14.0),
                prefixIcon: Icon(Icons.person_outline, color: Colors.white),
                hintText: 'Lastname',
                hintStyle: hintTextStyle,
                errorMaxLines: 2,
                errorStyle: TextStyle(fontSize: 16)),
            onSaved: (newValue) => _lastname = newValue!.trim(),
          ),
        ),
      ],
    );
  }

  Widget _phonenumberField() {
    _phonenumberController.text = _user.phonenumber;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Phone Number", style: labelStyle),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: profileBoxDecorationStyle,
          child: TextFormField(
            controller: _phonenumberController,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0, left: 14.0),
                prefixIcon: Icon(Icons.phone, color: Colors.white),
                hintText: 'Phone Number',
                hintStyle: hintTextStyle,
                errorMaxLines: 2,
                errorStyle: TextStyle(fontSize: 16)),
            onSaved: (newValue) => _phonenumber = newValue!.trim(),
          ),
        ),
      ],
    );
  }

  Widget _emailAddressField() {
    _emailAddressController.text = _user.emailaddress;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Email Address", style: labelStyle),
        SizedBox(height: 10),
        Container(
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
            onSaved: (newValue) => _emailAddress = newValue!.trim(),
          ),
        ),
      ],
    );
  }

  Widget _newPasswordField() {
    _newPasswordController.text = _user.password!;
    _newPassword = _user.password!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("New Password", style: labelStyle),
        SizedBox(height: 10),
        Container(
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
            onSaved: (newValue) => _newPassword = newValue!.trim(),
          ),
        ),
      ],
    );
  }

  Widget _confirmPasswordField() {
    _confirmPasswordController.text = _user.password!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Confirm Password", style: labelStyle),
        SizedBox(height: 10),
        Container(
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
            validator: (val) =>
                MatchValidator(errorText: 'Passwords Do Not Match')
                    .validateMatch(val!, _newPassword),
            onSaved: (newValue) => _confirmPassword = newValue!.trim(),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
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
          if (_formKey.currentState!.validate()) {
            try {
              _formKey.currentState!.save();
              await userBloc.updateUserProfile(
                  _currentPassword,
                  _confirmPassword,
                  _emailAddress,
                  _username,
                  _firstname,
                  _lastname,
                  _phonenumber,
                  null);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Success: Profile Updated!'),
                  backgroundColor: Colors.green,
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("$e"),
                  backgroundColor: Colors.red,
                ),
              );
            }
            return;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failure: Profile Did Not Update!'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
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
