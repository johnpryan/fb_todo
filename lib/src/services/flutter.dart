import 'package:fb_todo/src/model/todo.dart';
import 'package:firebase_auth/firebase_auth.dart' hide FirebaseUser;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'services.dart';

class FlutterAuthService implements AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> signIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    var googleAuth = await googleUser.authentication;

    var credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    var user = (await _auth.signInWithCredential(credential)).user;
    return _FirebaseUserImpl(user.uid);
  }

  Future signOut() async {
    await _auth.signOut();
  }
}

class _FirebaseUserImpl implements FirebaseUser {
  final String uid;
  _FirebaseUserImpl(this.uid);
}

class FlutterTodoService implements TodoService {
  Firestore firestore;

  FlutterTodoService() : firestore = Firestore.instance;

  Future<void> add(String userId) async {
    await firestore.collection('users/$userId/todos').add(Todo(false, '').toJson());
  }

  Future<void> update(Todo todo, String userId) async {
    var snapshot = firestore.document('users/$userId/todos/${todo.id}');
    await snapshot.updateData(todo.toJson());
  }

  Future<void> remove(Todo todo, String userId) async {
    var snapshot = firestore.document('users/$userId/todos/${todo.id}');
    await snapshot.delete();
  }

  Stream<List<TodoChange>> changes(String userId) {
    var snapshots = firestore.collection('users/$userId/todos').snapshots();
    return snapshots.map((querySnapshot) {
      return querySnapshot.documentChanges.map((docChange) {
        var doc = docChange.document;
        var todo = Todo.fromJson(doc.data)..id = doc.documentID;
        var type = _getChangeType(docChange);
        return TodoChange(type, todo);
      }).toList();
    });
  }

  TodoChangeType _getChangeType(DocumentChange docChange) {
    switch (docChange.type) {
      case DocumentChangeType.added:
        return TodoChangeType.added;
      case DocumentChangeType.modified:
        return TodoChangeType.modified;
      case DocumentChangeType.removed:
        return TodoChangeType.removed;
      default:
        return null;
    }
  }
}
