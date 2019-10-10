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

  void logOut() {
    _auth.signOut();
  }
}

class _FirebaseUserImpl implements FirebaseUser {
  final String uid;
  _FirebaseUserImpl(this.uid);
}

class FlutterTodoService implements TodoService {
  Firestore firestore;

  FlutterTodoService() : firestore = Firestore.instance;

  // Loads todos for the current user. Database is set up as:
  // users/<uid>/todos/<id>
  Future<List<Todo>> getTodos(String userId) async {
    var snapshot = firestore.collection('users').document(userId);
    var collection = snapshot.collection('todos');
    var todosSnapshot = await collection.snapshots().first;
    var todos = todosSnapshot.documents;
    return todos.map((snapshot) {
      return Todo.fromJson(snapshot.data);
    }).toList();
  }
}
