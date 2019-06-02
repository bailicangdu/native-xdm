import 'package:flutter/material.dart';
import 'package:xiaodemo/model/app_model.dart';

class Discover extends StatefulWidget {
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> with AutomaticKeepAliveClientMixin {

  @override
  void initState() {
    super.initState();
    print('discover init');
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var appModel = AppModel.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('discover')
      ),
      body: Container(
        child: Text('discover ' + appModel.count.toString())
      ),
    );
  }
}