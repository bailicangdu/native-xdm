import 'package:flutter/material.dart';
import 'package:xiaodemo/router/router.dart';

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
                flutor.popTimes(context);
              },
            ),
            RaisedButton(
              child: Text('popTimes times == 2'),
              onPressed: () {
                flutor.popTimes(context, times: 2);
              },
            ),
            RaisedButton(
              child: Text('popTimes times == 200'),
              onPressed: () {
                flutor.popTimes(context, times: 200);
                // flutor.push(context, name: 'page1');
              },
            ),
            RaisedButton(
              child: Text('popTimes times == -2'),
              onPressed: () {
                flutor.popTimes(context, times: -2);
              },
            ),
            RaisedButton(
              child: Text('remove times == null'),
              onPressed: () {
                flutor.remove(context);
              },
            ),
            RaisedButton(
              child: Text('remove times == 2'),
              onPressed: () {
                flutor.remove(context, times: 2);
              },
            ),
            RaisedButton(
              child: Text('remove times == -2'),
              onPressed: () {
                flutor.remove(context, times: -2);
              },
            ),
            RaisedButton(
              child: Text('pushAndRemove times == 2'),
              onPressed: () {
                flutor.pushAndRemove(context, times: 2, name: 'page1');
              },
            ),
            RaisedButton(
              child: Text('pushAndRemove times == 0'),
              onPressed: () {
                flutor.pushAndRemove(context, times: 0, name: 'page1');
              },
            ),
            RaisedButton(
              child: Text('pushAndRemove times == -2'),
              onPressed: () {
                flutor.pushAndRemove(context, times: -2, name: 'page1');
              },
            ),
            RaisedButton(
              child: Text('pushAndRemove times == null'),
              onPressed: () {
                flutor.pushAndRemove(context, name: 'page1');
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