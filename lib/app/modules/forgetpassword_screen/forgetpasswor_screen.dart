import 'package:flutter/material.dart';


class ForgetPasswordScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                'Forget password screen',
                style: Theme.of(context).textTheme.headline1
            ),
          ],
        ),
      ),
    );
  }
}
