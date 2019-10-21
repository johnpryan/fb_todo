import 'dart:async';

import 'package:fb_todo/src/model/todo.dart';

abstract class AuthService {
  Future<FirebaseUser> signIn();
  void logOut();
}

abstract class FirebaseUser {
  String get uid;
}

abstract class TodoService {
  Future<List<Todo>> getTodos(String userId);
  Future update(Todo todo, String userId);
  Stream<List<Todo>> onChanged(String userId);
  void addNew(String userId);
}
