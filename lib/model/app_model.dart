import 'package:scoped_model/scoped_model.dart';
import './home_model.dart';

/// scoped_model 是一个类似发布订阅模式的状态管理器
class AppModel extends Model with HomeModel {
  int _count = 0;

  get count => _count;

  void increment() {
    _count++;
    notifyListeners();  // 在状态发生变化时，通知所有用到了该model的子项更新状态
  }

  static AppModel of(context, { rebuildOnChange = true }) => ScopedModel.of<AppModel>(context, rebuildOnChange: rebuildOnChange);
}