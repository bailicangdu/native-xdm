import 'package:flutter/material.dart';
import 'package:xiaodemo/router/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:xiaodemo/event/app_event.dart';

class Page2 extends StatefulWidget {
  Page2({this.entryTime});
  final int entryTime;

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {

  @override
  void initState() {
    super.initState();

    print('init page2');
    if (widget.entryTime != null) {
      // print(DateTime.now().millisecondsSinceEpoch - widget.entryTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('page2'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('popTimes times == null'),
              onPressed: () {
                router.popTimes(context);
              },
            ),
            RaisedButton(
              child: Text('popTimes times == 2'),
              onPressed: () {
                router.popTimes(context, times: 2);
              },
            ),
            RaisedButton(
              child: Text('popTimes times == 200'),
              onPressed: () {
                router.popTimes(context, times: 200);
                // router.push(context, name: 'page1');
              },
            ),
            RaisedButton(
              child: Text('popTimes times == -2'),
              onPressed: () {
                router.popTimes(context, times: -2);
              },
            ),
            RaisedButton(
              child: Text('remove times == null'),
              onPressed: () {
                router.remove(context);
              },
            ),
            RaisedButton(
              child: Text('remove times == 2'),
              onPressed: () {
                router.remove(context, times: 2);
              },
            ),
            RaisedButton(
              child: Text('remove times == -2'),
              onPressed: () {
                router.remove(context, times: -2);
              },
            ),
            RaisedButton(
              child: Text('pushAndRemove times == 2'),
              onPressed: () {
                router.pushAndRemove(context, times: 2, name: 'page1');
              },
            ),
            RaisedButton(
              child: Text('pushAndRemove times == 0'),
              onPressed: () {
                router.pushAndRemove(context, times: 0, name: 'page1');
              },
            ),
            RaisedButton(
              child: Text('pushAndRemove times == -2'),
              onPressed: () {
                router.pushAndRemove(context, times: -2, name: 'page1');
              },
            ),
            RaisedButton(
              child: Text('pushAndRemove times == null'),
              onPressed: () {
                router.pushAndRemove(context, name: 'page1');
              },
            ),
            RaisedButton(
              child: Text('跳转page'),
              onPressed: () {
                router.push(context, name: 'page1');
              },
            ),
            RaisedButton(
              child: Text('弹框'),
              onPressed: () async {
                var a = await showCupertinoDialog(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    title: const Text('Discard draft?'),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: const Text('Discard'),
                        isDestructiveAction: true,
                        onPressed: () {
                          router.pop(context, 'Discard');
                          // router.push(context, name: 'page1');
                          // router.pushAndRemove(context, times: 1, name: 'page1');
                        },
                      ),
                      CupertinoDialogAction(
                        child: const Text('Cancel'),
                        isDefaultAction: true,
                        onPressed: () {
                          Navigator.pop(context, 'Cancel');
                        },
                      ),
                    ],
                  ),
                );
                print(a);
              },
            ),
            RaisedButton(
              child: Text('跳转discover'),
              onPressed: () {
                appEvent.goDiscover(context);
              },
            ),
            RaisedButton(
              child: Text('跳转personal'),
              onPressed: () {
                appEvent.goPersonal(context, withAnimation: false);
              },
            ),
            RaisedButton(
              child: Text('跳转webview'),
              onPressed: () {
                router.push(context, name: 'webview', query: { 'url': 'http://127.0.0.1:8080/webview.html' });
              },
            ),
          ],
        ),

      ),
    );
  }
}