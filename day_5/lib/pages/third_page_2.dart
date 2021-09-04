import 'package:flutter/material.dart';
import '../my_router.dart';

class ThirdPage2 extends StatelessWidget {
  const ThirdPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: InkWell(
        // onTap: ()=> Navigator.pushNamed(context, RouteName.home_page_3),
        onTap: ()=> Navigator.of(context,rootNavigator: true).pushNamed(RouteName.third_page_3),
        child: Center(
          child: Text('third_page_2',style: TextStyle(fontSize: 30),),
        ),
      ),
    );
  }
}
