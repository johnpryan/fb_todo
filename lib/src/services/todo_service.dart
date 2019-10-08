import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TodoService {
  Firestore firestore;

  TodoService() : firestore = Firestore.instance;

  // Loads todos for the current user. Database is set up as:
  // users/<uid>/todos/<id>
  Future<List<Todo>> getTodos(FirebaseUser user) async {
    var snapshot = firestore.collection('users').document(user.uid);
    var collection = snapshot.collection('todos');
    var todosSnapshot = await collection.snapshots().first;
    var todos = todosSnapshot.documents;
    return todos.map((snapshot) {
      return Todo.fromJson(snapshot.data);
    }).toList();
  }
}

class Todo {
  bool done;
  String description;

  Todo(this.description) : done = false;

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(json['description']);
  }
}
