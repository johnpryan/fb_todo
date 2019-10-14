import 'package:flutter/material.dart';

import 'package:fb_todo/src/services/services.dart';

class TodoWidget extends StatefulWidget {
  static const textStyle = TextStyle(fontSize: 16, color: Colors.black);
  final Todo todo;

  TodoWidget(this.todo);

  @override
  _TodoWidgetState createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {

  TextEditingController textController;

  @override
  void initState() {
    super.initState();

    textController = TextEditingController()
      ..text = widget.todo.description
      ..addListener(() {
        setState(() {
          widget.todo.description = textController.text;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: widget.todo.done,
          onChanged: (checked) {
            setState(() {
              widget.todo.done = checked;
            });
          },
        ),
        Expanded(
          child: TextField(
            controller: textController,
            style: TodoWidget.textStyle,
            cursorColor: Colors.blue,
            decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
