import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/UI/pages/home_page.dart';

import 'package:todolist/UI/pages/login_page.dart';
import 'package:todolist/models/global.dart';

import 'models/authentication/auth_service.dart';

main() => runApp(
      ChangeNotifierProvider<AuthService>(
        child: MyApp(),
        create: (BuildContext context) {
          return AuthService();
        },
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      theme: ThemeData(primaryColorLight: lightBlue, primaryColorDark: darkBlue),
      home: FutureBuilder(
        // get the Provider, and call the getUser method
        future: Provider.of<AuthService>(context).getUser(),
        // wait for the future to resolve and render the appropriate
        // widget for HomePage or LoginPage
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.hasData ? HomePage(title: 'To Do List') : LoginPage();
          } else {
            return Container(color: Colors.white);
          }
        },
      ),
    );
  }
}
