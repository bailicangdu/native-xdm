import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:xiaodemo/router/router.dart';


class HomeModel extends Model {
  String _homeBottomBarName = 'home';

  get homeBottomBarName => _homeBottomBarName;

  /// 跳转首页
  void goHome(BuildContext context, { bool withAnimation: true }) {
    _homeBottomBarName = 'home';
    pop(context, withAnimation);
    notifyListeners();
  }

  /// 跳转发现页
  void goDiscover(BuildContext context, { bool withAnimation: true }) {
    _homeBottomBarName = 'discover';
    pop(context, withAnimation);
    notifyListeners();
  }

  /// 跳转订单列表页
  void goOrders(BuildContext context, { bool withAnimation: true }) {
    _homeBottomBarName = 'orders';
    pop(context, withAnimation);
    notifyListeners();
  }

  /// 跳转个人中心页
  void goPersonal(BuildContext context, { bool withAnimation: true }) {
    _homeBottomBarName = 'personal';
    pop(context, withAnimation);
    notifyListeners();
  }

  pop(BuildContext context, [bool withAnimation = true]) {
  if (withAnimation) {
      router.popTimes(context);
    } else {
      router.remove(context);
    }
  }
}