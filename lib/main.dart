import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/UI/pages/home_page.dart';

import 'package:todolist/UI/pages/login_page.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
//import 'package:todolist/bloc/resources/repository.dart';
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
        debugShowCheckedModeBanner: false,
        theme:
            ThemeData(primaryColorLight: lightBlue, primaryColorDark: darkBlue),
        home: SignIn());
  }
}

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //TaskBloc tasksBloc;
  String apiKey = "";
  //Repository _repository = Repository();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: signInUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          apiKey = snapshot.data;
          //tasksBloc = TaskBloc(apiKey);
          print(apiKey);
        } else {
          print("No data");
        }
        // String apiKey = snapshot.data;
        //apiKey.length > 0 ? getHomePage() :
        return apiKey.length > 0 ? HomePage() : LoginPage(login: login, newUser: false,);
      },
    );
  }

  Future signInUser() async {
    //String userName = "";
    apiKey = await getApiKey();
    if (apiKey != null) {
      if (apiKey.length > 0) {
        userBloc.signinUser("", "", apiKey);
      } else {
        print("No api key");
      }
    } else {
      apiKey = "";
    }
    return apiKey;
  }

  void login() {
    print("logging in");
    setState(() {
      build(context);
    });
  }

  Future getApiKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("API_Token");
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("API_Token", "");
    setState(() {
      build(context);
    });
  }
}
