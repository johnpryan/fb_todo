import 'dart:async';

import 'package:fb_todo/src/app_context.dart';
import 'package:fb_todo/src/model/todo.dart';
import 'package:fb_todo/src/widgets/todo.dart';
import 'package:flutter/material.dart';

import '../services/services.dart';

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
  FirebaseUser _user;
  StreamSubscription _updateSubscription;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _updateSubscription.cancel();
    super.dispose();
  }

  Future _init() async {
    await _signIn();
    await _fetchTodos();
    _updateSubscription = todoService.onChanged(_user.uid).listen((changed) {
      var newTodos = List<Todo>.from(_todos);

      // Update all items that exist in both collections
      for (var changedItem in changed) {
        var toChangeIdx = newTodos.indexWhere((t) => t.id == changedItem.id);
        newTodos[toChangeIdx].updateFrom(changedItem);
      }

      // TODO: add and remove

      setState(() {
        _todos = newTodos;
      });
    });
  }

  Future _signIn() async {
    _user = await authService.signIn();
  }

  Future _fetchTodos() async {
    var todos = await todoService.getTodos(_user.uid);

    setState(() {
      _todos = todos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todos"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _fetchTodos();
            },
          )
        ],
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
          return TodoWidget(
            todo: _todos[idx],
            onChanged: () {
              todoService.update(_todos[idx], _user.uid);
            },
          );
        },
      ),
    );
  }
}
