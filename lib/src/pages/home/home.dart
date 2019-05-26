import 'package:flutter/material.dart';
import 'package:xiaodemo/src/assets/icons.dart';
import './children/home_screen/home_screen.dart';
import './children/discover/discover.dart';
import './children/orders/orders.dart';
import './children/personal/personal.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _navigationBarItems = const <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(XDIcons.home), title: Text('首页')),
    BottomNavigationBarItem(icon: Icon(XDIcons.discover), title: Text('发现')),
    BottomNavigationBarItem(icon: Icon(XDIcons.orders), title: Text('订单')),
    BottomNavigationBarItem(icon: Icon(XDIcons.personal), title: Text('我的')),
  ];

  int _currentIndex = 0;

  List<Widget> _screenList = [HomeScreen(), Discover(), Orders(), Personal()];

  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  _onTapBottomBar(int index) {
    _pageController.jumpToPage(index);
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
        children: _screenList,
        physics: NeverScrollableScrollPhysics(), // 禁止滑动
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _navigationBarItems,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed, // 大于3个底部导航需要设置fixed定位
        onTap: _onTapBottomBar,
        selectedFontSize: 12.0, // 字体默认12.0，选中时放大为14.0
      ),
    );
  }
}