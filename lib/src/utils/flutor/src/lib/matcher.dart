import 'package:flutter/material.dart';
import '../define.dart';
import './utils.dart';

class RouterMatcher {
  RouterMatcher(this.routes) {
    getNamedStack(routes);
  }

  Map<String, RouterOption> namedStack = {};
  final List<RouterOption>routes;

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

  MatchedRoute findByPath(String path) {
    String queryStr = '';
    if (path.contains('?')) {
      final List<String> splitPath = path.split('?');
      path = ('/' + splitPath[0]).replaceAll(RegExp(r'//'), '/').trim();
      queryStr = splitPath[1];
    }
    Map<String, dynamic> query = RouterUtils.formatQuery(queryStr);
    if (path.endsWith('/') && path != Navigator.defaultRouteName) {
      path = path.replaceAll(RegExp(r'/$'), '');
    }

    RouterOption targetRoute = _matchPath(path, routes);
    Map<String, dynamic>params = _getPathPrams(path, targetRoute);
    return MatchedRoute(targetRoute, params: params, query: query);
  }

  // 我感觉这个匹配规则还是有点问题的，但是因为我中午没睡，所以现在脑子不太好使，明天再来检查
  _matchPath(String path, List<RouterOption> routes) {
    RouterOption targetRoute;
    RouterOption defaultRoute;
    
    for (RouterOption route in routes) {
      if (route.path.endsWith('/*')) {
        defaultRoute = route;
        continue;
      }
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