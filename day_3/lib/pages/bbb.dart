import 'package:flutter/material.dart';

import '../my_route.dart';

class BBB extends StatelessWidget {
  const BBB({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: InkWell(
        onTap: () => Navigator.pushNamed(context, RouteName.aaa),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text, style: TextStyle(fontSize: 30)),
              Text('BBB -> AAA', style: TextStyle(fontSize: 30))
            ],
          ),
        ),
      ),
    );
  }
}
