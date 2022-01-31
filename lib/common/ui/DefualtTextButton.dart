import 'package:flutter/material.dart';

class DefualtButton extends StatelessWidget {


  double width = double.infinity;
      Color color = Colors.amber;
   Widget child;
   Function fun;

   DefualtButton({
     this.width = double.infinity,
     this.color = Colors.amber,
  @required  this.child,
  @required  this.fun,
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
