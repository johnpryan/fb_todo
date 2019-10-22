import 'package:fb_todo/src/model/todo.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';

import 'services.dart';

class WebAuthService implements AuthService {
  final fb.Auth _auth;

  WebAuthService(fb.App app) : _auth = fb.auth(app);

  @override
  Future logOut() async {
    await _auth.signOut();
  }

  @override
  Future<FirebaseUser> signIn() async {
    var currentUser = _auth.currentUser;
    if (currentUser != null) {
      return _FirebaseUserImpl(currentUser.uid);
    }

    // First, try to get the redirect result if there is one. If not, sign in
    // using a redirect.
    var result = await _auth.getRedirectResult();
    if (result.user == null) {
      await _auth.signInWithRedirect(fb.GoogleAuthProvider());
      result = await _auth.getRedirectResult();
    }

    return _FirebaseUserImpl(result.user.uid);
  }
}

class WebTodoService implements TodoService {
  Firestore _firestore;

  WebTodoService(fb.App app) : _firestore = fb.firestore(app);

  @override
  Future update(Todo todo, String userId) async {
    var snapshot = _firestore.doc('users/$userId/todos/${todo.id}');
    await snapshot.update(data: todo.toJson());
  }

  Future<void> remove(Todo todo, String userId) async {
    var snapshot = _firestore.doc('users/$userId/todos/${todo.id}');
    await snapshot.delete();
  }

  Stream<List<TodoChange>> onChanged(String userId) {
    var snapshots = _firestore.collection('users/$userId/todos').onSnapshot;
    return snapshots.map((querySnapshot) {
      return querySnapshot.docChanges().map((docChange) {
        var doc = docChange.doc;
        var todo = Todo.fromJson(doc.data())..id = doc.id;
        var type = _getChangeType(docChange);
        return TodoChange(type, todo);
      }).toList();
    });
  }

  void addNew(String userId) {
    _firestore.collection('users/$userId/todos').add(Todo(false, '').toJson());
  }

  TodoChangeType _getChangeType(DocumentChange docChange) {
    switch (docChange.type) {
      case "added":
        return TodoChangeType.added;
      case "removed":
        return TodoChangeType.removed;
      case "modified":
        return TodoChangeType.modified;
      default:
        return null;
    }
  }
}

class _FirebaseUserImpl implements FirebaseUser {
  final String uid;
  _FirebaseUserImpl(this.uid);
}
