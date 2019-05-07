import 'dart:async';
import 'package:flutter/material.dart';
import './define.dart';
import './stack.dart';

class Router {

  Router({ this.routes }) {
    print(routes[0]['widget']);
  }

  List<Map<String, dynamic>> routes;

  final RouterStack _routerStack = RouterStack();

  Future push() {

  }

  Future pop() {

  }

}