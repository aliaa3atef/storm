import 'package:flutter/material.dart';

class SubTitleText extends StatelessWidget {
  String text;
  SubTitleText({this.text});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
      ),

    );
  }
}