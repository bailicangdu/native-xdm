import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './define.dart';
import './lib/utils.dart';
import './lib/matcher.dart';

/// 路由树根据传入的rotues数组决定，并根据path生成正则
/// flutor的主要匹配方式是正则
/// 没有对弹框做处理，但是弹框也是一个路由，并且会推入堆栈。那么弹框是否会导致路由系统错乱？？？
class Flutor {
  static Flutor _instance;

  /// 工厂函数，每个实例返回同一个对象
  factory Flutor({
    @required routes,
    beforeEach, 
    afterEach, 
    onError,
    transition,
    transitionsBuilder,
    transitionDuration,
    routeStyle,
  }) {
    if (_instance != null) {
      return _instance;
    } else {
      final Flutor router = new Flutor._internal(
        routes: routes,
        beforeEach: beforeEach,
        afterEach: afterEach,
        onError: onError,
        transition: transition,
        transitionsBuilder: transitionsBuilder,
        transitionDuration: transitionDuration,
        routeStyle: routeStyle,
      );

      _instance = router;

      return router;
    }
  }

  /// 实例化
  Flutor._internal({
    @required routes,
    this.beforeEach, 
    this.afterEach, 
    this.onError,
    transition,
    transitionsBuilder,
    transitionDuration,
    this.routeStyle,
  }) : routes = RouterUtils.initRoutes(routes),
    globalTransition = transition,
    globalTransitionsBuilder = transitionsBuilder,
    globalTransitionDuration = transitionDuration
   {
    matcher = RouterMatcher(this.routes);
  }

  /// 路由树，[RouterOption] 的实例数组
  List<RouterOption> routes; 

  /// 全局路由钩子，在跳转之前调用，返回false会阻碍路由跳转
  final FutureHookHandle beforeEach; 

  /// 全局路由钩子，在跳转之后调用，不会阻碍路由跳转
  final VoidHookHandle afterEach; 

  /// 错误日志上报回调
  final ExceptionHandle onError;

  /// 全局路由动画
  final RouterTranstion globalTransition; 

  /// 自定义全局路由动画，只有路由动画为custom时有效
  final RouteTransitionsBuilder globalTransitionsBuilder; 

  /// 自定义全局路由动画执行时间
  final Duration globalTransitionDuration; 

  final RouterStyle routeStyle;

  // 路由匹配
  RouterMatcher matcher; 

  /// 路由堆栈
  List<RouterNode> routeStack = [];

  /// 当前路由，放入路由堆栈后置空
  MatchedRoute activeRoute;

  /// 将路由推入堆栈，支持path，name方式查询路由
  /// 支持传入 params，query 对象，和设置动画效果
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

  /// 同上
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

  /// 推出堆栈
  Future pop(BuildContext context, [dynamic data]) async {
    final result = await _handlePopHook();
    if (result != true) {
      return false;
    }
    if (Navigator.canPop(context)) {
      Navigator.pop(context, data);
    }
  }

  /// 反复执行pop，执行次数为为传入的值，否则一直后退到首页
  /// [times] 后退多少页
  /// 说明：
  ///   1、如果不传times，则返回首页
  ///   2、后退有动画效果，且只会执行一次
  /// 
  /// 问题：
  ///   1、无法回传数据
  Future popTimes(BuildContext context, [int times]) async {
    final forData = await preformTimes(times);
    if (forData['result'] != true) {
      return false;
    }
    final int stackLength = routeStack.length;
    // 解决Navigator.popUntil的问题，如下
    for (var i = 1; i < forData['times']; i++) {
      var activeIndex = stackLength - (i + 1);
      Navigator.removeRoute(context, routeStack[activeIndex].route);
      routeStack.removeAt(activeIndex);
    }
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    /// Navigator.popUntil 有几个问题：
    ///   1、pop跳转会有一个后退的动画，如果堆栈过多，同时执行会导致页面卡顿和层叠阴影。
    ///   2、无法回传参数
    ///   3、beforeEach只会触发一遍，而afterEach会触发多次。
    // Navigator.popUntil(context, (Route<dynamic> route) {
    //   if (times < 1) {
    //     return true;
    //   }
    //   times--;
    //   return false;
    // });
  }

  /// 删除路由堆栈
  /// 1、没有动画效果
  /// 2、不会触发pop回调，所以需要手动调用afterEach
  /// 3、如果不传times，则返回首页
  Future remove(BuildContext context, [int times]) async {
    final forData = await preformTimes(times);
    if (forData['result'] != true) {
      return false;
    }
    times = forData['times'];
    final int stackLength = routeStack.length;

    final RouterNode lastPage = routeStack[stackLength - 1];
    final RouterNode nextPage = routeStack[stackLength - (times + 1)];

    for (var i = 0; i < times; i++) {
      var activeIndex = stackLength - (i + 1);
      Navigator.removeRoute(context, routeStack[activeIndex].route);
      routeStack.removeAt(activeIndex);
    }
    if (afterEach != null) {
      afterEach(nextPage, lastPage);
    }
  }

  Future pushAndRemoveNum(BuildContext context,) async {

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
    final MatchedRoute matchedRoute = _findMatchedRouter(
      path: path, 
      name: name, 
      params: params,
      query: query,
    );
    var backData;
    if (matchedRoute.route != null && matchedRoute.route.widget != null) {

      Route nextPage = flutorPageRoute(
        settings: RouteSettings(name: path ?? name),
        builder: (BuildContext context) => matchedRoute.route.widget(),
        routeStyle: routeStyle,
      );
      if (routeStack.isNotEmpty) {
        final RouterNode nextRouteNode = RouterNode(nextPage, matchedRoute);
        final RouterNode lastRouteNode = routeStack[routeStack.length - 1];
        /// 执行路由钩子
        /// 执行顺序：beforeLeave ==> beforeEach ==> beforeEnter ==> afterEach
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

  /// 查找node节点
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

  // 初始化times和执行钩子
  Future preformTimes([int times]) async {
  if (times is int && times < 1) {
      _throwError('times must be larger than 1');
      return false;
    }
    if (!(times is int) || times > routeStack.length) {
      times = routeStack.length - 1;
    }
    final result = await _handlePopHook(times: times);
    return {
      'result': result,
      'times': times,
    };
  }


  // 路由推出堆栈时的钩子
  Future _handlePopHook({
    times = 1,
  }) async {
    var result = true;
    if (routeStack.isNotEmpty) {
      final RouterNode lastPage = routeStack[routeStack.length - 1];
      // 默认后退1页
      if (!(times is int)) {
        times = 1;
      }
      // 如果后退长度大于堆栈长度，则返回首页
      final int nextPageIndex = routeStack.length > times ? routeStack.length - (times + 1) : 0;
      final RouterNode nextPage = routeStack[nextPageIndex];
      /// 执行顺序：beforeLeave ==> beforeEach ==> beforeEnter ==> afterEach
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

  /// 获取执行动画
  Route _getTransitionRoute(RouteSettings setttings, MatchedRoute matchedRoute, {
    RouterTranstion transition,
    RouteTransitionsBuilder transitionsBuilder,
    Duration transitionDuration,
  }) {
    /// 动画优先级 方法传入 > route配置 > 全局
    transition = transition ?? matchedRoute.route.transition ?? globalTransition;

    transitionsBuilder = transitionsBuilder ?? matchedRoute.route.transitionsBuilder ?? globalTransitionsBuilder;

    transitionDuration = transitionDuration ?? matchedRoute.route.transitionDuration ?? globalTransitionDuration;

    Route nextPage;
    /// WillPopScope 阻拦导航和物理返回
    final Widget scopeWidget = WillPopScope( 
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
      nextPage = flutorPageRoute(
        settings: setttings,
        builder: (BuildContext context) => scopeWidget,
        routeStyle: routeStyle,
      );
    } else {
      RouteTransitionsBuilder flutorTranstionBuilder;
      Duration duration = transitionDuration ?? const Duration(milliseconds: 300);
      // 自定义动画采用传入的 transitionsBuilder
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

  /// 制定动画类型
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
  // 这里只做简单的匹配，默认风格跳转，虽然可以做到和使用上面方法一样的效果，但是没必要，而且容易出问题，比如：异步
  Route<dynamic> generateRoute(RouteSettings settings) {
    final MatchedRoute matchedRoute = _findMatchedRouter(
      path: settings.name,
    );
    if (matchedRoute.route != null && matchedRoute.route.widget != null) {
      activeRoute = matchedRoute;

    
      return flutorPageRoute(
        builder: (BuildContext context) => matchedRoute.route.widget(params: matchedRoute.params, query: matchedRoute.query),
        settings: settings,
        routeStyle: routeStyle,
      );
    } else {
      // 默认错误页
      return flutorPageRoute(
        builder: (BuildContext context) => Scaffold(
          appBar: AppBar(
            title: Text('404'),
          ),
          body: Center(
            child: Text('page not found'),
          ),
        ), 
        settings: settings,
        routeStyle: routeStyle,
      );
    }
  }
}  
