import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'my_router.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        onGenerateRoute: MyRouter.generateRoute,
        // initialRoute: FirebaseAuth.instance.currentUser ==null? RouteName.loginScreen:RouteName.homePage
        initialRoute: RouteName.bottomBar
    );
  }
}
