import 'package:flutter/material.dart';
import 'package:xiaodemo/router/router.dart';
import 'package:xiaodemo/utils/event_center.dart';

class HomeEvent {
  String _homeBottomBarName = 'home';

  get homeBottomBarName => _homeBottomBarName;

  /// 跳转首页
  void goHome(BuildContext context, { bool withAnimation: true }) {
    _homeBottomBarName = 'home';
    navigator(context, withAnimation);
  }

  /// 跳转发现页
  void goDiscover(BuildContext context, { bool withAnimation: true }) {
    _homeBottomBarName = 'discover';
    navigator(context, withAnimation);
  }

  /// 跳转订单列表页
  void goOrders(BuildContext context, { bool withAnimation: true }) {
    _homeBottomBarName = 'orders';
    navigator(context, withAnimation);
  }

  /// 跳转个人中心页
  void goPersonal(BuildContext context, { bool withAnimation: true }) {
    _homeBottomBarName = 'personal';
    navigator(context, withAnimation);
  }

  navigator(BuildContext context, [bool withAnimation = true]) {
    eventCenter.trigger('switchTab', homeBottomBarName);
    if (withAnimation) {
      router.popTimes(context);
    } else {
      router.remove(context);
    }
  }
}