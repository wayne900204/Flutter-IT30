import 'package:flutter/material.dart';

import 'my_router.dart';
class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: InkWell(
        onTap: ()=> Navigator.pushNamed(context, RouteName.homePage),
        child: Center(
          child: Text('Go to Home',style: TextStyle(fontSize: 30),),
        ),
      ),
    );
  }
}
