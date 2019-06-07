import 'package:flutter/material.dart';
import 'package:xiaodemo/router/router.dart';
import 'package:xiaodemo/utils/flutor/flutor.dart';

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
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('跳转page5--push'),
              onPressed: () async {
                var result = await router.push(context, path: '/page2/123/page5');
                print(result);
              },
            ),
            RaisedButton(
              child: Text('跳转page5--replace'),
              onPressed: () {
                router.replace(context, path: '/page2/456/page5');
              },
            ),
            RaisedButton(
              child: Text('pop'),
              onPressed: () {
                router.pop(context);
              },
            ),
            RaisedButton(
              child: Text('跳转page5--none'),
              onPressed: () {
                router.push(context, path: '/page2/456/page5', transition: RouterTranstion.none);
              },
            ),
            RaisedButton(
              child: Text('跳转page5--auto'),
              onPressed: () {
                router.push(context, path: '/page2/456/page5', transition: RouterTranstion.auto);
              },
            ),
            RaisedButton(
              child: Text('跳转page5--slideRight'),
              onPressed: () {
                router.push(context, path: '/page2/456/page5', transition: RouterTranstion.slideRight);
              },
            ),
            RaisedButton(
              child: Text('跳转page5--slideLeft'),
              onPressed: () {
                router.push(context, path: '/page2/456/page5', transition: RouterTranstion.slideLeft);
              },
            ),
            RaisedButton(
              child: Text('跳转page5--slideBottom'),
              onPressed: () {
                router.push(context, path: '/page2/456/page5', transition: RouterTranstion.slideBottom);
              },
            ),
            RaisedButton(
              child: Text('跳转page5--fadeIn'),
              onPressed: () {
                router.push(context, path: '/page2/456/page5', transition: RouterTranstion.fadeIn);
              },
            ),
            RaisedButton(
              child: Text('跳转page5--custom'),
              onPressed: () {
                router.push(
                  context, path: '/page2/456/page5', 
                  transition: RouterTranstion.custom, 
                  transitionsBuilder: (
                    BuildContext context, 
                    Animation<double> animation,
                    Animation<double> secondaryAnimation, 
                    Widget child,
                  ) {
                    return ScaleTransition(
                      scale: animation,
                      child: new RotationTransition(
                        turns: animation,
                        child: child,
                      ),
                    );
                  },
                );
              },
            ),
            RaisedButton(
              child: Text('跳转page4--全局配置'),
              onPressed: () {
                router.push(context, path: '/page2/xxx');
              },
            ),
            RaisedButton(
              child: Text('跳转page3--单独配置'),
              onPressed: () {
                router.push(context, path: '/page2/page3');
              },
            ),
          ],
        ),
      ),
    );
  }
}