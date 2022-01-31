import 'package:flutter/material.dart';

class CaptionText extends StatelessWidget {
  String text;
  CaptionText({this.text});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 12.0),
    );
  }
}
