import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TodoService {
  Firestore firestore;

  TodoService() : firestore = Firestore.instance;

  Future<List<Todo>> getTodos(FirebaseUser user) async {
    var snapshot = firestore.collection('users').document(user.uid);
    print(user.uid);
    print(snapshot);
    var collection = snapshot.collection('todos');
    print(collection);
    var todosSnapshot = await collection.snapshots().first;
    print(todosSnapshot);
    var todos = todosSnapshot.documents;
    print(todos);
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
