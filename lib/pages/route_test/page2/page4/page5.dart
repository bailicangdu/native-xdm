import 'package:flutter/material.dart';
import 'package:xiaodemo/router/router.dart';

class Page5 extends StatefulWidget {

  @override
  _Page5State createState() => _Page5State();
}

class _Page5State extends State<Page5> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('page5'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('page5'),
          onPressed: () {
            router.pop(context, '我是从上个页面page5回来的');
          },
        ),
      ),
    );
  }
}