import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xiaodemo/router/router.dart';

class GetLeading extends StatelessWidget {
  const GetLeading(this._controller) 
      : assert(_controller != null);

  final Future<WebViewController> _controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _controller,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;

        return IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: !webViewReady
              ? null
              : () async {
                  if (await controller.canGoBack()) {
                    controller.goBack();
                  } else {
                    router.pop(context);
                  }
                },
        );
      },
    );
  }
}