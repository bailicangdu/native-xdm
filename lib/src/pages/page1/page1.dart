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
                print(DateTime.now().millisecondsSinceEpoch);
              },
            ),
            RaisedButton(
              child: Text('通过router跳转page2'),
              onPressed: () {
                router.push(context, path: '/page2');
              },
            ),
          ],
        )
      ),
    );
  }
}