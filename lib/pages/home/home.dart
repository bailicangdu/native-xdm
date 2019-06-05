import 'package:flutter/material.dart';
import 'package:xiaodemo/assets/icons.dart';
import 'package:xiaodemo/utils/event_center.dart';
import './children/home_screen/home_screen.dart';
import './children/discover/discover.dart';
import './children/orders/orders.dart';
import './children/personal/personal.dart';

class BottomBarItem {
  BottomBarItem({ this.title, this.name, this.icon, this.widget });
  final String title;
  final String name;
  final Icon icon;
  final Widget widget;
}

final List<BottomBarItem> _bottomBarItems = <BottomBarItem>[
  BottomBarItem(title: '首页', name: 'home', icon: Icon(XDIcons.home), widget: HomeScreen()),
  BottomBarItem(title: '发现', name: 'discover', icon: Icon(XDIcons.discover), widget: Discover()),
  BottomBarItem(title: '订单', name: 'orders', icon: Icon(XDIcons.orders), widget: Orders()),
  BottomBarItem(title: '我的', name: 'personal', icon: Icon(XDIcons.personal), widget: Personal()),
];


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _currentIndex = 0;

  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    eventCenter.on('switchTab', _onSwitchTab);
  }

  void _onTapBottomBar(int index) {
    _pageController.jumpToPage(index); 
  }

  void _onSwitchTab(Event e) {
    if (e.data == null) return;
    final String name = e.data;
    for (var i = 0; i < _bottomBarItems.length; i++) {
      if (name == _bottomBarItems[i].name) {
        _pageController.jumpToPage(i);
      }
    }
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: _bottomBarItems.map((BottomBarItem bottomBarItem) {
          return bottomBarItem.widget;
        }).toList(),
        physics: NeverScrollableScrollPhysics(), // 禁止滑动
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomBarItems.map((BottomBarItem bottomBarItem) {
          return BottomNavigationBarItem(icon: bottomBarItem.icon, title: Text(bottomBarItem.title));
        }).toList(),
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed, // 大于3个底部导航需要设置fixed定位
        onTap: _onTapBottomBar,
        selectedFontSize: 12.0, // 字体默认12.0，选中时放大为14.0
      ),
    );
  }

  @override
  void dispose() {
    eventCenter.off('switchTab', _onSwitchTab);
    super.dispose();
  }
}
