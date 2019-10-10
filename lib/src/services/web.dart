import 'dart:html' as html;
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
      return Todo.fromJson(snapshot.data());
    }).toList();
  }
}

class _FirebaseUserImpl implements FirebaseUser {
  final String uid;
  _FirebaseUserImpl(this.uid);
}
