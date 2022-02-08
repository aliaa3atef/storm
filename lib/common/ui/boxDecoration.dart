import 'package:flutter/material.dart';

class ContainerUI extends StatelessWidget{

  final Widget child;
  final Color color;
  final double radius;
  final BoxBorder border;
  final Gradient gradient;

  const ContainerUI({this.color, this.radius, this.border, this.gradient, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
        boxShadow: [
          BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
        ],
        border: border ?? Border.all(color: Theme.of(context).focusColor.withOpacity(0.05)),
        gradient: gradient,
      ),
      child: child ,
    );
  }

}