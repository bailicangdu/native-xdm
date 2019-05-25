import 'package:flutter/material.dart';
import 'pages/home/home.dart';
import 'pages/gallery/gallery.dart';
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
      debugShowCheckedModeBanner: false, // 去除右上角debug标签
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: router.generateRoute,
      navigatorObservers: [
        FlutorObserver(router), // 导航监听
      ],
    );
  }
}
