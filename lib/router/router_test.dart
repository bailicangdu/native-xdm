import 'package:flutter/material.dart';
import '../utils/flutor/flutor.dart';
import '../pages/home/home.dart';
import '../pages/route_test/page1/page1.dart';
import '../pages/route_test/page2/page2.dart';
import '../pages/route_test/page2/page3/page3.dart';
import '../pages/route_test/page2/page4/page4.dart';
import '../pages/route_test/page2/page4/page5.dart';
import '../pages/route_test/page2/page4/page6.dart';
import '../pages/route_test/page2/page4/page7.dart';
import '../pages/route_test/page2/page4/page8.dart';
import '../pages/notfound/notfound.dart';

/*
 * 1、引入函数是否需要是异步的以支持延迟加载库，这个待定，主要看是延迟加载是否对启动页时间有帮助
 * 
 * 2、使用系统自带Navigator进行跳转会产生一些意想不到的问题
 * 
 * 3、重定向redirect有没有必要做？
 * 
 * 4、首页初始化时的 transition和beforeEnter是不会触发的
 * 
 * 
 */
final Flutor flutor = Flutor(
  routes: [
    {
      'path': '/', // 默认路由，必填
      'name': 'home',
      'widget': ({ Map<String, dynamic>params, Map<String, dynamic>query }) {
        return Home();
      },
      // 问题：在初始化app时，transition和beforeEnter是不会触发的
      'transition': RouterTranstion.custom,
      'transitionDuration': Duration(milliseconds: 1000),
      'transitionsBuilder': (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation, 
        Widget child,
      ) {
        return ScaleTransition(
          scale: animation,
          child: new RotationTransition(
            turns: animation,
            child: child,
          ),
        );
      },
      'beforeEnter': (RouterNode to, RouterNode from) async {
        print('home beforeEnter');
        return true;
      },
      'beforeLeave': (RouterNode to, RouterNode from) async {
        print('home beforeLeave');
        return true;
      },
    },
    {
      'path': '/page1/:id',
      'name': 'page1',
      'widget': ({ Map<String, dynamic>params, Map<String, dynamic>query }) {
        return Page1();
      },
    },
    {
      'path': '/page2/',
      'name': 'page2',
      'transition': RouterTranstion.slideLeft,
      'widget': ({ Map<String, dynamic>params, Map<String, dynamic>query }) {
        return Page2(entryTime: query['entryTime']);
      },
      'beforeEnter': (RouterNode to, RouterNode from) async {
        return true;
      },
      'beforeLeave': (RouterNode to, RouterNode from) async {
        return true;
      },
      'children': [
        {
          'path': 'page3', // 匹配路径/page2/page3
          'name': 'page3',
          'widget': ({ Map<String, dynamic>params, Map<String, dynamic>query }) {
            return Page3();
          },
          'transition': RouterTranstion.custom,
          'transitionDuration': const Duration(milliseconds: 1000),
          'transitionsBuilder': (
            BuildContext context, 
            Animation<double> animation,
            Animation<double> secondaryAnimation, 
            Widget child,
          ) {
            return ScaleTransition(
              scale: animation,
              child: new RotationTransition(
                turns: animation,
                child: child,
              ),
            );
          },
          'beforeEnter': (RouterNode to, RouterNode from) async {
            print('page3 beforeEnter');
            return true;
          },
          'beforeLeave': (RouterNode to, RouterNode from) async {
            print('page3 beforeLeave');
            return true;
          },
        },
        {
          'path': '/:page4',  // 匹配路径/page2/:page4
          'name': 'page4',
          'widget': ({ Map<String, dynamic>params, Map<String, dynamic>query }) {
            return Page4();
          },
          'children': [
            {
              'path': 'page5', // 匹配路径/page2/:page4/page5
              'name': 'page5',
              'widget': ({ Map<String, dynamic>params, Map<String, dynamic>query }) {
                return Page5();
              },
              'beforeEnter': (RouterNode to, RouterNode from) async {
                print('page5 beforeEnter');
                return true;
              },
              'beforeLeave': (RouterNode to, RouterNode from) async {
                print('page5 beforeLeave');
                return true;
              },
            },
            {
              'path': 'page6', // 匹配路径/page2/:page4/page6
              'name': 'page6',
              'widget': ({ Map<String, dynamic>params, Map<String, dynamic>query }) {
                return Page6();
              },
              'children': [
                {
                  'path': ':Page7/', // 匹配路径/page2/:page4/page6/:page7
                  'name': 'page7',
                  'widget': ({ Map<String, dynamic>params, Map<String, dynamic>query }) {
                    return Page7();
                  },
                  'beforeEnter': (RouterNode to, RouterNode from) async {
                    print('page7 beforeEnter');
                    return true;
                  },
                  'beforeLeave': (RouterNode to, RouterNode from) async {
                    print('page7 beforeLeave');
                    return true;
                  },
                },
                {
                  'path': '/:page8', // 匹配路径/page2/:page4/page6/:page8
                  'name': 'page8',
                  'widget': ({ Map<String, dynamic>params, Map<String, dynamic>query }) {
                    return Page8();
                  },
                },
              ],
            }
          ]
        },
        {
          'path': '*', // 匹配路径/page2/
          'name': 'detaultPage2',
          'widget': ({ Map<String, dynamic>params, Map<String, dynamic>query }) {
            return Page2(entryTime: query['entryTime']);
          },
        },
      ],
    },
    {
      'path': '/page/pagex',
      'widget': ({ Map<String, dynamic>params, Map<String, dynamic>query }) {
        return Page8();
      },
    },
    {
      'path': '/page/pagex/pagexx',
      'widget': ({ Map<String, dynamic>params, Map<String, dynamic>query }) {
        return Page8();
      },
    },
    {
      'path': '*',
      'widget': ({ Map<String, dynamic>params, Map<String, dynamic>query }) {
        return NotFound();
      },
    },
  ],
  // 跳转之前，先执行全局钩子，再执行独享的钩子
  beforeEach: (RouterNode to, RouterNode from) async {
    print('beforeEach: 当前路由:' + to.path + '  上一个路由:' + from.path);
    return true;
  },
  // 全局后置钩子无法阻止路由进行，所以要future没啥用
  afterEach: (RouterNode to, RouterNode from) {
    String preRouteName = '';
    if (from.route == null) {
      preRouteName = 'null';
    }else {
      preRouteName = from.route.settings.name;
    }
    print('afterEach: 当前路由:' + to.route.settings.name + '  上一个路由:' + preRouteName);
  },
  onError: (FlutorException error) {
    print(error);
  },
  // transition: RouterTranstion.slideLeft,
);

/**
 * router.push(context, path: '/page1/1?a=1&b=2', transition: RouterTranstion.slideRight);
 * 
 * router.push(context, path: '/page1/1', query: { 'c': 3 });
 * 
 * router.push(context, path: '/page1/1?a=1&b=2', params: { 'id': '123' }, query: { 'c': 3 });
 * 
 * router.push(context, name: 'page1', params: { 'id': '123' }, query: { 'c': 3 });
 * 
 * router.replace 同上
 * 
 * 错误示范：
 * router.push(context, path: '/page1', params: { 'id': '123' });
 * 
 * 注意：
 *  和h5不同的是，如果路由相同但是参数不同，也会放入一个新的堆栈，并新开一个页面
 */