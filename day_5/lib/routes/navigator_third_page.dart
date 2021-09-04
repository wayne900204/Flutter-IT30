import 'package:flutter/material.dart';

import '../my_router.dart';

class NavigatorThirdPage extends StatelessWidget {
  NavigatorThirdPage({required this.navigatorKey});

  final GlobalKey navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (RouteSettings settings) =>
          MyRouter.generateRoute(settings),
      initialRoute: RouteName.third_page_1,
    );
  }
}
