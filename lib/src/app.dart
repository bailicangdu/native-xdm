import 'package:flutter/material.dart';
import 'pages/home/home.dart';
import 'pages/gallery/gallery.dart';
import 'pages/page1/page1.dart';
import 'pages/page2/page2.dart';
import 'pages/page2/page3/page3.dart';
import 'pages/page2/page4/page4.dart';
import 'router/router.dart';
import 'utils/flutor/flutor.dart';

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // print(router.routes);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'xiaodemo',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      // initialRoute: '/',
      // routes: {
      //   '/': (BuildContext context) => Page1(),
      // },
      // settings是在Navigator.pushNamed调用时传入的对象，其中name就是传入的地址
      // 动态生成路由
      onGenerateRoute: router.generateRoute,
      navigatorObservers: [
        FlutorObserver(router), // 导航监听
      ],
    );
  }
}
