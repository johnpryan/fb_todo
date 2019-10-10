import 'package:fb_todo/src/pages/todo_list.dart';
import 'package:fb_todo/src/services/auth_service.dart';
import 'package:fb_todo/src/services/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_context.dart';
import 'pages/login.dart';

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  AppContext appContext;

  @override
  void initState() {
    super.initState();
    appContext = AppContext(AuthService(), TodoService());
  }

  @override
  Widget build(BuildContext context) {
    return Provider<AppContext>.value(
      value: appContext,
      child: MaterialApp(
        onGenerateRoute: (settings) {
          if (settings.name == "/") {
            return PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  TodoListPage(appContext: appContext),
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
