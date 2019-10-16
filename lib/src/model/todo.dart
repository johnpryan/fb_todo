import 'dart:async';

import 'package:flutter/cupertino.dart';

class Todo {
  bool _done;
  String _description;
  String id;

  StreamController<void> _controller = StreamController.broadcast();

  Todo(this._done, this._description);

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(json['done'], json['description']);
  }

  factory Todo.fromTodo(Todo other) {
    return Todo(other.done, other.description)..id = other.id;
  }

  Stream get onChanged => _controller.stream;

  set done(bool d) {
    if (_done == d) {
      return;
    }

    _done = d;
    _controller.add(null);
  }

  bool get done => _done;

  set description(String d) {
    if (_description == d) {
      return;
    }

    _description = d;
    _controller.add(null);
  }

  String get description => _description;

  void updateFrom(Todo other) {
    var changed = false;
    if (_done != other.done) {
      _done = other.done;
      changed = true;
    }
    if (_description != other.description) {
      _description = other.description;
      changed = true;
    }
    if (changed) {
      _controller.add(null);
    }
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'done': done,
      'description': description,
    };
  }

  void dispose() {
    _controller.close();
  }
}