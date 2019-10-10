import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_context.dart';
import 'pages/login.dart';
import 'pages/todo_list.dart';

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        if (settings.name == "/") {
          return PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                TodoListPage(appContext: Provider.of<AppContext>(context)),
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
    );
  }
}
