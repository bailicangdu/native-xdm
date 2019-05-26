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
      print(DateTime.now().millisecondsSinceEpoch - widget.entryTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('page2'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('推出所有堆栈，并且返回首页'),
          onPressed: () {
            flutor.popNum(context, 4);
          },
        ),
      ),
    );
  }
}