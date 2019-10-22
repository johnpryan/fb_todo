import 'package:fb_todo/src/model/todo.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

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
      ..addListener(() {
        // Emit a change event when this text field is unfocused
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

  // Key handling is only required to prevent extra firebase writes and
  // due to onEditingComplete not firing on the web.
  // https://github.com/flutter/flutter/issues/35435
  void _handleKey(RawKeyEvent event) {
    if (event is RawKeyUpEvent && event.data.keyLabel == 'Enter') {
      widget.onChanged();
      focusNode.unfocus();
    }
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
                widget.onChanged();
              });
            },
          ),
          Expanded(
            child: RawKeyboardListener(
              focusNode: focusNode,
              onKey: _handleKey,
              child: TextField(
                controller: textController,
                style: TodoWidget.textStyle,
                onEditingComplete: () {
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
          ),
        ],
      ),
    );
  }
}
