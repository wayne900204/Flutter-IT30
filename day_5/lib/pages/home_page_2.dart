import 'package:flutter/material.dart';

import '../my_router.dart';

class HomePage2 extends StatelessWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: InkWell(
        onTap: ()=> Navigator.pushNamed(context, RouteName.home_page_1),
        child: Center(
          child: Text('home_page2 back to home_page',style: TextStyle(fontSize: 30),textAlign: TextAlign.center,),
        ),
      ),
    );
  }
}
