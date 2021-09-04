import 'package:flutter/material.dart';

import '../my_router.dart';

class NavigatorHomePage extends StatelessWidget {
  NavigatorHomePage({required this.navigatorKey});

  final GlobalKey navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (RouteSettings settings) =>
          MyRouter.generateRoute(settings),
      initialRoute: RouteName.home_page_1,
    );
  }
}
