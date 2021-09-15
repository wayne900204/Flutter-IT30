import 'package:day_25/widgets/category_section.dart';
import 'package:day_25/widgets/fappbar.dart';
import 'package:flutter/material.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'example_data.dart';
import 'helper/colors.dart';

/// 如果 AnimationController 有很多個則使用 TickerProviderStateMixin 代替 SingleTickerProviderStateMixin
/// SingleTickerProvider 提供給 Animation 裡面的 vsync
/// TabController => https://api.flutter.dev/flutter/material/TabController-class.html
/// TabBar => https://api.flutter.dev/flutter/material/TabBar-class.html
/// Animation 教學文章  => https://www.jianshu.com/p/3f2ae714f804
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  /// 使否展開
  bool isCollapsed = false;
  late AutoScrollController scrollController;
  late TabController tabController;

  /// 展開高度
  final double expandedHeight = 500.0;

  /// 頁面資料
  final PageData data = ExampleData.data;

  /// 折疊高度
  final double collapsedHeight = kToolbarHeight;

  /// Instantiate RectGetter
  final wholePage = RectGetter.createGlobalKey();
  Map<int, dynamic> itemKeys = {};

  /// prevent animate when press on tab bar
  /// 避免當我們點擊 tab bar 時，動畫還在動，還在計算。
  bool pauseRectGetterIndex = false;

  @override
  void initState() {
    /// tabController 出使話
    tabController = TabController(length: data.categories.length, vsync: this);
    scrollController = AutoScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

  /// 取得螢幕可看到的 index 有哪些
  List<int> getVisibleItemsIndex() {
    // get ListView Rect
    Rect? rect = RectGetter.getRectFromKey(wholePage);
    List<int> items = [];
    if (rect == null) return items;
    itemKeys.forEach((index, key) {
      Rect? itemRect = RectGetter.getRectFromKey(key);
      if (itemRect == null) return;
      // y 軸座越大，代表越下面
      // 如果 item 上方的座標 比 listView 的下方的座標 的位置的大 代表不在畫面中。
      // bottom meaning => The offset of the bottom edge of this widget from the y axis.
      // top meaning => The offset of the top edge of this widget from the y axis.
      if (itemRect.top > rect.bottom) return;
      // 如果 item 下方的座標 比 listView 的上方的座標 的位置的小 代表不在畫面中。
      if (itemRect.bottom < rect.top) return;
      items.add(index);
    });

    return items;
  }

  /// 用來傳遞給 appBar 的 function
  void onCollapsed(bool value) {
    if (this.isCollapsed == value) return;
    setState(() => this.isCollapsed = value);
  }

  /// true表示消費掉當前通知不再向上一级NotificationListener傳遞通知，false則會再向上一级NotificationListener傳遞通知；
  bool onScrollNotification(ScrollNotification notification) {
    // 不想讓上一層知道，無需做動作。
    if (pauseRectGetterIndex) return true;
    // 取得標籤的長度
    int lastTabIndex = tabController.length - 1;
    // 取得現在畫面上可以看得到的 Items Index
    List<int> visibleItems = getVisibleItemsIndex();

    bool reachLastTabIndex = visibleItems.isNotEmpty &&
        visibleItems.length <= 2 &&
        visibleItems.last == lastTabIndex;
    // 如果到達最後一個 index 就跳轉到最後一個 index
    if (reachLastTabIndex) {
      tabController.animateTo(lastTabIndex);
    } else {
      // 取得畫面中的 item 的中間值。例：2,3,4 中間的就是 3
      // 求一個數字列表的乘積
      int sumIndex = visibleItems.reduce((value, element) => value + element);
      // 5 ~/ 2 = 2  => Result is an int 取整數
      int middleIndex = sumIndex ~/ visibleItems.length;
      if (tabController.index != middleIndex)
        tabController.animateTo(middleIndex);
    }
    return false;
  }

  /// TabBar 的動畫。
  void animateAndScrollTo(int index) {
    pauseRectGetterIndex = true;
    tabController.animateTo(index);
    // Scroll 到 index 並使用 begin 的模式，結束後，把 pauseRectGetterIndex 設為 false 暫停執行 ScrollNotification
    scrollController
        .scrollToIndex(index, preferPosition: AutoScrollPosition.begin)
        .then((value) => pauseRectGetterIndex = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, //是否延伸body至顶部。
      backgroundColor: scheme.background,
      body: RectGetter(
        key: wholePage,

        /// NotificationListener 是一個由下往上傳遞通知，true 阻止通知、false 傳遞通知，確保指監聽滾動的通知
        /// ScrollNotification => https://www.jianshu.com/p/d80545454944
        child: NotificationListener<ScrollNotification>(
          child: buildSliverScrollView(),
          onNotification: onScrollNotification,
        ),
      ),
    );
  }

  /// CustomScrollView + SliverList + SliverAppBar
  Widget buildSliverScrollView() {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        buildAppBar(),
        buildBody(),
      ],
    );
  }

  /// AppBar
  SliverAppBar buildAppBar() {
    return FAppBar(
      data: data,
      context: context,
      expandedHeight: expandedHeight,
      // 期許展開的高度
      collapsedHeight: collapsedHeight,
      // 折疊高度
      isCollapsed: isCollapsed,
      onCollapsed: onCollapsed,
      tabController: tabController,
      onTap: (index) => animateAndScrollTo(index),
    );
  }

  /// Body
  SliverList buildBody() {
    return SliverList(
      delegate: SliverChildListDelegate(List.generate(
        data.categories.length,
        (index) {
          // 建立 itemKeys 的 Key
          itemKeys[index] = RectGetter.createGlobalKey();
          return buildCategoryItem(index);
        },
      )),
    );
  }

  /// ListItem
  Widget buildCategoryItem(int index) {
    Category category = data.categories[index];
    return RectGetter(
      // 傳GlobalKey，之後可以 RectGetter.getRectFromKey(key) 的方式獲得 Rect
      key: itemKeys[index],
      child: AutoScrollTag(
        key: ValueKey(index),
        index: index,
        controller: scrollController,
        child: CategorySection(category: category),
      ),
    );
  }
}
