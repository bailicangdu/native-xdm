import 'package:flutter/material.dart';

class Route {
  
}

class StackNode {

}

/// Future路由钩子
typedef Future FutureHookHandle<T>(StackNode to, StackNode from);

/// void路由钩子
typedef void VoidHookHandle<T>(StackNode to, StackNode from);


enum RouterTranstion {
  auto,
  none,
  slideRight,
  slideLeft,
  slideBottom,
  fadeIn,
  custom,
}