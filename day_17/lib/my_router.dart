import 'package:day_17/home_page.dart';
import 'package:day_17/route_animation.dart';
import 'package:day_17/second_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class RouteName {
  static const String homePage = 'homePage';
  static const String secondPage = 'secondPage';

}

class MyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.homePage:
        return NoAnimRouteBuilder(
            new HomePage());
      case RouteName.secondPage:
        return NoAnimRouteBuilder(new SecondPage());
      default:
        return CupertinoPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
