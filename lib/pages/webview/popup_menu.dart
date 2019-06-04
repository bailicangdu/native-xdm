import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xiaodemo/event/app_event.dart';

enum MenuOptions {
  home,
  discover,
  orders,
  personal,
}

class PopupMenu extends StatelessWidget {
  const PopupMenu(this._controller)
      : assert(_controller != null);

  final Future<WebViewController> _controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _controller,
      builder: (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        return PopupMenuButton<MenuOptions>(
          offset: Offset(0.0, kToolbarHeight - 10.0),
          elevation: 4.0,
          onSelected: (MenuOptions value) {
            switch (value) {
              case MenuOptions.home:
                appEvent.goHome(context);
                break;
              case MenuOptions.discover:
                appEvent.goDiscover(context);
                break;
              case MenuOptions.orders:
                appEvent.goOrders(context);
                break;
              case MenuOptions.personal:
                appEvent.goPersonal(context);
                break;
            }
          },
          itemBuilder: (BuildContext context) {
            return const <PopupMenuItem<MenuOptions>>[
              const PopupMenuItem<MenuOptions>(
                value: MenuOptions.home,
                child: const Text('首页'),
              ),
              const PopupMenuItem<MenuOptions>(
                value: MenuOptions.discover,
                child: const Text('发现'),
              ),
              const PopupMenuItem<MenuOptions>(
                value: MenuOptions.orders,
                child: const Text('订单'),
              ),
              const PopupMenuItem<MenuOptions>(
                value: MenuOptions.personal,
                child: const Text('我的'),
              ),
            ];
          },
        );
      },
    );
  }
}