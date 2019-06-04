import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ShareMenu extends StatelessWidget {
  const ShareMenu(this._controller)
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
          icon: const Icon(Icons.share),
          onPressed: !webViewReady
              ? null
              : () async {
                  controller.reload();
                },
        );
      },
    );
  }
}