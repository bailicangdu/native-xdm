import '../utils/flutor/flutor.dart';
import '../pages/home/home.dart';
import 'package:xiaodemo/router/router_demo.dart';
import 'package:xiaodemo/pages/webview/webview.dart';
import 'package:xiaodemo/pages/notfound/notfound.dart';

List<Map<String, dynamic>> routes = [
  {
    'path': '/aaa', // 默认路由，必填
    'name': 'home',
    'widget': ({ Map<String, dynamic>params, Map<String, dynamic>query }) {
      query = {'url': 'http://127.0.0.1:8080/webview.html' };
      // return XDWebView(params: params, query: query);
      return Home();
    },
    'beforeEnter': (RouterNode to, RouterNode from) async {
      print('beforeEnter --- home');
      return true;
    },
  },
  {
    'path': '/webview', // webview页
    'name': 'webview',
    'beforeEnter': (RouterNode to, RouterNode from) async {
      if (to.query == null || !(to.query['url'] is String)) {
        return false;
      }
      return true;
    },
    'widget': ({ Map<String, dynamic>params, Map<String, dynamic>query }) {
      return XDWebView(params: params, query: query);
    },
  },
  {
    'path': '*',
    'widget': ({ Map<String, dynamic>params, Map<String, dynamic>query }) {
      return NotFound();
    },
  },
];

initRoutes(routeList) {
  routeList.addAll(subRoutes);
  return routeList;
}

/// 默认情况下，beforLeave只会监听pop方法，不会监听物理返回，比如安卓下面的返回键，appbar上的返回按钮
/// 如果要监听物理返回操作，需要给添加配置 observeGesture: true; 此时会禁止当前页面左滑关闭页面的操作
/// 
/// 也可以添加全局配置 observeGesture: true; 则不需要给单独路由添加配置，但是会禁止整个app的左滑关闭页面的操作
/// 
final Flutor router = Flutor(
  routes: initRoutes(routes),
  // 跳转之前，先执行全局钩子，再执行独享的钩子
  beforeEach: (RouterNode to, RouterNode from) async {
    print('beforeEach: 当前路由: ' + to.path + '  上一个路由: ' + from.path);
    return true;
  },
  // // 全局后置钩子无法阻止路由进行，所以要future没啥用
  // afterEach: (RouterNode to, RouterNode from) {
  //   print('afterEach: 当前路由: ' + to.path + '  上一个路由: ' + from.path);
  // },
  onError: (FlutorException error) {
    print(error);
  },
  routeStyle: RouterStyle.cupertino, // 路由风格
  observeGesture: false, // 是监听手势操作
);
