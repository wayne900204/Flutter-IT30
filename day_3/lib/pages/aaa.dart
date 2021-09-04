import 'package:flutter/material.dart';

import '../my_route.dart';

class AAA extends StatelessWidget {
  const AAA({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: InkWell(
        onTap: () => Navigator.pushNamed(context, RouteName.bbb,
            arguments: '注意，這邊只能傳一個參數，如果想要傳多個參數，請自己寫個物件包起來'),
        child: Center(
          child: Text(
            'AAA => BBB',
            style: TextStyle(fontSize: 30),
          ),
        ),
      ),
    );
  }
}
