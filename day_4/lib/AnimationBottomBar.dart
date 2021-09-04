import 'package:flutter/material.dart';

class AnimationBottomBar extends StatefulWidget {
  /// get data of List<BarItem>
  /// 取得 BarItem 的資料
  final List<BarItemData> _barItemsData;

  /// get animation duration time
  /// 取得 animation 的延遲時間
  final Duration _animationDuration;

  /// get data of List<BarItem>
  /// 取得 BarItem 的資料
  final BarStyle _barStyle;

  /// callBack will return the index of the bottombar that was clicked
  /// callBack 回傳被點擊到的 index
  final void Function(int index) _changePageIndex;

  /// animation
  /// 動畫的效果
  final Curve _curves;

  const AnimationBottomBar(
      {Key? key,
      required List<BarItemData> barItemsData,
      Duration animationDuration = const Duration(milliseconds: 500),
      Curve curves = Curves.easeInOut,
      required BarStyle barStyle,
      required Function(int index) changePageIndex})
      : _barItemsData = barItemsData,
        _animationDuration = animationDuration,
        _barStyle = barStyle,
        _curves = curves,
        _changePageIndex = changePageIndex,
        super(key: key);

  @override
  _AnimationBottomBarState createState() => _AnimationBottomBarState();
}

class _AnimationBottomBarState extends State<AnimationBottomBar>
    with TickerProviderStateMixin {
  /// init selectedBarIndex = 0;
  /// 初始化 selectedBarIndex = 0;
  int selectedBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildBarItems()),
      ),
    );
  }

  /// save the single data of barItemsData into the List
  /// 將 barItemsData 的單筆資料存入 List 裡面
  List<Widget> _buildBarItems() {
    /// init _barItem List
    List<Widget> _barItems = [];
    for (int i = 0; i < widget._barItemsData.length; i++) {
      BarItemData item = widget._barItemsData[i];
      bool isSelected = selectedBarIndex == i;
      _barItems.add(_customBarItem(i, isSelected, item));
    }
    return _barItems;
  }

  /// build CustomBarItem in BottomNavigatorBar
  /// 建立客製化的 BarItem 樣式
  InkWell _customBarItem(int i, bool isSelected, BarItemData item) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        setState(() {
          selectedBarIndex = i;
          widget._changePageIndex(selectedBarIndex);
        });
      },
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        duration: widget._animationDuration,
        decoration: BoxDecoration(
            color:
                isSelected ? item.color.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        child: Row(
          children: <Widget>[
            Icon(
              item.iconData,
              color: isSelected ? item.color : Colors.black,
              size: widget._barStyle.iconSize,
            ),
            SizedBox(width: 10.0),
            AnimatedSize(
              duration: widget._animationDuration,
              curve: widget._curves,
              vsync: this,
              child: Text(
                isSelected ? item.text : "",
                style: TextStyle(
                    color: item.color,
                    fontWeight: widget._barStyle.fontWeight,
                    fontSize: widget._barStyle.fontSize),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BarStyle {
  final double fontSize, iconSize;
  final FontWeight fontWeight;

  BarStyle(
      {this.fontSize = 18.0,
      this.iconSize = 32.0,
      this.fontWeight = FontWeight.w600});
}

class BarItemData {
  final String text;
  final IconData iconData;
  final Color color;

  BarItemData(this.text, this.iconData, this.color);
}
