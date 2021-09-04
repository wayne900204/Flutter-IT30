import 'package:flutter/material.dart';

import 'my_route.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // 告知我的路由器是哪個
        onGenerateRoute: MyRouter.generateRoute,
        // 告知 App 開啟後第一個畫面是什麼
        initialRoute: RouteName.aaa);
  }
}
