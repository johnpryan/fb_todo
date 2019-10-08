import 'package:fb_todo/src/pages/todo_list.dart';
import 'package:fb_todo/src/services/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/login.dart';

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  TodoService service;

  @override
  void initState() {
    super.initState();
    service = TodoService();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<TodoService>.value(
      value: service,
      child: MaterialApp(
        onGenerateRoute: (settings) {
          if (settings.name == "/") {
            return PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  TodoListPage(service: service),
              transitionsBuilder: (context, animation1, animation2, child) {
                return FadeTransition(opacity: animation1, child: child);
              },
            );
          }
          if (settings.name == '/login') {
            return PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => LoginPage(),
              transitionsBuilder: (context, animation1, animation2, child) {
                return FadeTransition(opacity: animation1, child: child);
              },
            );
          }
          return null;
        },
      ),
    );
  }
}
