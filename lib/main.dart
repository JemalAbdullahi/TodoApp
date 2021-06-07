import 'package:flutter/material.dart';
import 'package:todolist/UI/pages/home_page.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/services.dart';

import 'package:todolist/UI/pages/login_page.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/global.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColorLight: lightBlue,
          primaryColorDark: darkBlue,
          fontFamily: 'Segoe UI'),
      home: SignIn(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginPage(),
        '/splash': (BuildContext context) => Splash()
      },
    );
  }
}

/// Determines whether to direct user to login page or homepage.
class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TaskBloc tasksBloc;
  String apiKey = "";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: signInUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data.isNotEmpty) {
          apiKey = snapshot.data;
        }
        return apiKey.isNotEmpty ? Splash() : LoginPage();
      },
    );
  }

  Future signInUser() async {
    apiKey = await repository.getApiKey();
    if (apiKey.isNotEmpty && apiKey.length > 0) {
      try {
        userBloc.signinUser("", "", apiKey);
        return apiKey;
      } catch (e) {
        print(e);
      }
    }
    return apiKey;
  }
}

/// Display Splash screen while loading User's groups. Then redirect to Homepage.
class Splash extends StatelessWidget {
  /// Update Group list from server, then load homepage.
  Future<Widget> loadFromFuture() {
    // <fetch data from server. ex. login>
    groupBloc.updateGroups();
    return Future.value(HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      navigateAfterFuture: loadFromFuture(),
      title: new Text(
        'ToDo',
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
      ),
      gradientBackground: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [lightBlue, lightBlueGradient],
      ),
      //styleTextUnderTheLoader: new TextStyle(),
      loaderColor: Colors.black54,
    );
  }
}
