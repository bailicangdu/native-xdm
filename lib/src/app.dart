import 'package:flutter/material.dart';
import 'pages/home/home.dart';
import 'pages/gallery/gallery.dart';
import 'pages/page1/page1.dart';
import 'pages/page2/page2.dart';
import 'pages/page2/page3/page3.dart';
import 'router/router.dart';

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
      // 这个地址可以是未定义的
      onGenerateRoute: (RouteSettings settings) {
        print(settings);
        WidgetBuilder builder;
        if (settings.name == '/') {
          builder = (BuildContext context) => Page1();
        } else if (RegExp('/page2\.\*').hasMatch(settings.name)) {
          // String param = settings.name.split('/')[2];
          builder = (BuildContext context) => Page2();
        } else if (RegExp('/page3\.\*').hasMatch(settings.name)) {
          // String param = settings.name.split('/')[2];
          builder = (BuildContext context) => Page3();
        }

        return MaterialPageRoute(builder: builder, settings: settings);
      },
      navigatorObservers: [
        GLObserver(), // 导航监听
      ],
    );
  }
}

class GLObserver extends NavigatorObserver {
// 添加导航监听后，跳转的时候需要使用Navigator.push路由
  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);

    var previousName = '';
    if (previousRoute == null) {
      previousName = 'null';
    }else {
      previousName = previousRoute.settings.name;
    }
    print('NavObserverDidPush-Current:' + route.settings.name + '  Previous:' + previousName);
  }

  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);

    var previousName = '';
    if (previousRoute == null) {
      previousName = 'null';
    }else {
      previousName = previousRoute.settings.name;
    }
    print('NavObserverDidPop--Current:' + route.settings.name + '  Previous:' + previousName);
  }
}

