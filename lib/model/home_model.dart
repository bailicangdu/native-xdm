import 'package:scoped_model/scoped_model.dart';

/// scoped_model 是一个类似发布订阅模式的状态管理器
class HomeModel extends Model {
  int _homeCount = 0;

  get homeCount => _homeCount;

  void homeIncrement() {
    _homeCount++;
    _homeCount++;
    notifyListeners();  // 在状态发生变化时，通知所有用到了该model的子项更新状态
  }
}