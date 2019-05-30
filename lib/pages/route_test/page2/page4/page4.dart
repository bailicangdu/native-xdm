import 'package:flutter/material.dart';

class Page4 extends StatefulWidget {

  @override
  _Page4State createState() => _Page4State();
}

class _Page4State extends State<Page4> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('page4'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('page4'),
          onPressed: () {
            // Navigator.pushNamed(context, '/gallery');
          },
        ),
      ),
    );
  }
}