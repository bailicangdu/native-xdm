import 'package:flutter/material.dart';

class RouterOption {
  RouterOption({
    @required this.path,
    @required this.widget,
    this.name,
    this.transition,
    this.beforeEnter,
    this.beforeLeave,
    this.children,
  }) : assert(path != null),
      assert(widget != null);

  final String path;
  final WidgetHandle widget;
  final String name;
  final RouterTranstion transition;
  final FutureHookHandle beforeEnter;
  final FutureHookHandle beforeLeave;
  final List<Map<String, dynamic>> children;

  RouterOption.fromMap(Map<String, dynamic> route)
    : path = route['path'],
      widget = route['widget'],
      name = route['name'],
      transition = route['transition'],
      beforeEnter = route['beforeEnter'],
      beforeLeave = route['beforeLeave'],
      children = route['children'];

  @override
  String toString() => '{path: $path, name: $name}';
}

class StackNode {

}

/// Future路由钩子
typedef Future FutureHookHandle<T>(StackNode to, StackNode from);

/// void路由钩子
typedef void VoidHookHandle<T>(StackNode to, StackNode from);

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
