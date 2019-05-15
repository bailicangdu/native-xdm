import 'package:flutter/material.dart';
import '../router.dart';

class FlutorObserver extends NavigatorObserver {
  FlutorObserver(this.target);
  final Router target;

  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    handleAfter(route, previousRoute);
  }

  @override
  void didPop(Route previousRoute, Route route) {
    // didPop的参数是相反的
    super.didPop(previousRoute, route);
    handleAfter(route, previousRoute);
  }

  @override
  void didReplace({ Route newRoute, Route oldRoute }) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    handleAfter(newRoute, oldRoute);
  }

  handleAfter(Route route, Route previousRoute) {
    target?.afterEach(route, previousRoute);
  }
}