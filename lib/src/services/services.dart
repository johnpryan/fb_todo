abstract class AuthService {
  Future<FirebaseUser> signIn();
  void logOut();
}

abstract class FirebaseUser {
  String get uid;
}

abstract class TodoService {
  Future<List<Todo>> getTodos(String  userId);
}

class Todo {
  bool done;
  String description;

  Todo(this.description) : done = false;

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(json['description']);
  }
}