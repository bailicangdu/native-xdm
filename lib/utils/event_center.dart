typedef void EventHandle(Event e);


class Event {
  Event({ this.eventName, this.data });
  final Object eventName;
  final Object data;
}

// 发布订阅
class EventCenter {
  EventCenter();

  /// 事件堆栈
  static var _eventStack = Map<Object, List<EventHandle>>();

  //订阅
  void on(eventName, EventHandle f) {
    if (eventName == null || f == null) return;
    _eventStack[eventName] ??= List<EventHandle>();
    _eventStack[eventName].add(f);
  }

  //移除，如果不指定回调函数，则删除所有
  void off(eventName, [EventHandle f]) {
    var list = _eventStack[eventName];
    if (eventName == null || list == null) return;
    if (f == null) {
      _eventStack[eventName] = null;
    } else {
      list.remove(f);
    }
  }

  //触发事件
  void trigger(eventName, [data]) {
    var list = _eventStack[eventName];
    if (list == null) return;
    int len = list.length - 1;
    final event = Event(eventName: eventName, data: data);
    for (var i = len; i > -1; --i) {
      list[i](event);
    }
  }
}

final EventCenter eventCenter = EventCenter();
