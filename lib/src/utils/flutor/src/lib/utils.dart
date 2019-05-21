import 'package:flutter/material.dart';
import '../define.dart';

class RouterUtils {
  /// 将map数据转换为RouterOption对象
  static List<RouterOption> initRoutes(List<Map<String, dynamic>>routes, { String parentPath = ''}) {
    // 递归初始化
    final List<RouterOption> routeOptionList = routes.map((route) {
      route['path'] = RouterUtils.getFullPath(route['path'], parentPath);
      route = RouterUtils.getRegAndParam(route);
      if (route['children'] is List) {
        route['children'] = initRoutes(route['children'], parentPath: route['path']);
      }
      return RouterOption.fromMap(route);
    }).toList();
    return routeOptionList;
  }

  /// 获取完整路由
  static String getFullPath(String path, String parentPath) {
    String fullPath = (parentPath + '/' + path).replaceAll(RegExp(r'//'), '/').trim();
    // 对于非根路由，不能以 '/' 结尾
    if (fullPath.endsWith('/') && fullPath != Navigator.defaultRouteName) {
      fullPath = fullPath.replaceAll(RegExp(r'/$'), '');
    }
    return fullPath;
  }

  /// 获取匹配正则和params名称
  static Map<String, dynamic> getRegAndParam(Map<String, dynamic> route) {
    RegExp paramExp = RegExp(r'/:([^/]+)');
    var matches = paramExp.allMatches(route['path']);
    for (Match match in matches) {
      if (route['paramName'] is List<String>) {
        route['paramName'].add(match.group(1));
      } else {
        route['paramName'] = <String>[match.group(1)];
      }
    }
    route['regexp'] = '^' + route['path'].replaceAll(RegExp(r'/:([^/]+)'), '/([^/]+)');
    // 这个暂时没用上，先放着
    if (route['regexp'] == '/*') {
      route['regexp'] = '.*'; 
    } else if (route['regexp'].endsWith('*')) {
      route['regexp'] = route['regexp'].replaceAll(RegExp(r'\*$'), '.+');
    }
    return route;
  }

  /// 获取query
  static Map<String, dynamic> formatQuery(String queryStr) {
    RegExp queryRegExp = RegExp(r'([^&=]+)=?([^&]*)');
    Map<String, dynamic> queryMap = Map();
    queryStr = Uri.decodeComponent(queryStr);
    for (Match match in queryRegExp.allMatches(queryStr)) {
      String key = match.group(1);
      String value = match.group(2) ?? '';
      queryMap[key] = value;
    }
    return queryMap;
  }
}