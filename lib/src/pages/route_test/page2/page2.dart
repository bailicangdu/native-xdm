import 'package:flutter/material.dart';
import 'package:xiaodemo/src/router/router.dart';

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
              child: Text('推出所有堆栈，并且返回首页 --- popTimes'),
              onPressed: () {
                flutor.popTimes(context);
              },
            ),
            RaisedButton(
              child: Text('推出所有堆栈，并且返回前2页 --- popTimes'),
              onPressed: () {
                flutor.popTimes(context, 2);
              },
            ),
            RaisedButton(
              child: Text('推出所有堆栈，并且返回首页 --- remove'),
              onPressed: () {
                flutor.remove(context);
              },
            ),
            RaisedButton(
              child: Text('推出所有堆栈，并且返回前2页 --- remove'),
              onPressed: () {
                flutor.remove(context, 2);
              },
            ),
            RaisedButton(
              child: Text('跳转page'),
              onPressed: () {
                flutor.push(context, name: 'page1');
              },
            ),
          ],
        ),

      ),
    );
  }
}