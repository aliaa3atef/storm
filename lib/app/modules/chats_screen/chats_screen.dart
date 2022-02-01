
import 'package:flutter/material.dart';
import 'package:storm/common/ui/DefualtTextButton.dart';
import 'package:storm/common/ui/methods.dart';

class ChatsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.wb_sunny))
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(
              'chats screen',
              style: Theme.of(context).textTheme.headline1
            ),
            DefaultButton(child: Text('Logout'), fun: (){
              Logout(context);
            })
          ],
        ),
      ),
    );
  }
}
