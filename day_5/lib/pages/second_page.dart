import 'package:flutter/material.dart';

import '../my_router.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: InkWell(
        // onTap: ()=> Navigator.pushNamed(context, RouteName.bbb),
        onTap: () => Navigator.pushNamedAndRemoveUntil(
            context, RouteName.bottomBar, (route) => false),
        child: Center(
          child: Text('second_page',style: TextStyle(fontSize: 30),),
        ),
      ),
    );
  }
}
