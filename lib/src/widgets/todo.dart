import 'package:fb_todo/src/model/todo.dart';
import 'package:flutter/material.dart';

class TodoWidget extends StatefulWidget {
  static const textStyle = TextStyle(fontSize: 16, color: Colors.black);
  final Todo todo;
  final VoidCallback onChanged;
  final VoidCallback onDismissed;

  TodoWidget({
    @required this.todo,
    @required this.onChanged,
    @required this.onDismissed,
  }) : super(key: ValueKey(todo.id));

  @override
  _TodoWidgetState createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  TextEditingController textController;
  FocusNode focusNode;

  @override
  void initState() {
    super.initState();

    widget.todo.onChanged.listen((_) {
      // Set the text controller's text to the new value. This will unfocus the
      // text input.
      if (textController.text != widget.todo.description) {
        setState(() {
          textController.text = widget.todo.description;
        });
      } else {
        // update the checkbox if it's been updated.
        setState(() {});
      }
    });

    focusNode = FocusNode()
      // Emit a change event when this text field is unfocused
      ..addListener(() {
        widget.onChanged();
      });

    textController = TextEditingController()
      ..text = widget.todo.description
      ..addListener(() {
        setState(() {
          if (widget.todo.description == textController.text) {
            return;
          }
          widget.todo.description = textController.text;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.todo.id),
      background: Container(
        color: Colors.blue,
      ),
      onDismissed: (direction) {
        widget.onDismissed();
      },
      child: Row(
        children: [
          Checkbox(
            value: widget.todo.done,
            onChanged: (checked) {
              setState(() {
                widget.todo.done = checked;
              });
              widget.onChanged();
            },
          ),
          Expanded(
            child: TextField(
              controller: textController,
              focusNode: focusNode,
              style: TodoWidget.textStyle,
              // Emit a change event when this text field is submitted (e.g.
              // the user presses enter on web or "done" on mobile)
              onSubmitted: (_) {
                widget.onChanged();
                focusNode.unfocus();
              },
              cursorColor: Colors.blue,
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
