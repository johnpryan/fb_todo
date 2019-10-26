import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  static const TextStyle headerStyle =
  TextStyle(fontSize: 32, fontWeight: FontWeight.w600);

  Header(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Column(
        children: [
          Text(
            title,
            style: headerStyle,
          ),
        ],
      ),
    );
  }
}