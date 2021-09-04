import 'package:flutter/material.dart';

import '../my_router.dart';

class HomePage1 extends StatelessWidget {
  const HomePage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: InkWell(
        onTap: ()=> Navigator.pushNamed(context, RouteName.home_page_2),
        child: Center(
          child: Text('home_page -> home_page2,\nwill remember the page',style: TextStyle(fontSize: 30),textAlign: TextAlign.center,),
        ),
      ),
    );
  }
}
