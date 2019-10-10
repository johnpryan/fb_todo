import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/app.dart';
import 'src/app_context.dart';
import 'src/services/flutter.dart';

void main() => runApp(FlutterTodoApp());

class FlutterTodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<FlutterTodoApp> {
  AppContext appContext;

  @override
  void initState() {
    super.initState();
    appContext = AppContext(FlutterAuthService(), FlutterTodoService());
  }

  @override
  Widget build(BuildContext context) {
    return Provider<AppContext>.value(value: appContext, child: TodoApp());
  }
}
