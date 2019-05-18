import 'package:flutter/material.dart';

class RouterOption {
  RouterOption({
    @required this.path,
    this.widget,
    this.name,
    this.transition,
    this.beforeEnter,
    this.beforeLeave,
    this.children,
  }) : assert(path != null);

  final String path;
  final String name;
  final WidgetHandle widget;
  final RouterTranstion transition;
  final FutureHookHandle beforeEnter;
  final FutureHookHandle beforeLeave;
  final List<RouterOption> children;
  String regexp;
  List<String> paramName = [];

  RouterOption.fromMap(Map<String, dynamic> route)
    : assert(route['path'] != null),
      path = route['path'],
      widget = route['widget'],
      name = route['name'],
      transition = route['transition'],
      beforeEnter = route['beforeEnter'],
      beforeLeave = route['beforeLeave'],
      children = route['children'],
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
typedef Future FutureHookHandle<T>(Route to, Route from);

/// void路由钩子
typedef void VoidHookHandle<T>(Route to, Route from);

/// 路由配置函数
typedef Widget WidgetHandle<T>({ Map<String, dynamic>params, Map<String, dynamic>query });

/// 错误处理函数
typedef void ExceptionHandle<T>(FlutorException error);

enum RouterTranstion {
  auto,
  none,
  slideRight,
  slideLeft,
  slideBottom,
  fadeIn,
  custom,
}

class FlutorException implements Exception {
  const FlutorException([this.msg]);
  final String msg;

  String toString() => msg ?? 'FlutorException';
}


class MatchedRoute {
  MatchedRoute(this.route, { params, query }): params=params??{}, query=query??{};
  final RouterOption route;
  Map<String, dynamic> params;
  Map<String, dynamic> query;

  @override
  String toString() => '{route: $route, params: $params, query: $query}';
}