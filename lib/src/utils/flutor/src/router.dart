import 'dart:async';
import 'package:flutter/material.dart';
import './define.dart';
import './lib.dart';

class Router {
  Router({ 
    @required this.routes,
    this.beforeEach, 
    this.afterEach, 
    this.onError,
    this.transition,
    }) {
      print('aaaaaaaa');
  }

  final List<Map<String, dynamic>> routes;

  final FutureHookHandle beforeEach;

  final VoidHookHandle afterEach;

  final ExceptionHandle onError;

  final RouterTranstion transition;


  final RouterStack _routerStack = RouterStack();

  Future push(BuildContext context, {
    String path,
    String name,
    Map<String, dynamic> params,
    Map<String, dynamic> query,
    RouterTranstion transition,
  }) async {
    if (path == null && name == null) {
      _handleError('the path or name is required for push method');
      return null;
    }
    Navigator.push(context, MaterialPageRoute(
      // settings: const RouteSettings(name: '/pesto/favorites'),
      builder: (BuildContext context) => routes[1]['widget'](),
    ));
    // final Route<dynamic> page = xxx;
    // final result = await Navigator.push(context, page);
    // return result;
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
      builder: (BuildContext context) => routes[1]['widget'](), 
      settings: settings,
    );
  }

}