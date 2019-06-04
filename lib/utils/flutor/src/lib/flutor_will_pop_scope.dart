import 'package:flutter/material.dart';
import '../define.dart';

/// 阻止手势操作
class FlutorWillPopScope extends StatefulWidget {
  const FlutorWillPopScope({
    Key key,
    @required this.child,
    @required this.matchedRoute,
    @required this.onWillPop,
    this.observeGesture = false,
  }): super(key: key);

  final Widget child;

  final MatchedRoute matchedRoute;

  final WillPopCallback onWillPop;

  final bool observeGesture;

  @override
  _FlutorWillPopScopeState createState() => _FlutorWillPopScopeState();
}

class _FlutorWillPopScopeState extends State<FlutorWillPopScope> {
  ModalRoute<dynamic> _route;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.observeGesture || widget.matchedRoute.route.observeGesture) {
      if (widget.onWillPop != null)
        _route?.removeScopedWillPopCallback(widget.onWillPop);
      _route = ModalRoute.of(context);
      if (widget.onWillPop != null)
        _route?.addScopedWillPopCallback(widget.onWillPop);
    }
  }

  @override
  void didUpdateWidget(FlutorWillPopScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.observeGesture || widget.matchedRoute.route.observeGesture) {
      assert(_route == ModalRoute.of(context));
      if (widget.onWillPop != oldWidget.onWillPop && _route != null) {
        if (oldWidget.onWillPop != null)
          _route.removeScopedWillPopCallback(oldWidget.onWillPop);
        if (widget.onWillPop != null)
          _route.addScopedWillPopCallback(widget.onWillPop);
      }
    }
  }

  @override
  void dispose() {
    if (widget.observeGesture || widget.matchedRoute.route.observeGesture) {
      if (widget.onWillPop != null)
        _route?.removeScopedWillPopCallback(widget.onWillPop);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
