import 'package:fb_todo/src/model/todo.dart';
import 'package:flutter/material.dart';

import 'package:fb_todo/src/services/services.dart';
import 'package:flutter/services.dart';

class TodoWidget extends StatefulWidget {
  static const textStyle = TextStyle(fontSize: 16, color: Colors.black);
  final Todo todo;
  final VoidCallback onChanged;

  TodoWidget({
    @required this.todo,
    @required this.onChanged,
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

    focusNode = FocusNode();

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
    if (event is RawKeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        widget.onChanged();
        focusNode.unfocus();
      } else if (event is RawKeyEventDataWeb) {
        if (event.data.keyLabel == 'Enter') {
          widget.onChanged();
          focusNode.unfocus();
        }
      }
    }
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
              cursorColor: Colors.blue,
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
