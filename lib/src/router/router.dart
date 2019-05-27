import '../utils/flutor/flutor.dart';
import '../pages/home/home.dart';
import 'package:xiaodemo/src/router/router_demo.dart';

List<Map<String, dynamic>> routes = [
  {
    'path': '/', // 默认路由，必填
    'name': 'home',
    'widget': ({ Map<String, dynamic>params, Map<String, dynamic>query }) {
      return Home();
    },
    'beforeEnter': (RouterNode to, RouterNode from) async {
      print('beforeEnter --- home');
      return true;
    },
  },
];

initRoutes(routeList) {
  routeList.addAll(subRoutes);
  return routeList;
}

final Flutor flutor = Flutor(
  routes: initRoutes(routes),
  // 跳转之前，先执行全局钩子，再执行独享的钩子
  beforeEach: (RouterNode to, RouterNode from) async {
    print('beforeEach: 当前路由: ' + to.path + '  上一个路由: ' + from.path);
    return true;
  },
  // 全局后置钩子无法阻止路由进行，所以要future没啥用
  afterEach: (RouterNode to, RouterNode from) {
    print('afterEach: 当前路由: ' + to.path + '  上一个路由: ' + from.path);
  },
  onError: (FlutorException error) {
    print(error);
  },
  routeStyle: RouterStyle.cupertino, // 路由风格
);
