import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {

  final String text ;
  TitleText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.headline1,
    );
  }
}
