import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class RouterOption {
  RouterOption({
    @required this.path,
    this.widget,
    this.name,
    this.beforeEnter,
    this.beforeLeave,
    this.children,
    this.transition,
    this.transitionsBuilder,
    this.transitionDuration,
    this.observeGesture = false,
  }) : assert(path != null);

  final String path;
  final String name;
  final WidgetHandle widget;
  final FutureHookHandle beforeEnter;
  final FutureHookHandle beforeLeave;
  final List<RouterOption> children;
  final RouterTranstion transition;
  final RouteTransitionsBuilder transitionsBuilder;
  final Duration transitionDuration;
  final bool observeGesture;

  String regexp;
  List<String> paramName = [];

  RouterOption.fromMap(Map<String, dynamic> route)
    : assert(route['path'] != null),
      path = route['path'],
      widget = route['widget'],
      name = route['name'],
      beforeEnter = route['beforeEnter'],
      beforeLeave = route['beforeLeave'],
      children = route['children'],
      transition = route['transition'],
      transitionsBuilder = route['transitionsBuilder'],
      transitionDuration = route['transitionDuration'],
      observeGesture = route['observeGesture'] ?? false,
      regexp = route['regexp'],
      paramName = route['paramName'];

  String getChildrenStr() {
    String childStr = '';
    if (children != null) {
      childStr = ', children: [';
      for (var child in children) {
        childStr += child.toString();
      }
      childStr += ']';
    }
    return childStr;
  }

  @override
  String toString() => '{path: $path, name: $name, regexp: $regexp${getChildrenStr()}}';
}

/// Future路由钩子
typedef Future FutureHookHandle<T>(RouterNode to, RouterNode from);

/// void路由钩子
typedef void VoidHookHandle<T>(RouterNode to, RouterNode from);

/// 路由配置函数
typedef Widget WidgetHandle<T>({ Map<String, dynamic>params, Map<String, dynamic>query });

/// 错误处理函数
typedef void ExceptionHandle<T>(FlutorException error);

/// 可选动画类型 
/// auto为默认类型
/// none 没有动画
/// custom 自定义
enum RouterTranstion {
  auto,
  none,
  slideRight,
  slideLeft,
  slideBottom,
  fadeIn,
  custom,
}

/// 路由风格 ios/自适应
enum RouterStyle {
  cupertino, // ios风格，页面自右向左滑入，支持手势左滑关闭页面
  material, // material，不同平台不同风格，ios风格如上，安卓下页面自下而上滑入，不支持手势关闭
}

Route<dynamic> FlutorPageRoute({
  @required builder,
  title,
  RouteSettings settings,
  maintainState = true,
  bool fullscreenDialog = false,
  routeStyle,
}) {
  if (routeStyle == RouterStyle.cupertino) {
    return CupertinoPageRoute(
      builder: builder,
      title: title,
      settings: settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
    );
  } else {
    return MaterialPageRoute(
      builder: builder,
      settings: settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
    );
  }
}

/// flutor错误类型
class FlutorException implements Exception {
  const FlutorException([this.msg]);
  final String msg;

  String toString() => msg ?? 'FlutorException';
}

/// 匹配到的类型
class MatchedRoute {
  MatchedRoute(this.route, { params, query }): params=params??{}, query=query??{};
  final RouterOption route;
  Map<String, dynamic> params;
  Map<String, dynamic> query;

  @override
  String toString() => '{route: $route, params: $params, query: $query}';
}

/// 路由节点
class RouterNode {
  RouterNode(this.route, [this.flutorRoute]) {
    if (route != null) {
      _path = route.settings?.name;
      params = flutorRoute?.params;
      query = flutorRoute?.query;
    }
  }
  final Route route;
  final MatchedRoute flutorRoute;
  String _path;
  Map<String, dynamic> params = {};
  Map<String, dynamic> query = {};

  String get path => _path ?? 'null';

  @override
  String toString() => '{path: $path, params: $params, query: $query}';
}