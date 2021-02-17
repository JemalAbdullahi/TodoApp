import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/UI/pages/home_page.dart';
//import 'package:flutter/services.dart';

import 'package:todolist/UI/pages/login_page.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/global.dart';

import 'models/tasks.dart';

main() => runApp(
      MyApp(),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return MaterialApp(
      title: 'To Do List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColorLight: lightBlue,
          primaryColorDark: darkBlue,
          fontFamily: 'Segoe UI'),
      home: SignIn(),
    );
  }
}

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TaskBloc tasksBloc;
  GroupBloc groupBloc;
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
          if (apiKey.isNotEmpty) {
            tasksBloc = TaskBloc(apiKey);
            groupBloc = GroupBloc(apiKey);
            /* // Testing GroupBloc 
            groupBloc.testGroupList().then((groups){
              for (Group g in groups) {
                print(g.name);                
              }
            });*/
          }
        }
        return apiKey.isNotEmpty
            ? HomePage(
                repository: repository,
                logout: logout,
                addTaskDialog: addTaskDialog,
                tasksBloc: tasksBloc,
                groupBloc: groupBloc,
                reAddTask: reAddTask)
            : LoginPage(
                login: login,
                newUser: false,
              );
      },
    );
  }

  Future signInUser() async {
    apiKey = await getApiKey();
    if (apiKey.isNotEmpty) {
      if (apiKey.length > 0) {
        try {
          userBloc.signinUser("", "", apiKey);
        } catch (e) {
          print(e);
        }
      } else {}
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

  void addTask(String taskName, String groupKey, int index) async {
    await repository.addUserTask(this.apiKey, taskName, groupKey, index);
    setState(() {
      build(context);
    });
  }

  void reAddTask(Task task) {
    addTask(task.title, task.groupKey, task.index);
  }

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
                  autofocus: true,
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
                        if (_taskNameController.text.isNotEmpty) {
                          addTask(_taskNameController.text,
                              _groupNameController.text, -1);
                          Navigator.pop(context);
                        } else {
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
