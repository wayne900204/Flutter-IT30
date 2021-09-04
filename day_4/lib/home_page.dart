import 'package:day_4/screens/home_page.dart';
import 'package:day_4/screens/notify_page.dart';
import 'package:day_4/screens/setting_page.dart';
import 'package:day_4/screens/user_profile_page.dart';
import 'package:flutter/material.dart';

import 'AnimationBottomBar.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// the index of pageItem
  /// 畫面的 index
  int pageIndex = 0;
  /// 宣告一個 List，等等要放對應的 Page 進去
  List<Widget> pageItem = [];

  @override
  void initState() {
    super.initState();
    /// 每一頁對應的 Page 是什麼
    pageItem = [HomePage(), NotifyScreen(), UserProfile(), SettingApp()];
  }

  /// Object<BarItem> of List
  /// List 裡面包一個 自定義的物件 BarItem
  final List<BarItemData> barItems = [
    BarItemData("Home", Icons.home, Color(0xFF498AEF)),
    BarItemData("Notify", Icons.notifications_active, Colors.red),
    BarItemData("Profile", Icons.person_outline, Colors.teal),
    BarItemData("Setting", Icons.menu, Colors.purple)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: IndexedStack(
        index: pageIndex,
        children: pageItem,
      ),
      bottomNavigationBar: AnimationBottomBar(
        barItemsData: barItems,
        // animationDuration: const Duration(milliseconds: 500),
        // curves: Curves.easeInOut,
        barStyle: BarStyle(
            fontSize: 20.0, fontWeight: FontWeight.w400, iconSize: 30.0),
        changePageIndex: (int index) {
          /// when bottomBar on Tap will return the bottomBar index
          /// 會回傳被點擊到的 bottomBar index
          setState(() {
            pageIndex = index;
          });
        },
      ),
    );
  }
}
