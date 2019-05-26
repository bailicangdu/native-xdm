import 'package:flutter/material.dart';

class Personal extends StatefulWidget {
  @override
  _PersonalState createState() => _PersonalState();
}

class _PersonalState extends State<Personal> with AutomaticKeepAliveClientMixin {

  @override
  void initState() {
    super.initState();
    print('personal init');
  }
  
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('personal')
      ),
      body: Container(
        child: Text('personal')
      ),
    );
  }
}