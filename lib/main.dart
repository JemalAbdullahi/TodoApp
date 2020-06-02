import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/UI/pages/home_page.dart';
import 'package:flutter/services.dart';

import 'package:todolist/UI/pages/login_page.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/bloc/resources/repository.dart';
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
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
        title: 'To Do List',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColorLight: lightBlue,
            primaryColorDark: darkBlue,
            fontFamily: 'OpenSans'),
        home: SignIn());
  }
}

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TaskBloc tasksBloc;
  String apiKey = "";
  Repository repository = Repository();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: signInUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          apiKey = snapshot.data;
          print(apiKey);
          if (apiKey.length > 0 && apiKey != null) {
            tasksBloc = TaskBloc(apiKey);
          }
        } else {
          print("No data");
        }
        //String apiKey = snapshot.data;
        //apiKey.length > 0 ? getHomePage() :
        return apiKey.length > 0
            ? HomePage(
                repository: repository,
                logout: logout,
                addTaskDialog: addTaskDialog,
                tasksBloc: tasksBloc)
            : LoginPage(
                login: login,
                newUser: false,
              );
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

  void addTask(String taskName, String groupName) async {
    await repository.addUserTask(this.apiKey, taskName, groupName);
    setState(() {
      build(context);
    });
  }

  // void addSubTask(String taskKey, String subtaskName, String notes) async {
  //   await repository.addSubTask(taskKey, subtaskName, notes);
  //   setState(() {
  //     build(context);
  //   });
  // }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("API_Token", "");
    setState(() {
      build(context);
    });
  }

  void addTaskDialog() {
    TextEditingController _taskNameController = new TextEditingController();
    TextEditingController _groupNameController = new TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: lightBlue,
          content: Container(
            height: 250,
            width: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("Add New Task", style: loginTitleStyle),
                TextField(
                  controller: _taskNameController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Project/Task Name',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                  ),
                ),
                TextField(
                  controller: _groupNameController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Group Name',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                      child: Text(
                        "Save",
                        style: loginButtonStyle,
                      ),
                      disabledColor: darkBlueGradient,
                      color: lightBlueGradient,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.transparent),
                      ),
                      onPressed: () {
                        if (_taskNameController.text != null) {
                          addTask(_taskNameController.text,
                              _groupNameController.text);
                          Navigator.pop(context);
                        }
                      },
                    ),
                    SizedBox(width: 8.0),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
