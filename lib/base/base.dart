import 'package:flutter/widgets.dart';

///所有viewModel的父类，提供一些公共功能
abstract class BaseViewModel<T> {
  bool _isFirst = true;

  bool get isFirst => _isFirst;

  @mustCallSuper
  void init(BuildContext context) {
    if (_isFirst) {
      _isFirst = false;
      doInit(context);
    }
  }

  ///获取数据
  Future<T> refreshData(BuildContext context){
    return null;
  }

  ///获取列表数据
  Future<List<T>> refreshListData(BuildContext context){
    return null;
  }

  @protected
  void doInit(BuildContext context);

  void dispose();
}