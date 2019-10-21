import 'dart:html' as html;
import 'package:fb_todo/src/model/todo.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';

import 'services.dart';

class WebAuthService implements AuthService {
  final fb.Auth _auth;

  WebAuthService(fb.App app) : _auth = fb.auth(app);

  @override
  void logOut() {
    _auth.signOut();
  }

  @override
  Future<FirebaseUser> signIn() async {
    var credential = await _auth.signInWithPopup(fb.GoogleAuthProvider());
    return _FirebaseUserImpl(credential.user.uid);
  }
}

class WebTodoService implements TodoService {
  Firestore _firestore;

  WebTodoService(fb.App app) : _firestore = fb.firestore(app);

  @override
  Future<List<Todo>> getTodos(String userId) async {
    var snapshot = _firestore.collection('users').doc(userId);
    var collection = snapshot.collection('todos');
    var todosSnapshot = await collection.onSnapshot.first;
    var todos = todosSnapshot.docs;
    return todos.map((snapshot) {
      return Todo.fromJson(snapshot.data())..id = snapshot.id;
    }).toList();
  }

  @override
  Future update(Todo todo, String userId) async {
    var snapshot = _firestore.doc('users/$userId/todos/${todo.id}');
    await snapshot.update(data: todo.toJson());
  }

  Stream<List<Todo>> onChanged(String userId) {
    var snapshots = _firestore.collection('users/$userId/todos').onSnapshot;
    return snapshots.map((querySnapshot) {
      return querySnapshot.docChanges().map((docChange) {
        var doc = docChange.doc;
        return Todo.fromJson(doc.data())..id = doc.id;
      }).toList();
    });
  }

  void addNew(String userId) {
    _firestore.collection('users/$userId/todos').add(Todo(false, '').toJson());
  }
}

class _FirebaseUserImpl implements FirebaseUser {
  final String uid;
  _FirebaseUserImpl(this.uid);
}
