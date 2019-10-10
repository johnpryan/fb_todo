import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase/firebase.dart' as fb;

import 'src/app.dart';
import 'src/app_context.dart';
import 'src/services/web.dart';

void main() => runApp(WebTodoApp());

class WebTodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<WebTodoApp> {
  AppContext appContext;

  @override
  void initState() {
    super.initState();
    var app = fb.initializeApp(
      apiKey: "AIzaSyB3621RvSUbxgCPw3Dnq4uwKTjpZWILubI",
      authDomain: "ryjohn-fb-todo.firebaseapp.com",
      databaseURL: "https://ryjohn-fb-todo.firebaseio.com",
      projectId: "ryjohn-fb-todo",
      storageBucket: "ryjohn-fb-todo.appspot.com",
      messagingSenderId: "942025734552",
      // The name is also referred to as the app ID or project ID.
      name: "1:942025734552:web:4ef259548602f97f08d3ed",
    );

    appContext = AppContext(WebAuthService(app), WebTodoService(app));
  }

  @override
  Widget build(BuildContext context) {
    return Provider<AppContext>.value(value: appContext, child: TodoApp());
  }
}
