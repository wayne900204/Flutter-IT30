import 'package:day_5/route_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'pages/AAA.dart';
import 'pages/BBB.dart';
import 'pages/home_page_1.dart';
import 'pages/home_page_2.dart';
import 'pages/second_page.dart';
import 'pages/third_page_1.dart';
import 'pages/third_page_2.dart';
import 'pages/third_page_3.dart';
import 'routes/bottom_bar_route_page.dart';

class RouteName {
  static const String bottomBar = 'bottomBar';
  static const String home_page_1 = 'home_page_1';
  static const String home_page_2 = 'home_page_2';
  static const String second_page = 'second_page';
  static const String third_page_1 = 'third_page_1';
  static const String third_page_2 = 'third_page_2';
  static const String third_page_3 = 'third_page_3';
  static const String aaa = 'aaa';
  static const String bbb = 'bbb';
}

class MyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.bottomBar:
        var bottomNavigationIndex = 0;
        if (settings.arguments != null) {
          bottomNavigationIndex = settings.arguments as int;
        }
        return NoAnimRouteBuilder(
            new BottomBarRoutePage(pageIndex: bottomNavigationIndex));
      case RouteName.aaa:
        return NoAnimRouteBuilder(new AAA());
      case RouteName.bbb:
        return NoAnimRouteBuilder(new BBB());
      case RouteName.third_page_1:
        return NoAnimRouteBuilder(new ThirdPage1());
      case RouteName.third_page_2:
        return NoAnimRouteBuilder(new ThirdPage2());
      case RouteName.third_page_3:
        return NoAnimRouteBuilder(new ThirdPage3());
      case RouteName.home_page_1:
        return NoAnimRouteBuilder(new HomePage1());
      case RouteName.home_page_2:
        return NoAnimRouteBuilder(new HomePage2());
      case RouteName.second_page:
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
