import 'package:flutter/material.dart';

import '../my_router.dart';

class ThirdPage3 extends StatelessWidget {
  const ThirdPage3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: InkWell(
        onTap: ()=> Navigator.pushNamed(context, RouteName.bottomBar),
        child: Center(
          child: Text('third_page_3',style: TextStyle(fontSize: 30),),
        ),
      ),
    );
  }
}
