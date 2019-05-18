import 'package:flutter/material.dart';

class Page7 extends StatefulWidget {

  @override
  _Page7State createState() => _Page7State();
}

class _Page7State extends State<Page7> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('page7'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('page7'),
          onPressed: () {
            // Navigator.pushNamed(context, '/gallery');
          },
        ),
      ),
    );
  }
}