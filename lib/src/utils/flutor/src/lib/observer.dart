import 'package:flutter/material.dart';
import '../define.dart';
import '../router.dart';

class FlutorObserver extends NavigatorObserver {
  FlutorObserver(this.target);
  final Router target;

  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    RouterNode nextRoute = RouterNode(route, target.activeRoute);
    target.routeStack.add(nextRoute);
    target.activeRoute = null;
    int stackLength = target.routeStack.length;
    RouterNode lastRoute = stackLength > 1 ? target.routeStack[stackLength - 2] : RouterNode(null);
    handleAfter(nextRoute, lastRoute);
  }

  @override
  void didPop(Route previousRoute, Route route) {
    // didPop的参数是相反的
    super.didPop(previousRoute, route);
    RouterNode lastRoute = target.routeStack.removeLast();
    handleAfter(target.routeStack[target.routeStack.length - 1], lastRoute);
  }

  @override
  void didReplace({ Route newRoute, Route oldRoute }) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    RouterNode nextRoute = RouterNode(newRoute, target.activeRoute);
    RouterNode lastRoute = target.routeStack.removeLast();
    target.routeStack.add(nextRoute);
    target.activeRoute = null;
    handleAfter(nextRoute, lastRoute);
  }

  handleAfter(RouterNode route, RouterNode previousRoute) {

    target?.afterEach(route, previousRoute);
  }
}