import 'package:flutter/material.dart';
import 'package:storm/common/colors/colors.dart';

class DefaultButton extends StatelessWidget {
  double width = double.infinity;
  Color color = basicColor;
  Widget child;
  Function fun;

  DefaultButton({
    this.width = double.infinity,
    this.color = basicColor,
    @required this.child,
    @required this.fun,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: MaterialButton(
          height: 45.0,
          minWidth: width,
          color: color,
          child: child,
          onPressed: fun),
    );
  }
}
