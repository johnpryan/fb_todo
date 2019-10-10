import 'package:fb_todo/src/app_context.dart';
import 'package:fb_todo/src/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../services/todo_service.dart';

class TodoListPage extends StatefulWidget {
  final AppContext appContext;

  TodoListPage({@required this.appContext});

  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<Todo> _todos = [];

  AuthService get authService => widget.appContext.authService;
  TodoService get todoService => widget.appContext.todoService;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future _init() async {
    var user = await authService.signIn();
    var todos = await todoService.getTodos(user);

    setState(() {
      _todos = todos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todos"),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Text('Todo App'),
              ),
            ),
            ListTile(
              title: Text('Log out'),
              onTap: () {
                authService.logOut();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, idx) {
          return ListTile(
            title: Text(_todos[idx].description),
          );
        },
      ),
    );
  }
}
