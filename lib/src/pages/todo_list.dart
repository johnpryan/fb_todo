import 'dart:async';

import 'package:fb_todo/src/app_context.dart';
import 'package:fb_todo/src/model/todo.dart';
import 'package:fb_todo/src/widgets/header.dart';
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
    _updateSubscription = todoService
        .changes(_user.uid)
        .listen((changed) => _updateTodos(changed))
          ..onError((error) {
            print('error subscribing: $error');
          });
  }

  Future _signIn() async {
    _user = await authService.signIn();
  }

  void _updateTodos(List<TodoChange> changes) {
    var newTodos = List<Todo>.from(_todos);

    // Update all items that exist in both collections
    for (var change in changes) {
      switch (change.type) {
        case TodoChangeType.added:
          newTodos.add(change.todo);
          break;
        case TodoChangeType.removed:
          newTodos.removeWhere((t) => t.id == change.todo.id);
          break;
        case TodoChangeType.modified:
          var idx = newTodos.indexWhere((t) => t.id == change.todo.id);
          if (idx >= 0) {
            newTodos[idx].updateFrom(change.todo);
          }
          break;
      }
    }

    setState(() {
      _todos = newTodos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              onTap: () async {
                await authService.signOut();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Header('My Tasks'),
            ..._todos.map((todo) {
              return TodoWidget(
                todo: todo,
                onChanged: () {
                  todoService.update(todo, _user.uid);
                },
                onDismissed: () {
                  // The Dismissible widget needs to be removed from the widget tree
                  // immediately.
                  setState(() {
                    if (_todos.remove(todo)) {
                      todoService.remove(todo, _user.uid);
                    }
                  });
                },
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          todoService.add(_user.uid);
        },
      ),
    );
  }
}
