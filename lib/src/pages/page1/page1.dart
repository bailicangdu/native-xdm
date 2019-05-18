import 'package:flutter/material.dart';
import '../../router/router.dart';

class Page1 extends StatefulWidget {

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {

  @override
  void initState() {
    super.initState();

    print('init page1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('page1'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('page1'),
              onPressed: () {
                Navigator.pushNamed(context, '/page2');
              },
            ),
            RaisedButton(
              child: Text('通过path跳转'),
              onPressed: () {
                router.push(context, path: '/page2/aaa//page6/bbb?a=1&b=2', params: { 'Page7': 'ccc' }, query: { 'c': 3 });
              },
            ),
            RaisedButton(
              child: Text('通过name跳转'),
              onPressed: () {
                router.push(context, name: 'page7',  params: { 'page4': 'aaa', 'Page7': 'bbb' }, query: {'a': 1, 'b': 2, 'c': 3 });
              },
            ),
          ],
        )
      ),
    );
  }
}