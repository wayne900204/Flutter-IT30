import 'package:flutter/material.dart';

import '../my_router.dart';

class BBB extends StatelessWidget {
  const BBB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: InkWell(
        onTap: ()=> Navigator.pushNamed(context, RouteName.aaa),
        child: Center(
          child: Text('Page B',style: TextStyle(fontSize: 30),),
        ),
      ),
    );
  }
}
