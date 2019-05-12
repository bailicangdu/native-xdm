import 'package:flutter/material.dart';

class RouteConfig {
  RouteConfig({
    @required this.path,
    @required this.widget,
    this.name,
  });

  final String path;
  final WidgetHandle widget;
  final String name;
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
