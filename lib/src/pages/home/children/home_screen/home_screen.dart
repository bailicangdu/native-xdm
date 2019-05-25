import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {

  int _testnum = 0;

  @override
  void initState() {
    super.initState();
    print('homescreen init');
    print(_testnum);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('首页')
      ),
      body: Container(
        child: RaisedButton(
          child: Text(_testnum.toString()),
          onPressed: () {
            setState(() {
              _testnum++;
            });
          },
        ),
      ),
    );
  }
}