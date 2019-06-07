import 'package:flutter/material.dart';
import 'package:xiaodemo/model/app_model.dart';
import 'package:xiaodemo/router/router.dart';

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
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final AppModel appModel = AppModel.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('首页')
      ),
      body: Container(
        child: RaisedButton(
          child: Text(_testnum.toString() + ' ' + appModel.count.toString()),
          onPressed: ()  async {
            appModel.increment();
            setState((){
              _testnum++;
            });
            if (_testnum % 3 == 0) {
              // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Page1()));
              router.push(context, name: 'page1');
            }
          },
        ),
      ),
    );
  }
}