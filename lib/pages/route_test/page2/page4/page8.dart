import 'package:flutter/material.dart';
import 'package:xiaodemo/router/router.dart';

class Page8 extends StatefulWidget {

  @override
  _Page8State createState() => _Page8State();
}

class _Page8State extends State<Page8> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('page8'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('page8'),
          onPressed: () {
            router.pop(context);
          },
        ),
      ),
    );
  }
}