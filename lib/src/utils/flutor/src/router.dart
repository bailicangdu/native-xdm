import 'dart:async';
import 'package:flutter/material.dart';
import './define.dart';
import './lib/utils.dart';
import './lib/matcher.dart';

class Router {
  static Router _instance;

  factory Router({
    @required routes,
    beforeEach, 
    afterEach, 
    onError,
    transition,
  }) {
    if (_instance != null) {
      return _instance;
    } else {
      final Router router = new Router._internal(
        routes: routes,
        beforeEach: beforeEach,
        afterEach: afterEach,
        onError: onError,
        transition: transition,
      );

      _instance = router;

      return router;
    }
  }

  Router._internal({
    @required routes,
    this.beforeEach, 
    this.afterEach, 
    this.onError,
    this.transition,
  }) :routes = RouterUtils.initRoutes(routes) {
    matcher = RouterMatcher(this.routes);
  }

  List<RouterOption> routes;

  final FutureHookHandle beforeEach;

  final VoidHookHandle afterEach;

  final ExceptionHandle onError;

  final RouterTranstion transition;

  RouterMatcher matcher;

  Future push(BuildContext context, {
    String path,
    String name,
    Map<String, dynamic> params = const {},
    Map<String, dynamic> query = const {},
    RouterTranstion transition,
  }) async {
    if (path == null && name == null) {
      _handleError('the path or name is required for push method');
      return null;
    }
    MatchedRoute matchedRoute;
    if (path != null) {
      matchedRoute = matcher.findByPath(path);
    }
    if (name != null) {
      matchedRoute = matcher.findByName(name);
    }
    matchedRoute.params.addAll(params);
    matchedRoute.query.addAll(query);
    print(matchedRoute);
    if (matchedRoute.route != null && matchedRoute.route.widget != null) {
      String settingName = matchedRoute.route.path;
      Navigator.push(context, MaterialPageRoute(
        // settings: const RouteSettings(name: settingName),
        builder: (BuildContext context) => matchedRoute.route.widget(),
      ));
    }
    // final Route<dynamic> page = xxx;
    // final result = await Navigator.push(context, page);
    // return result;
    return null;
  }

  Future replace() async {

  }

  Future pop() {

  }

  void _handleError([String msg]) {
    if (onError is ExceptionHandle) {
        FlutorException pushError = FlutorException(msg);
        onError(pushError);
      }
  }

  // 这个有必要吗，这个是给native方法用的
  Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (BuildContext context) => routes[1]?.widget(), 
      settings: settings,
    );
  }

}