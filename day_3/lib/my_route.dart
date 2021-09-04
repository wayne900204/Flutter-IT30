import 'package:day_3/pages/aaa.dart';
import 'package:day_3/pages/bbb.dart';
import 'package:day_3/route_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteName {
  static const String aaa = 'aaa';
  static const String bbb = 'bbb';
}

class MyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.aaa:
        return NoAnimRouteBuilder(new AAA());
      case RouteName.bbb:
        String text = settings.arguments! as String;
        return NoAnimRouteBuilder(new BBB(
          text: text,
        ));
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
