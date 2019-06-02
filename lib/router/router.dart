import '../utils/flutor/flutor.dart';
import '../pages/home/home.dart';
import 'package:xiaodemo/router/router_demo.dart';

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

/// 默认情况下，全局钩子和子路由的钩子函数是不会监听物理返回的，比如安卓下面的返回键，appbar上的返回按钮
/// 如果要监听这种物理返回操作，需要添加全局配置 preventGesture: true; 此时会根据beforLeave的返回值来决定路由是否可以返回
/// 同时会禁止路由的手势操作，即左滑返回上一个页面
/// 如果不想禁止整个路由系统的左滑手势操作，可以给单个子路由添加 preventGesture: true;此时只会禁止当前页面的左滑关闭页面
final Flutor flutor = Flutor(
  routes: initRoutes(routes),
  // 跳转之前，先执行全局钩子，再执行独享的钩子
  beforeEach: (RouterNode to, RouterNode from) async {
    print('beforeEach: 当前路由: ' + to?.path + '  上一个路由: ' + from?.path);
    return true;
  },
  // 全局后置钩子无法阻止路由进行，所以要future没啥用
  afterEach: (RouterNode to, RouterNode from) {
    print('afterEach: 当前路由: ' + to?.path + '  上一个路由: ' + from?.path);
  },
  onError: (FlutorException error) {
    print(error);
  },
  routeStyle: RouterStyle.cupertino, // 路由风格
  observeGesture: false, // 是监听手势操作
);
