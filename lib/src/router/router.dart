import 'package:flutter/material.dart';
import '../utils/router/router.dart';
import '../pages/page1/page1.dart';
import '../pages/page2/page2.dart';
import '../pages/page2/page3/page3.dart';
import '../pages/page2/page4/page4.dart';
import '../pages/page_404/page_404.dart';

Router router = Router(
  routes: [
    {
      'path': '/page1/:name',
      'widget': ({ Map<String, String>params, Map<String, String>query }) {
        return Page1();
      },
    },
    {
      'path': '/page2',
      'name': 'page2',
      'transition': 'xxx',
      'widget': ({ Map<String, String>params, Map<String, String>query }) {
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
          'widget': ({ Map<String, String>params, Map<String, String>query }) {
            return Page3();
          },
        },
        {
          'path': '/page4',  // 匹配路径/page4
          'name': 'page4',
          'widget': ({ Map<String, String>params, Map<String, String>query }) {
            return Page4();
          },
        },
      ],
    },
    {
      'path': '*',
      'widget': NotFound, // 404页面
    },
  ],
  // 路由钩子
  beforeEach: (to, from) async {
    return true;
  },
  afterEach: (to, from) async {
    return true;
  },
);

/**
 * router.push(context, '/page1/dog?a=1&b=2', transition: TransitionType.slideLeft);
 * 
 * router.push(context, '/page1/dog?a=1&b=2',  );
 */