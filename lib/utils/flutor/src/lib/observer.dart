import 'package:flutter/material.dart';
import '../define.dart';
import '../router.dart';

/// 路由Observer
class FlutorObserver extends NavigatorObserver {
  FlutorObserver(this.target);
  final Flutor target;

  /// 每个路由节点有两部分组成：系统route对象和flutor的路由对象
  /// 为了兼容通过Navigator跳转的方式，flutor的路由对象有可能为空
  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    /// 通过flutor提供的方法进行路由跳转，会有一个临时的路由记录，使用过之后需要置空
    /// 下同
    RouterNode nextRoute = RouterNode(route, target.activeRoute);
    target.routeStack.add(nextRoute);
    target.activeRoute = null;
    int stackLength = target.routeStack.length;
    RouterNode lastRoute = stackLength > 1 ? target.routeStack[stackLength - 2] : RouterNode(null);
    handleAfter(nextRoute, lastRoute);
  }

  /// 推出堆栈
  @override
  void didPop(Route previousRoute, Route route) {
    // didPop的参数是相反的
    super.didPop(previousRoute, route);
    RouterNode lastRoute = target.routeStack.removeLast();
    handleAfter(target.routeStack[target.routeStack.length - 1], lastRoute);
  }

  /// 替换路由
  @override
  void didReplace({ Route newRoute, Route oldRoute }) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    RouterNode nextRoute = RouterNode(newRoute, target.activeRoute);
    RouterNode lastRoute = target.routeStack.removeLast();
    target.routeStack.add(nextRoute);
    target.activeRoute = null;
    handleAfter(nextRoute, lastRoute);
  }

  // @override
  // void didStartUserGesture(Route route, Route previousRoute) {
  //   print('开始手势操作');
  // }

  // @override
  // void didStopUserGesture() {
  //   print('手势操作取消');
  // }

  /// 全局的afterEach钩子
  handleAfter(RouterNode route, RouterNode previousRoute) {
    if (target.afterEach != null) target.afterEach(route, previousRoute);
  }
}