import 'package:day_25/helper/helper.dart';
import 'package:day_25/widgets/flutter_head.dart';
import 'package:day_25/widgets/promo_text.dart';
import 'package:flutter/material.dart';

import '../example_data.dart';
import '../helper/colors.dart';
import 'discount_card.dart';
import 'ficon_button.dart';
import 'header_clip.dart';

/// SliverAppBar
class FAppBar extends SliverAppBar {
  final PageData data;
  final BuildContext context;
  final bool isCollapsed;
  final double? expandedHeight;
  final double collapsedHeight;
  final TabController tabController;
  final void Function(bool isCollapsed) onCollapsed;
  final void Function(int index) onTap;

  FAppBar({
    required this.data,
    required this.context,
    required this.isCollapsed,
    required this.expandedHeight, // 展開的高度。
    required this.collapsedHeight,
    required this.onCollapsed,
    required this.onTap,
    required this.tabController,
  }) : super(
            elevation: 4.0,
            pinned: true,
            forceElevated: true,
            expandedHeight: expandedHeight);

  /// super() 是用來繼承父親 Widget 裡面的屬性 or function
  @override
  Color? get backgroundColor => scheme.surface;

  /// SliverBar 的 leading
  @override
  Widget? get leading {
    return FIconButton(
      iconData: Icons.arrow_back,
      onPressed: () {},
    );
  }

  /// SliverAppBar 的 actions
  @override
  List<Widget>? get actions {
    return [
      FIconButton(iconData: Icons.share_outlined, onPressed: () {}),
      FIconButton(iconData: Icons.info_outline, onPressed: () {}),
    ];
  }

  /// SliverAppBar Title 慢慢出現的動畫，只有在縮小才看得到，subTitle 也寫在這。
  @override
  Widget? get title {
    var textTheme = Theme.of(context).textTheme;
    // AnimatedOpacity => https://api.flutter.dev/flutter/widgets/AnimatedOpacity-class.html
    return AnimatedOpacity(
      // 0 == invisible, 1 == visible
      opacity: this.isCollapsed ? 0 : 1, // 判斷 SliverAppBar 是展開還是縮小。
      duration: const Duration(milliseconds: 250),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "癮茶",
            style: textTheme.subtitle1?.copyWith(color: scheme.onSurface),
            strutStyle: Helper.buildStrutStyle(textTheme.subtitle1),
          ),
          const SizedBox(height: 4.0),
          Text(
            data.deliverTime,
            style: textTheme.caption?.copyWith(color: scheme.primary),
            strutStyle: Helper.buildStrutStyle(textTheme.caption),
          ),
        ],
      ),
    );
  }

  /// AppBar 的 bottom 不會被縮小。
  @override
  PreferredSizeWidget? get bottom {
    return PreferredSize(
      preferredSize: const Size.fromHeight(48),
      child: Container(
        color: scheme.surface,
        child: TabBar(
          isScrollable: true,
          // 是否可以滾動
          controller: tabController,
          // https://api.flutter.dev/flutter/material/TabController-class.html
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          indicatorColor: scheme.primary,
          // tabBar 下面一條線的顏色
          labelColor: scheme.primary,
          // 被選到標籤顏色
          unselectedLabelColor: scheme.onSurface,
          // 為被選到的顏色
          indicatorWeight: 3.0,
          // 下面標籤的高度
          tabs: data.categories.map((e) {
            return Tab(text: e.title);
          }).toList(),
          // 想要把 list 裡面的 data 轉換成 Widget
          onTap: onTap,
        ),
      ),
    );
  }

  /// 只有展開才看得到的 FlexibleSpaceBar 屬性
  @override
  Widget? get flexibleSpace {
    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        // 現在整塊 flexibleSpace 的高度
        final top = constraints.constrainHeight();
        final collapsedHight =
            MediaQuery.of(context).viewPadding.top + kToolbarHeight + 48;
        // 尚未展開的 flexibleSpace 高度。
        WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
          // 此時如果立刻執行下面的代碼，是獲取不到 BuildContext，因為 widget 還沒有完成繪製
          // addPostFrameCallback 是 StatefulWidget 渲染結束的回調，只會被調用一次，之後 StatefulWidget 需要刷新 UI 也不會被調用
          onCollapsed(collapsedHight != top); // 利用 callback 轉換傳遞現在的 isCollapsed
        });

        return FlexibleSpaceBar(
          collapseMode: CollapseMode.pin, // 展開模式
          background: Column(
            children: [
              Stack(
                children: [
                  PromoText(title: data.bannerText), // 粉紅色部分（有點類似廣告）(宣傳文字)
                  FlutterHead(), // flutter 頭像
                  Column(
                    children: [
                      HeaderClip(data: data, context: context),
                      // 餐廳上方圖片，有形狀的那個。
                      SizedBox(height: 90),
                    ],
                  ),
                ],
              ),
              DiscountCard(
                title: data.optionalCard.title,
                subtitle: data.optionalCard.subtitle,
              ),
            ],
          ),
        );
      },
    );
  }
}
