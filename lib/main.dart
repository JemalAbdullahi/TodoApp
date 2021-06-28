import 'package:flutter/material.dart';
import 'package:todolist/UI/pages/authenticate/signup_page.dart';
import 'package:todolist/UI/pages/home_page.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/services.dart';
import 'package:todolist/UI/pages/authenticate/login_page.dart';
import 'package:todolist/UI/pages/sidebar_pages/create_new_group_page.dart';
import 'package:todolist/UI/pages/sidebar_pages/group_page.dart';
import 'package:todolist/UI/pages/sidebar_pages/profile_page.dart';
import 'package:todolist/UI/tabs/list_groups_tab.dart';
import 'package:todolist/UI/tabs/subtask_list_tab.dart';
import 'package:todolist/UI/tabs/todo_tab.dart';
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
      initialRoute: Splash.routeName,
      routes: <String, WidgetBuilder>{
        Splash.routeName: (BuildContext context) => Splash(),
        LoginPage.routeName: (BuildContext context) => LoginPage(),
        SignupPage.routeName: (BuildContext context) => SignupPage(),
        HomePage.routeName: (BuildContext context) => HomePage(),
        ListGroupsTab.routeName: (BuildContext context) => ListGroupsTab(),
        ToDoTab.routeName: (BuildContext context) => ToDoTab(),
        SubtaskListTab.routeName: (BuildContext context) => SubtaskListTab(),
        CreateGroupPage.routeName: (BuildContext context) => CreateGroupPage(),
        ProfilePage.routeName: (BuildContext context) => ProfilePage(),
        GroupPage.routeName: (BuildContext context) => GroupPage(),
      },
    );
  }
}

/// Determines whether to direct user to login page or homepage.
/* class SignIn extends StatelessWidget {
  late final String apiKey;
  late final String initialRoute;

  SignIn() {
    signInUser();
  }

  @override
  Widget build(BuildContext context) {
    return MyApp(initialRoute: initialRoute);
  }

  Future<void> signInUser() async {
    apiKey = await repository.getApiKey();
    if (apiKey.isNotEmpty && apiKey.length > 0) {
      try {
        userBloc.signinUser("", "", apiKey);
        initialRoute = Splash.routeName;
      } catch (e) {
        print(e);
      }
    } else {
      initialRoute = LoginPage.routeName;
    }
  }
} */

/// Display Splash screen while loading User's groups. Then redirect to Homepage.
/// No arguments need to be passed when navigating to page Splash
class Splash extends StatelessWidget {
  static const routeName = '/';
  late final String apiKey;

  /// Update Group list from server, then load homepage.
  Future<String> loadFromFuture(BuildContext context) async {
    apiKey = await repository.getApiKey();
    if (apiKey.isNotEmpty && apiKey.length > 0) {
      try {
        userBloc.signinUser("", "", apiKey);
        // <fetch data from server. ex. login>
        await groupBloc.updateGroups();
      } catch (e) {
        print(e);
      }
      return HomePage.routeName;
    } else
      return LoginPage.routeName;
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      navigateAfterFuture: loadFromFuture(context),
      title: Text(
        'ToDo',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
      ),
      gradientBackground: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [lightBlue, lightBlueGradient],
      ),
      //styleTextUnderTheLoader: new TextStyle(),
      loaderColor: Colors.black54,
    );
    /* Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [lightBlue, lightBlueGradient],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                "ToDo",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
              ),
            ),
          )
        ],
      ),
    ); */
  }
}
