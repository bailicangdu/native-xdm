import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'leading.dart';
import 'popup_menu.dart';
import 'share_menu.dart';


class XDWebView extends StatefulWidget {
  XDWebView({ this.params, this.query });

  final Map<String, dynamic> params;
  final Map<String, dynamic> query;

  @override
  _XDWebViewState createState() => _XDWebViewState();
}

class _XDWebViewState extends State<XDWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  String pageTitle = ''; // 标题

  List<Widget> _actions = []; // 头部action按钮

  @override
  void initState() {
    super.initState();
    _actions.add(PopupMenu(_controller.future));
    // _actions.insert(0, ShareMenu(_controller.future));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: GetLeading(_controller.future),
        actions: _actions,
      ),
      body: Builder(
        builder: (BuildContext context) {
          return WebView(
            initialUrl: widget.query['url'],
            // js模式-无限制
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              // 确保webview创建完成，才可以执行controller操作
              _controller.complete(webViewController); 
            },
            // jsbridge
            javascriptChannels: _setJavascriptChannels(context).toSet(),
            // 监听路由变化
            navigationDelegate: (NavigationRequest request) {
              // 这里可以做一些跳转拦截/重定向
              // if (request.url.startsWith('https://www.youtube.com/')) {
              //   return NavigationDecision.prevent; // 禁止跳转
              // }

              print('navigationDelegate -- 跳转页面 ${request.url}');
              return NavigationDecision.navigate; // 允许跳转
            },
            onPageFinished: (String url) async {
              var controller = await _controller.future;
              _initData(controller, context);
              print('页面加载完成: $url');
            },
          );
        },
      ),
    );
  }

  // 设置初始化数据
  _initData(WebViewController controller, BuildContext context) {
    const String  initScript = '''
  window.SetTitle.postMessage(document.title);
  var MutationObserver = window.MutationObserver || window.WebKitMutationObserver;
  var MutationObserverConfig = {
    childList: true,
    subtree: true,
    characterData: true
  };
  var observer = new MutationObserver(function (mutations) {
    window.SetTitle.postMessage(document.title);
  });
  observer.observe(document.querySelector('title'), MutationObserverConfig);
''';
    controller.evaluateJavascript(initScript);
  }

  // jsbridge 定义
  List<JavascriptChannel> _setJavascriptChannels(BuildContext context) {
    List<JavascriptChannel> javascriptChannels = [
      // 设置标题
      JavascriptChannel(
        name: 'SetTitle',
        onMessageReceived: _setTitleHandle,
      ),
      JavascriptChannel(
        name: 'InitShareBtn',
        onMessageReceived: _initShareBtn,
      ),
      JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
      }),
    ];

    return javascriptChannels;
  }

  /// jsbridge处理函数
  _setTitleHandle(JavascriptMessage message) {
    if (message.message != null) {
      setState(() {
        pageTitle = message.message;
      });
    }
  }

  /// 设置分享标题
  _initShareBtn(JavascriptMessage message) {
    if (_actions.any((item) => item is ShareMenu)) {
      return;
    }
    setState(() {
      _actions.insert(0, ShareMenu(_controller.future));
    });
  }

}
