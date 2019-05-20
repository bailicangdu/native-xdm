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
    transitionsBuilder,
    transitionDuration,
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
        transitionsBuilder: transitionsBuilder,
        transitionDuration: transitionDuration,
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
    transition,
    transitionsBuilder,
    transitionDuration,
  }) 
    : routes = RouterUtils.initRoutes(routes),
    globalTransition = transition,
    globalTransitionsBuilder = transitionsBuilder,
    globalTransitionDuration= transitionDuration
   {
    matcher = RouterMatcher(this.routes);
  }

  List<RouterOption> routes;

  final FutureHookHandle beforeEach;

  final VoidHookHandle afterEach;

  final ExceptionHandle onError;

  RouterTranstion globalTransition;

  RouteTransitionsBuilder globalTransitionsBuilder;

   Duration globalTransitionDuration;

  RouterMatcher matcher;

  List<RouterNode> routeStack = [];

  MatchedRoute activeRoute;

  Future push(BuildContext context, {
    String path,
    String name,
    Map<String, dynamic> params,
    Map<String, dynamic> query,
    RouterTranstion transition,
    RouteTransitionsBuilder transitionsBuilder,
    Duration transitionDuration,
  }) async {
    return await _navigate(context, 
      path: path, 
      name: name, 
      params: params, 
      query: query,
      transition: transition,
      transitionsBuilder: transitionsBuilder,
      transitionDuration: transitionDuration,
    );
  }

  Future replace(BuildContext context, {
    String path,
    String name,
    Map<String, dynamic> params,
    Map<String, dynamic> query,
    RouterTranstion transition,
    RouteTransitionsBuilder transitionsBuilder,
    Duration transitionDuration,
  }) async {
    return await _navigate(context, 
      path: path, 
      name: name, 
      params: params, 
      query: query,
      transition: transition,
      transitionsBuilder: transitionsBuilder,
      transitionDuration: transitionDuration,
      isReplace: true,
    );
  }

  Future pop(BuildContext context, [dynamic data]) async {
    var result = await _handlePopHook();
    if (result != true) {
      return false;
    }
    if (data != null) {
      Navigator.pop(context, data);
    } else {
      Navigator.pop(context);
    }
  }

  Future _navigate(BuildContext context, {
    String path,
    String name,
    Map<String, dynamic> params,
    Map<String, dynamic> query,
    RouterTranstion transition,
    RouteTransitionsBuilder transitionsBuilder,
    Duration transitionDuration = const Duration(milliseconds: 250),
    bool isReplace = false,
  }) async {
    if (path == null && name == null) {
      _throwError('the path or name is required for push method');
      return null;
    }
    MatchedRoute matchedRoute = _findMatchedRouter(
      path: path, 
      name: name, 
      params: params, 
      query: query,
    );
    var backData;
    if (matchedRoute.route != null && matchedRoute.route.widget != null) {
      Route nextPage = MaterialPageRoute(
        settings: RouteSettings(name: path ?? name),
        builder: (BuildContext context) => matchedRoute.route.widget(),
      );
      if (routeStack.isNotEmpty) {
        RouterNode nextRouteNode = RouterNode(nextPage, matchedRoute);
        RouterNode lastRouteNode = routeStack[routeStack.length - 1];
        if (lastRouteNode.flutorRoute != null && lastRouteNode.flutorRoute.route.beforeLeave != null) {
          var leaveResult = await lastRouteNode.flutorRoute.route.beforeLeave(nextRouteNode, lastRouteNode);
          if (leaveResult != true) return null;
        }
        if (beforeEach != null) {
          var beforeEachResult = await beforeEach(nextRouteNode, lastRouteNode);
          if (beforeEachResult != true) return null;
        }
        if (matchedRoute.route.beforeEnter != null) {
          var enterResult = await matchedRoute.route.beforeEnter(nextRouteNode, lastRouteNode);
          if (enterResult != true) return null;
        }
      } else {
        _throwError('to observer route, you must add FlutorObserver to navigatorObservers, See the documentation for details.');
      }
      RouteSettings setttings = RouteSettings(name: path ?? name);
      nextPage = _getTransitionRoute(
        setttings, 
        matchedRoute, 
        transition: transition, 
        transitionsBuilder: transitionsBuilder,
        transitionDuration: transitionDuration,
      );
      activeRoute = matchedRoute; // 将最新的路由记录下来，执行钩子的时候放入堆栈
      if (isReplace) {
        backData = await Navigator.pushReplacement(context, nextPage);
      } else {
        backData = await Navigator.push(context, nextPage);
      }
    } else {
      _throwError('can not match any rotue, please check again');
    }
    return backData;
  }

  MatchedRoute _findMatchedRouter({
    String path,
    String name,
    Map<String, dynamic> params,
    Map<String, dynamic> query,
  }) {
    MatchedRoute matchedRoute;
    if (path != null) {
      matchedRoute = matcher.findByPath(path);
    }
    if (name != null) {
      matchedRoute = matcher.findByName(name);
    }
    matchedRoute.params.addAll(params ?? {});
    matchedRoute.query.addAll(query ?? {});
    return matchedRoute;
  }

  Future _handlePopHook() async {
    var result = true;
    if (routeStack.isNotEmpty) {
      RouterNode lastPage = routeStack[routeStack.length - 1];
      RouterNode nextPage = routeStack[routeStack.length - 2];
      if (lastPage.flutorRoute != null && lastPage.flutorRoute.route.beforeLeave != null) {
        result = await lastPage.flutorRoute.route.beforeLeave(nextPage, lastPage);
        if (result != true) return false;
      }
      if (beforeEach != null) {
        result = await beforeEach(nextPage, lastPage);
        if (result != true) return false;
      }
      if (nextPage.flutorRoute != null && nextPage.flutorRoute.route.beforeEnter != null) {
        result = await nextPage.flutorRoute.route.beforeEnter(nextPage, lastPage);
        if (result != true) return false;
      }
    } else {
      _throwError('to observer route, you must add FlutorObserver to navigatorObservers, See the documentation for details.');
    }
    return result;
  }

  Route _getTransitionRoute(RouteSettings setttings, MatchedRoute matchedRoute, {
    RouterTranstion transition,
    RouteTransitionsBuilder transitionsBuilder,
    Duration transitionDuration,
  }) {
    transition = transition ?? matchedRoute.route.transition ?? globalTransition;

    transitionsBuilder = transitionsBuilder ?? matchedRoute.route.transitionsBuilder ?? globalTransitionsBuilder;

    transitionDuration = transitionDuration ?? matchedRoute.route.transitionDuration ?? globalTransitionDuration;

    Route nextPage;
    Widget scopeWidget = WillPopScope( // 阻拦导航和物理返回
      onWillPop: () async {
        return await _handlePopHook();
      },
      child: matchedRoute.route.widget(params: matchedRoute.params, query: matchedRoute.query),
    );
    if (
      !(transition is RouterTranstion)
      || transition == RouterTranstion.auto
      || (transition == RouterTranstion.custom && transitionsBuilder == null)
    ) {
      nextPage = MaterialPageRoute(
        settings: setttings,
        builder: (BuildContext context) => scopeWidget,
      );
    } else {
      RouteTransitionsBuilder flutorTranstionBuilder;
      Duration duration = transitionDuration ?? const Duration(milliseconds: 300);
      if (transition == RouterTranstion.custom) {
        flutorTranstionBuilder = transitionsBuilder;
      } else {
        flutorTranstionBuilder = _getTransitionsBuilder(transition);
        if (transition == RouterTranstion.none) {
          duration = const Duration(milliseconds: 0);
        }
      }
      nextPage = PageRouteBuilder(
        settings: setttings,
        pageBuilder: (
          BuildContext context, 
          Animation<double> animation, 
          Animation<double> secondaryAnimation,
        ) {
          return scopeWidget;
        },
        transitionDuration: duration,
        transitionsBuilder: flutorTranstionBuilder,
      );
    }

    return nextPage;
  }

  RouteTransitionsBuilder _getTransitionsBuilder(RouterTranstion transition) {
    RouteTransitionsBuilder builder = (
      BuildContext context,
      Animation<double> animation, 
      Animation<double> secondaryAnimation, 
      Widget child,
    ) {
      if (transition == RouterTranstion.fadeIn) {
        return FadeTransition(opacity: animation, child: child);
      }
      const Offset targetPosition = const Offset(0.0, 0.0);
      Offset benginPosition;

      switch (transition) {
        case RouterTranstion.none:
        case RouterTranstion.slideRight:
          benginPosition = const Offset(1.0, 0.0);
          break;
        case RouterTranstion.slideLeft:
          benginPosition = const Offset(-1.0, 0.0);
          break;
        case RouterTranstion.slideBottom:
          benginPosition = const Offset(0.0, 1.0);
          break;
        default:
      }

      return SlideTransition(
        position: Tween<Offset>(
          begin: benginPosition,
          end: targetPosition,
        ).animate(animation),
        child: child,
      );
    };
    return builder;
  }

  void _throwError([String msg]) {
    if (onError is ExceptionHandle) {
        FlutorException pushError = FlutorException(msg);
        onError(pushError);
      }
  }

  // 主要是为了匹配首页地址，也就是 '/'
  // 这里只做简单的匹配，虽然可以做到和使用上面方法一样的效果，但是没必要，而且容易出问题，比如：异步
  Route<dynamic> generateRoute(RouteSettings settings) {
    MatchedRoute matchedRoute = _findMatchedRouter(
      path: settings.name,
    );
    if (matchedRoute.route != null && matchedRoute.route.widget != null) {
      activeRoute = matchedRoute;
      return MaterialPageRoute(
        builder: (BuildContext context) => matchedRoute.route.widget(params: matchedRoute.params, query: matchedRoute.query),
        settings: settings,
      );
    } else {
      return MaterialPageRoute(
        builder: (BuildContext context) => Scaffold(
          appBar: AppBar(
            title: Text('404'),
          ),
          body: Center(
            child: Text('page not found'),
          ),
        ), 
        settings: settings,
      );
    }
  }

}