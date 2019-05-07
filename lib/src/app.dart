import 'package:flutter/material.dart';
import 'pages/home/home.dart';
import 'pages/gallery/gallery.dart';
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
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => Home(),
      },
      // settings是在Navigator.pushNamed调用时传入的对象，其中name就是传入的地址
      // 这个地址可以是未定义的
      onGenerateRoute: (RouteSettings settings) {
        print(settings);
        WidgetBuilder builder;
        if (RegExp('/gallery\.\*').hasMatch(settings.name)) {
          // String param = settings.name.split('/')[2];
          builder = (BuildContext context) => Gallery();
        }

        return new MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}

