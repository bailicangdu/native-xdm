import 'dart:async';
import 'package:flutter/material.dart';
import './define.dart';
import './stack.dart';

class Router {
  Router({ 
    this.routes, 
    this.beforeEach, 
    this.afterEach, 
    this.onError,
    this.transition,
    }) {
    print(routes[0]['widget']);
  }

  List<Map<String, dynamic>> routes;

  final RouterStack _routerStack = RouterStack();

  Future push() {

  }

  Future pop() {

  }

  FutureHookHandle beforeEach;

  VoidHookHandle afterEach;

  VoidCallback onError;

  RouterTranstion transition;

}