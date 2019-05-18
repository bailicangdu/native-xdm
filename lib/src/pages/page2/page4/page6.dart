import 'package:flutter/material.dart';

class Page6 extends StatefulWidget {

  @override
  _Page6State createState() => _Page6State();
}

class _Page6State extends State<Page6> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('page6'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('page6'),
          onPressed: () {
            // Navigator.pushNamed(context, '/gallery');
          },
        ),
      ),
    );
  }
}