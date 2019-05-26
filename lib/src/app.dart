import 'package:flutter/material.dart';
import 'router/router.dart';
import 'utils/flutor/flutor.dart';
import 'package:xiaodemo/src/config/themes.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:xiaodemo/src/model/app_model.dart';

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  AppModel model;

  @override
  void initState() {
    super.initState();
    model = AppModel();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(
      model: model,
      child: MaterialApp(
        title: 'xiaodemo',
        debugShowCheckedModeBanner: false, // 去除右上角debug标签
        theme: mainTheme.themeData,
        onGenerateRoute: flutor.generateRoute,
        navigatorObservers: [
          FlutorObserver(flutor), // 导航监听
        ],
      ),
    );
  }
}
