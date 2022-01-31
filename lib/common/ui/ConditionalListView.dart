import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';

class ConditionalListView extends StatelessWidget {
  bool condition;
  List<Widget> itemBuilder;

  ConditionalListView({this.condition, this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
      condition: condition ,
      builder:(context) {
        return ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => itemBuilder[index],
          separatorBuilder: (context, index) => SizedBox(height: 10.0,),
          itemCount: itemBuilder.length,
        );
      } ,
      fallback: (context) => Container( height: 100,child: Center(child: Text('No Posts From You Until Now'),)),
    );
  }
}
