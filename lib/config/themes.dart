import 'package:flutter/material.dart';

// 主题色 f9b661

class XDTheme {
  const XDTheme(this.name, this.themeData);
  final String name;
  final ThemeData themeData;
}

final mainTheme = XDTheme('yellow', _buildMianTheme());


ThemeData _buildMianTheme() {
  const Color primaryColor = Color(0xFF0085ff); 
  const Color primaryColorDart = Color(0xFF065196);
  const Color primaryColorLight = Color(0xFF4daaff);

  final ThemeData data = ThemeData(
    // platform: TargetPlatform.iOS,
    primaryColor: primaryColor, // App主要部分的背景色（ToolBar,Tabbar等）
    primaryColorDark: primaryColorDart, // primaryColor的较深版本
    primaryColorLight: primaryColorLight, // primaryColor的较浅版本
    splashColor: Colors.transparent,    // 设置水波纹为透明
    scaffoldBackgroundColor: const Color(0xFFf5f5f5),    // 页面背景颜色
    // highlightColor: Colors.transparent,   // 点击高亮设置为透明。点击时会同时有两种效果，一个是高亮一个是水波纹
    // bottomAppBarColor: Color.fromRGBO(244, 245, 245, 1.0),    // 设置底部导航的背景色
    // brightness: Brightness.light,
    // primaryIconTheme: IconThemeData(color: Colors.blue),    // 主要icon样式，如头部返回icon按钮
    // iconTheme: IconThemeData(size: 18.0),   // 设置icon样式
    // primaryTextTheme: TextTheme(    //设置文本样式
    //   title: TextStyle(color: Color(0xFF333333))
    // ),
    // accentColorBrightness: Brightness.dark,
    // dividerColor: Color(0xFFcccccc), // 分隔符颜色
    // disabledColor: Color(0xFFcccccc), // 禁用颜色
    // fontFamily: 'xxx'
  );

  return data;
}