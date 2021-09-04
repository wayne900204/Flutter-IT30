import 'package:flutter/material.dart';

import '../my_router.dart';
import '../pages/AAA.dart';
import 'navigator_home_page.dart';
import 'navigator_third_page.dart';

class BottomBarRoutePage extends StatefulWidget {
  const BottomBarRoutePage({required this.pageIndex});
  /// initialize page index
  final int pageIndex;

  @override
  _BottomBarRoutePageState createState() => _BottomBarRoutePageState();
}

class _BottomBarRoutePageState extends State<BottomBarRoutePage> {
  /// page index
  late int _pageIndex;
  /// GlobalKey of navigator
  Map<int, GlobalKey> navigatorKeys = {
    0: GlobalKey(),
    1: GlobalKey(),
    2: GlobalKey(),
    3: GlobalKey(),
  };

  @override
  void initState() {
    _pageIndex = widget.pageIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: WillPopScope(
        onWillPop: () async {
          /// maybePop the current index context
          return !await Navigator.maybePop(
              navigatorKeys[_pageIndex]!.currentState!.context);
        },
        child: IndexedStack(
          index: _pageIndex,
          children: <Widget>[
            NavigatorHomePage(navigatorKey: navigatorKeys[0]!),
            SizedBox(), // 整個換頁。不要底部的 bottomBar
            NavigatorThirdPage(
                // 這邊是因為跳下一夜的時候不希望底下還有 bottomBar
                navigatorKey: navigatorKeys[2]!),
            AAA()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
        items: <BottomNavigationBarItem>[
          /// when index = 0, after the page A is changed to page B, then changed the index to 1, and changed the index back to 0, the screen page will be B page,
          /// And there will be bottomNavigationBar in the process
          /// 在 index  = 0 時，把A 畫面跳到 B 畫面後，把 index 改成 1，再把 index 改回 1，此時畫面一會在 B 畫面，並且在過程中都會有 bottomNavigationBar 存在
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            title: Text('c'),
          ),

          /// When index = 1, after the page A is changed to screen B, there'll be no bottomNavigationBar under the B page,
          /// and then back to the A page, there will be a bottomNavigationBar at the bottom of the A page
          /// 在 index  = 1 時，把整夜 bottomBar 切換成 A 畫面跳到 B 畫面後，B 畫面的下方不會有 bottomNavigationBar，此時再跳回道 A 畫面，A 畫面下方會有 BottomBar
          BottomNavigationBarItem(
            icon: Icon(Icons.add_to_photos_rounded),
            title: Text('b'),
          ),

          /// after the page changed, index changed, will not remember the page when you left, and the page will be the same every time when you re-enter index = 2.
          /// 跳頁後，更換 index，並不會記住離開時的畫面，每次重新進入 index = 2 時，畫面都會一樣。
          BottomNavigationBarItem(
            icon: Icon(Icons.access_alarm),
            title: Text('b'),
          ),
          /// normal behavior
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('c'),
          ),
        ],
        currentIndex: _pageIndex,
        onTap: (index) {
          setState(() {
            // index  0  1  2  3
            /// when index == 1 then change to another Widget.
            /// index == 1 時，代表他從 bottom_bar_route_page 跳到 新的畫面
            if (index == 1) {
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteName.second_page, (route) => false);
            } else if (index == 2) {
              /// create a new GlobalKey, and the page will be the same every time when you re-enter
              navigatorKeys[2] = GlobalKey();
              _pageIndex = index;
            } else {
              _pageIndex = index;
            }
          });
        },
      ),
    );
  }
}
