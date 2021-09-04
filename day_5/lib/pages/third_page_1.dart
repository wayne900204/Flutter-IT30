import 'package:flutter/material.dart';

import '../my_router.dart';

class ThirdPage1 extends StatelessWidget {
  const ThirdPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: InkWell(
        onTap: ()=> Navigator.pushNamed(context, RouteName.third_page_2),
        child: Center(
          child: Text('third_page_1,\n will not remember the page',style: TextStyle(fontSize: 30),textAlign: TextAlign.center,),
        ),
      ),
    );
  }
}
