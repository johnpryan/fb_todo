import 'dart:async';

import 'package:fb_todo/src/model/todo.dart';

abstract class AuthService {
  Future<FirebaseUser> signIn();
  Future logOut();
}

abstract class FirebaseUser {
  String get uid;
}

class TodoChange {
  final TodoChangeType type;
  final Todo todo;

  TodoChange(this.type, this.todo);
}

enum TodoChangeType {
  added,
  modified,
  removed,
}

abstract class TodoService {
  Future<void> update(Todo todo, String userId);
  Future<void> remove(Todo todo, String userId);
  Stream<List<TodoChange>> onChanged(String userId);
  void addNew(String userId);
}
