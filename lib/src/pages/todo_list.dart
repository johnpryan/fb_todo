import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

import '../services/todo_service.dart';

class TodoListPage extends StatefulWidget {
  final TodoService service;

  TodoListPage({@required this.service});

  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future _init() async {
    var user = await _signIn();
    var todos = await widget.service.getTodos(user);
    setState(() {
      _todos = todos;
    });
  }

  Future<FirebaseUser> _signIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    var googleAuth = await googleUser.authentication;

    var credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    var user = (await _auth.signInWithCredential(credential)).user;
    return user;
  }

  void _logOut() {
    _auth.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
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
              child: Center(child: Text('Todo App'),),
            ),
            ListTile(
              title: Text('Log out'),
              onTap: () {
                _logOut();
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
