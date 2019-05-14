import 'package:flutter/material.dart';
import '../utils/flutor/flutor.dart';
import '../pages/page1/page1.dart';
import '../pages/page2/page2.dart';
import '../pages/page2/page3/page3.dart';
import '../pages/page2/page4/page4.dart';
import '../pages/page2/page4/page5.dart';
import '../pages/page_404/page_404.dart';

final Router router = Router(
  routes: [
    {
      'path': '/page1/:id',
      'name': 'page1',
      // 引入函数是否需要是异步的以支持延迟加载库，这个待定
      // 主要看是延迟加载是否对启动页时间有帮助
      'widget': ({ Map<String, dynamic>params, Map<String, dynamic>query }) {
        return Page1();
      },
    },
    {
      'path': '/page2',
      'name': 'page2',
      'transition': RouterTranstion.slideRight,
      'widget': ({ Map<String, dynamic>params, Map<String, dynamic>query }) {
        return Page2();
      },
      'beforeEnter': (to, from) async {
        return true;
      },
      'beforeLeave': (to, from) async {
        return true;
      },
      'children': [
        {
          'path': 'page3', // 匹配路径/page2/page3
          'name': 'page3',
          'widget': ({ Map<String, dynamic>params, Map<String, dynamic>query }) {
            return Page3();
          },
        },
        {
          'path': '/page4',  // 匹配路径/page2/page4
          'name': 'page4',
          'widget': ({ Map<String, dynamic>params, Map<String, dynamic>query }) {
            return Page4();
          },
          'children': [
            {
              'path': 'page5', // 匹配路径/page4/page5
              'name': 'page5',
              'widget': ({ Map<String, dynamic>params, Map<String, dynamic>query }) {
                return Page5();
              },
            }
          ]
        },
      ],
    },
    // 因为我们的路由规则是强匹配，所以重定向不好写
    // // 重定向
    // { 
    //   'path': '/page2222',
    //   'redirect': {
    //     'path': '/page2',
    //   },
    // },
    // // 重定向命名路由
    // {
    //   'path': '/page2222', 
    //   'redirect': { 
    //     'name': 'page2' 
    //   },
    // },
    {
      'path': '*',
      'widget': ({ Map<String, dynamic>params, Map<String, dynamic>query }) {
        return NotFoundPage();
      },
    },
  ],
  // 跳转之前，先执行全局钩子，再执行独享的钩子
  beforeEach: (to, from) async {
    return true;
  },
  // 全局后置钩子无法阻止路由进行，所以要future没啥用
  afterEach: (to, from) {
    
  },
  onError: (FlutorException error) {
    print(error);
  },
  transition: RouterTranstion.slideRight,
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