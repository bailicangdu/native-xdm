import 'package:flutter/material.dart';

class Page3 extends StatefulWidget {

  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('page3'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('page3'),
          onPressed: () {
            // Navigator.pushNamed(context, '/gallery');
          },
        ),
      ),
    );
  }
}