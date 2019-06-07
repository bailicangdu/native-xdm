import 'dart:async';
import 'package:flutter/material.dart';
import './define.dart';
import './lib/utils.dart';
import './lib/matcher.dart';
import './lib/flutor_will_pop_scope.dart';

/// 路由树根据传入的rotues数组决定，并根据path生成正则
/// flutor的主要匹配方式是正则
class Flutor {
  static Flutor _instance;
  
  factory Flutor({
    @required routes,
    beforeEach,
    afterEach,
    onError,
    transition,
    transitionsBuilder,
    transitionDuration,
    routeStyle,
    observeGesture,
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
        observeGesture: observeGesture,
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
    this.routeStyle = RouterStyle.material,
    this.observeGesture = false,
  }) : assert(routes != null),
    routes = RouterUtils.initRoutes(routes),
    globalTransition = transition,
    globalTransitionsBuilder = transitionsBuilder,
    globalTransitionDuration = transitionDuration ?? const Duration(milliseconds: 300)
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

  /// 路由风格，默认material
  final RouterStyle routeStyle;

  /// 是否阻止手势操作，即左滑关闭页面
  final bool observeGesture;

  // 路由匹配
  RouterMatcher matcher; 

  /// 路由堆栈
  List<RouterNode> routeStack = [];

  /// 当前路由，放入路由堆栈后置空
  MatchedRoute activeRoute;

  /// 路由跳转有300ms的默认动画，且当前动画时间是可配的
  /// 如果在动画未执行完的情况下执行另外的路由操作，有可能会导致卡顿
  /// 解决方式：确保当前动画结束之后才可以跳转其它路由
  Duration activeRouteDuration = const Duration(milliseconds: 400);

  /// 路由入栈是否完成
  bool isRouteComplete = true; 

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

  /// 将路由推出堆栈并且删除前面若干路由
  /// [times] 退出次数
  /// 说明：
  /// 1、如果times为null，或大于堆栈长度，则推出所有堆栈并push新的页面
  /// 2、如果times为1到堆栈长度的正数，则新路由推入堆栈并删除times个前面的路由
  /// 3、如果times为0，则效果和push一样
  /// 4、如果times为负数，且绝对值小于堆栈长度，则保留路由的前几位，其它路由全部推出
  /// 5、如果times为负数，且绝对值大于堆栈长度，则效果和push一样
  Future pushAndRemove(BuildContext context, {
    String path,
    String name,
    Map<String, dynamic> params,
    Map<String, dynamic> query,
    RouterTranstion transition,
    RouteTransitionsBuilder transitionsBuilder,
    Duration transitionDuration,
    int times,
  }) async {
    // times初始化，保证times为int且长度不能超过堆栈长度
    if (!(times is int) || times > routeStack.length) {
      times = routeStack.length;
    } else if (times < 0) {
      times = routeStack.length + times;
      times = times < 0 ? 0 : times;
    }
    return await _navigate(context, 
      path: path, 
      name: name, 
      params: params, 
      query: query,
      transition: transition,
      transitionsBuilder: transitionsBuilder,
      transitionDuration: transitionDuration,
      times: times,
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
  /// 1、如果times为null，或大于堆栈长度，则推出首页外的所有堆栈，即返回首页
  /// 2、如果times为1到堆栈长度的正数，则推出栈并最后的times个路由
  /// 3、如果times为0，则无效果
  /// 4、如果times为负数，且绝对值小于堆栈长度，则保留最前面的times个路由，并推出其它路由
  /// 5、如果times为负数，且绝对值大于堆栈长度，则无效果
  /// 6、无法回传数据
  Future popTimes(BuildContext context, { int times }) async {
    if (!isRouteComplete) {
      return null;
    }
    final forData = await preformTimes(times);
    if (forData['result'] != true) {
      return false;
    }
    times = forData['times'];
    final int stackLength = routeStack.length;
    
    for (var i = 1; i < times; i++) {
      var activeIndex = stackLength - (i + 1);
      Navigator.removeRoute(context, routeStack[activeIndex].route);
      routeStack.removeAt(activeIndex);
    }

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    // Navigator.popUntil有几个问题，如下
    /// 1、pop跳转会有一个后退的动画，如果堆栈过多，同时执行会导致页面卡顿和层叠阴影。
    /// 2、无法回传参数
    /// 3、beforeEach只会触发一遍，而afterEach会触发多次。
    /// Navigator.popUntil 有几个问题：
    // Navigator.popUntil(context, (Route<dynamic> route) {
    //   if (times < 1) {
    //     return true;
    //   }
    //   times--;
    //   return false;
    // });
  }

  /// 删除路由堆栈
  /// 说明：
  /// 1、如果times为null，或大于堆栈长度，则推出首页外的所有堆栈，即返回首页
  /// 2、如果times为1到堆栈长度的正数，则推出栈并最后的times个路由
  /// 3、如果times为0，则无效果
  /// 4、如果times为负数，且绝对值小于堆栈长度，则保留最前面的times个路由，并推出其它路由
  /// 5、如果times为负数，且绝对值大于堆栈长度，则无效果
  /// 6、没有动画效果
  /// 7、不会触发pop回调，所以需要手动调用afterEach
  Future remove(BuildContext context, { int times }) async {
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

  // push 和 repalce统一跳转处理
  Future _navigate(BuildContext context, {
    String path,
    String name,
    Map<String, dynamic> params,
    Map<String, dynamic> query,
    RouterTranstion transition,
    RouteTransitionsBuilder transitionsBuilder,
    Duration transitionDuration = const Duration(milliseconds: 300),
    bool isReplace = false,
    int times,
  }) async {
    if (path == null && name == null) {
      _throwError('the path or name is required for push method');
      return null;
    }

    // 是否是 pushAndRemove
    bool isPushAndRemove = false;
    if (times is int) {
      isPushAndRemove = true;
    } else {
      times = 0;
    }

    final MatchedRoute matchedRoute = _findMatchedRouter(
      path: path, 
      name: name, 
      params: params,
      query: query,
    );
    var backData;
    if (matchedRoute.route != null && matchedRoute.route.widget != null) {
      
      // 下个页面
      Route nextPage = FlutorPageRoute(
        settings: RouteSettings(name: path ?? name),
        builder: (BuildContext context) => matchedRoute.route.widget(),
        routeStyle: routeStyle,
      );
      if (routeStack.isNotEmpty) {
        // 生成路由堆栈节点
        final RouterNode nextRouteNode = RouterNode(nextPage, matchedRoute);
        RouterNode lastRouteNode;
        if ((routeStack.length - (times + 1)) > -1) {
          lastRouteNode = routeStack[routeStack.length - (times + 1)];
        } else {
          lastRouteNode = RouterNode(null);
        }
        /// 执行路由钩子
        /// 执行顺序：beforeLeave ==> beforeEach ==> beforeEnter ==> afterEach
        if (
          lastRouteNode != null && 
          lastRouteNode.flutorRoute != null && 
          lastRouteNode.flutorRoute.route.beforeLeave != null
        ) {
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
      getRouteStatus();
      if (isReplace) {
        backData = await Navigator.pushReplacement(context, nextPage);
      } else if(isPushAndRemove) {
        Navigator.push(context, nextPage);
        Timer(activeRouteDuration, () {
          final int stackLength = routeStack.length;
          for (var i = 0; i < times; i++) {
            var activeIndex = stackLength - (i + 2);
            Navigator.removeRoute(context, routeStack[activeIndex].route);
            routeStack.removeAt(activeIndex);
          }
        });
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
    if (!(times is int) || times > routeStack.length) {
      times = routeStack.length - 1;
    } else if (times < 0) {
      times = routeStack.length + times;
      if (times < 1) {
        return {
          'result': false,
          'times': times,
        };
      }
    } else if (times == 0) {
      return {
        'result': false,
        'times': times,
      };
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

    activeRouteDuration = transitionDuration + const Duration(milliseconds: 100);

    Route nextPage;
    /// FlutorWillPopScope 阻拦导航和物理返回，并且会禁止手势返回操作，但不阻拦pop等方法
    final Widget scopeWidget = FlutorWillPopScope(
      onWillPop: () async {
        return await _handlePopHook();
      },
      matchedRoute: matchedRoute,
      observeGesture: observeGesture,
      child: matchedRoute.route.widget(params: matchedRoute.params, query: matchedRoute.query),
    );
    if (
      !(transition is RouterTranstion)
      || transition == RouterTranstion.auto
      || (transition == RouterTranstion.custom && transitionsBuilder == null)
    ) {
      nextPage = FlutorPageRoute(
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
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    };
    return builder;
  }

  void _throwError([String msg]) {
    if (onError != null) {
        FlutorException pushError = FlutorException(msg);
        onError(pushError);
      }
  }

  /// 路由动画是否完成
  void getRouteStatus() {
    isRouteComplete = false;
    Timer(activeRouteDuration, () {
      isRouteComplete = true;
    });
  }

  // 主要是为了匹配首页地址，也就是 '/'
  // 这里只做简单的匹配，默认风格跳转，虽然可以做到和使用上面方法一样的效果，但是没必要，而且容易出问题，比如：异步
  Route<dynamic> generateRoute(RouteSettings settings) {
    final MatchedRoute matchedRoute = _findMatchedRouter(
      path: settings.name,
    );
    if (matchedRoute.route != null && matchedRoute.route.widget != null) {
      activeRoute = matchedRoute;

      final Route nextPage = FlutorPageRoute(
        builder: (BuildContext context) => matchedRoute.route.widget(params: matchedRoute.params, query: matchedRoute.query),
        settings: settings,
        routeStyle: routeStyle,
      );

      /// 为了保证app正常启动，首页的钩子并不会阻止页面的渲染，也就是说即便beforeEach和beforeEnter返回false
      /// 页面也可以正常渲染，当然只是在初始化app的时候才会这样
      final RouterNode nextRouteNode = RouterNode(nextPage, matchedRoute);

      RouterNode lastRouteNode;
      if (routeStack.isNotEmpty) {
        lastRouteNode = routeStack[routeStack.length - 1];
      } else {
        lastRouteNode = RouterNode(null);
      }

      if (
        lastRouteNode != null && 
        lastRouteNode.flutorRoute != null && 
        lastRouteNode.flutorRoute.route.beforeLeave != null
      ) {
        lastRouteNode.flutorRoute.route.beforeLeave(nextRouteNode, lastRouteNode);
      }

      if (beforeEach != null) beforeEach(nextRouteNode, lastRouteNode);

      if (matchedRoute.route.beforeEnter != null) {
        matchedRoute.route.beforeEnter(nextRouteNode, lastRouteNode);
      }

      return nextPage;
    } else {
      // 默认错误页
      return FlutorPageRoute(
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
