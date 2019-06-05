import 'package:flutter/material.dart';
import 'package:xiaodemo/utils/flutor/flutor.dart';
import 'package:xiaodemo/pages/route_test/page1/page1.dart';
import 'package:xiaodemo/pages/route_test/page2/page2.dart';
import 'package:xiaodemo/pages/route_test/page2/page3/page3.dart';
import 'package:xiaodemo/pages/route_test/page2/page4/page4.dart';
import 'package:xiaodemo/pages/route_test/page2/page4/page5.dart';
import 'package:xiaodemo/pages/route_test/page2/page4/page6.dart';
import 'package:xiaodemo/pages/route_test/page2/page4/page7.dart';
import 'package:xiaodemo/pages/route_test/page2/page4/page8.dart';


List<Map<String, dynamic>> subRoutes =[
  {
    // 'path': '/page1/:id',
    'path': '/',
    'name': 'page1',
    'widget': ({ Map<String, dynamic>params, Map<String, dynamic>query }) {
      return Page1();
    },
  },
  {
    'path': '/page2/',
    'name': 'page2',
    // 'transition': RouterTranstion.slideLeft,
    'widget': ({ Map<String, dynamic>params, Map<String, dynamic>query }) {
      return Page2(entryTime: query['entryTime']);
    },
    'beforeEnter': (RouterNode to, RouterNode from) async {
      return true;
    },
    'beforeLeave': (RouterNode to, RouterNode from) async {
      return true;
    },
    'observeGesture': true,
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
            'observeGesture': true,
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
];
