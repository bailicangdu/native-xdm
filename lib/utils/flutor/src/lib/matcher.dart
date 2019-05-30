import 'package:flutter/material.dart';
import '../define.dart';
import './utils.dart';

/// 路由匹配
class RouterMatcher {
  RouterMatcher(this.routes) {
    getNamedStack(routes);
  }

  Map<String, RouterOption> namedStack = {};
  final List<RouterOption>routes;

  /// 查找命名路由，如果名称相同，则覆盖
  void getNamedStack(List<RouterOption>routes) {
    for (RouterOption route in routes) {
      if (route.name != null) {
        namedStack[route.name] = route;
      }
      if (route.children != null && route.children.isNotEmpty) {
        getNamedStack(route.children);
      }
    }
  }

  /// 通过path查找路由
  MatchedRoute findByPath(String path) {
    String queryStr = '';
    if (path.contains('?')) {
      final List<String> splitPath = path.split('?');
      path = splitPath[0];
      queryStr = splitPath[1];
    }
    // 路由格式化
    path = ('/' + path).replaceAll(RegExp(r'//'), '/').trim();
    if (path.endsWith('/') && path != Navigator.defaultRouteName) {
      path = path.replaceAll(RegExp(r'/$'), '');
    }

    RouterOption targetRoute = _matchPath(path, routes);
    Map<String, dynamic>params = _getPathPrams(path, targetRoute);
    return MatchedRoute(targetRoute, params: params, query: RouterUtils.formatQuery(queryStr));
  }

  // 递归匹配所有路由
  _matchPath(String path, List<RouterOption> routes) {
    RouterOption targetRoute;
    RouterOption defaultRoute;
    
    for (RouterOption route in routes) {
      // 以 /* 结尾则为当前路由层级的默认路由
      if (route.path.endsWith('/*')) {
        defaultRoute = route;
        continue;
      }
      /// 正则匹配成功并且完全匹配，则为目标路由
      /// 否则递归查找子级路由，如果还没找到，则执行下一轮，如果找到则停止匹配
      if (RegExp(route.regexp).hasMatch(path)) {
        if (RegExp('${route.regexp}\$').hasMatch(path)) {
          targetRoute = route;
          break;
        } else if (route.children != null) {
          targetRoute = _matchPath(path, route.children);
        }
      }
      if (targetRoute != null) {
        break;
      }
    }
    return targetRoute ?? defaultRoute;
  }

  /// 获取params
  Map<String, dynamic> _getPathPrams(String path, RouterOption route) {
    Map<String, dynamic> params = {};
    if (route == null) {
      return params;
    } 
    RegExp('${route.regexp}\$').allMatches(path).map((match) {
      if (match!= null && match.groupCount > 0) {
        for (var i = 0; i < match.groupCount; i++) {
          params[route.paramName[i]] = match.group(i + 1);
        }
      }
    }).toList();
    return params;
  }

  // 通过name查找路由
  MatchedRoute findByName(String name) {
    RouterOption defaultRoute;
    for (RouterOption route in routes) {
      if (route.path == '/*') {
        defaultRoute = route;
      }
    }
    return MatchedRoute(namedStack[name]) ?? MatchedRoute(defaultRoute);
  }
}