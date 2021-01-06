import 'package:flutter/material.dart';
import 'package:todolist/models/global.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController firstnameText = new TextEditingController();

  TextEditingController confirmPassword = new TextEditingController();

  TextEditingController oldPassword = new TextEditingController();

  TextEditingController newPassword = new TextEditingController();

  TextEditingController emailText = new TextEditingController();

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
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
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
            child: Column(
              children: <Widget>[
                _buildCircleAvatar(),
                SizedBox(height: 25),
                _oldPassword(),
                SizedBox(height: 20),
                _buildEmailTF(),
                SizedBox(height: 20),
                _buildPasswordTF(),
                SizedBox(height: 20),
                _buildRePasswordTF(),
                SizedBox(height: 10),
                _buildSaveButton()
              ],
            ),
          )),
    );
  }

  Widget _buildCircleAvatar() {
    return CircleAvatar(
      radius: 40,
      backgroundColor: darkBlueGradient,
      child: Text(
        'JA',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _oldPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
              text: 'Old Password',
              style: profileLabelStyle,
              children: [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.normal,
                      fontSize: 16),
                )
              ]),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: profileBoxDecorationStyle,
          height: 60,
          child: TextField(
            controller: firstnameText,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.lock_outline, color: Colors.white),
              hintText: 'Old Password',
              hintStyle: hintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildLastNameTF() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       Text('Last Name', style: profileLabelStyle),
  //       SizedBox(height: 10),
  //       Container(
  //         alignment: Alignment.centerLeft,
  //         decoration: profileBoxDecorationStyle,
  //         height: 60,
  //         child: TextField(
  //           controller: lastnameText,
  //           keyboardType: TextInputType.text,
  //           style: TextStyle(color: Colors.white),
  //           decoration: InputDecoration(
  //             border: InputBorder.none,
  //             contentPadding: EdgeInsets.only(top: 14.0),
  //             prefixIcon: Icon(Icons.account_circle, color: Colors.white),
  //             hintText: 'Change your Last Name',
  //             hintStyle: hintTextStyle,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Email Address', style: profileLabelStyle),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: profileBoxDecorationStyle,
          height: 60,
          child: TextField(
            controller: emailText,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.email, color: Colors.white),
              hintText: 'Change your Email',
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
        Text('Password', style: profileLabelStyle),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: profileBoxDecorationStyle,
          height: 60,
          child: TextField(
            controller: newPassword,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.lock, color: Colors.white),
              hintText: 'Enter a New Password',
              hintStyle: hintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRePasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Confirm Password', style: profileLabelStyle),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: profileBoxDecorationStyle,
          height: 60,
          child: TextField(
            controller: confirmPassword,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.lock, color: Colors.white),
              hintText: 'Confirm New Password',
              hintStyle: hintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        autofocus: false,
        onPressed: updateProfileFunc(),
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

  updateProfileFunc() {
    if (oldPassword.text != null && oldPassword.text != "") {
      if (newPassword.text != null && confirmPassword.text != null) {
        if (newPassword.text == confirmPassword.text) {
          if (emailText.text != null) {
            //update Password and Email
          } else {
            // update password
          }
        }else{
          //error Both Password Fields must be entered
        }
      } else if (emailText.text != null) {
        //update email
      }
    } else {
      // Display error; must enter old password
    }
  }
}
