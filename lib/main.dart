import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/UI/pages/home_page.dart';
import 'package:splashscreen/splashscreen.dart';
//import 'package:flutter/services.dart';

import 'package:todolist/UI/pages/login_page.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
//import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/global.dart';

main() => runApp(new MaterialApp(
      title: 'To Do List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColorLight: lightBlue,
          primaryColorDark: darkBlue,
          fontFamily: 'Segoe UI'),
      home: new MyApp(),
    ));

class MyApp extends StatelessWidget {
  //unused
  Future<Widget> loadFromFuture() async {
    // <fetch data from server. ex. login>

    return Future.value(new AfterSplash());
  }

  @override
  Widget build(BuildContext context) {
    //Navigate to Sign In page after SplashScreen is displayed
    return new SplashScreen(
        navigateAfterSeconds: SignIn(),
        seconds: 5,
        title: new Text(
          'ToDo',
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
        ),
        gradientBackground: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [lightBlue, lightBlueGradient],
        ),
        styleTextUnderTheLoader: new TextStyle(),
        onClick: () => print("Flutter Egypt"),
        loaderColor: Colors.black54);
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("Welcome In SplashScreen Package"),
          automaticallyImplyLeading: false),
      body: new Center(
        child: new Text(
          "Done!",
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
        ),
      ),
    );
  }
}

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TaskBloc tasksBloc;
  String apiKey = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: signInUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data.isNotEmpty) {
          //apiKey = snapshot.data;
          apiKey = "Qdm6Ug5eTKOXMdmCjEuacljTWVTzMDhggtKSg5vRMKVwli5lFZ";
        }
        return apiKey.isNotEmpty
            ? HomePage(logout: logout)
            : LoginPage(
                login: login,
                newUser: false,
              );
      },
    );
  }

  Future signInUser() async {
    //apiKey = await repository.getApiKey();
    apiKey = "Qdm6Ug5eTKOXMdmCjEuacljTWVTzMDhggtKSg5vRMKVwli5lFZ";
    if (apiKey.isNotEmpty && apiKey.length > 0) {
      try {
        print(apiKey);
        userBloc.signinUser("", "", apiKey);
        return apiKey;
      } catch (e) {
        print(e);
      }
    }
    return apiKey;
  }

  void login() {
    setState(() {
      build(context);
    });
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("API_Token", "");
    setState(() {});
  }
}
