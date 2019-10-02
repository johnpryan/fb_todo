import 'package:fb_todo/src/pages/todo_list.dart';
import 'package:fb_todo/src/services/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        home: TodoListPage(
          service: service,
        ),
      ),
    );
  }
}
