import 'package:flutter/material.dart';

import '../my_router.dart';

class AAA extends StatelessWidget {
  const AAA({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: InkWell(
        onTap: ()=> Navigator.pushNamed(context, RouteName.bbb),
        child: Center(
          child: Text('Page A',style: TextStyle(fontSize: 30),),
        ),
      ),
    );
  }
}
