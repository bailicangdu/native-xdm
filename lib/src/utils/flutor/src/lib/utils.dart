import '../define.dart';

class RouterUtils {

  static List<RouterOption> setRoutes(List<Map<String, dynamic>>routes) {
    final List<RouterOption> routeOptionList = routes.map((item) => RouterOption.fromMap(item)).toList();
    return routeOptionList;
  }
}