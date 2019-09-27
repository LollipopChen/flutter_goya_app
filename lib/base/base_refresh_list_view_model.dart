import 'package:flutter/cupertino.dart';
import 'package:flutter_goya_app/base/base_list_view_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class BaseRefreshListViewModel<T> extends BaseViewStateListViewModel<T>{

  /// 分页第一页页码
  static const int pageNumFirst = 0;
  /// 分页条目数量
  static const int pageSize = 20;

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  RefreshController get refreshController => _refreshController;

  /// 当前页码
  int _currentPageNum = pageNumFirst;

  ///下拉刷新
  Future<List<T>> refreshList({@required BuildContext context,bool isRefreshed = false}) async{
    try {
      _currentPageNum = pageNumFirst;
      var data = await loadData(pageNum: pageNumFirst);
      if (data.isEmpty) {
        onEmpty();
      } else {
        onCompleted(data);
        list.clear();
        list.addAll(data);
        refreshController.refreshCompleted();
        if (data.length < pageSize) {
          refreshController.loadNoData();
        } else {
          //防止上次上拉加载更多失败,需要重置状态
          refreshController.loadComplete();
        }
        if (isRefreshed) {
          //改变页面状态为非加载中
          loading(false);
        } else {
          notifyListeners();
        }
      }
      return data;
    }catch (e, s) {
      handleCatch(e, s);
      return null;
    }
  }

  /// 上拉加载更多
  Future<List<T>> loadMore() async {
    try {
      var data = await loadData(pageNum: ++_currentPageNum);
      if (data.isEmpty) {
        _currentPageNum--;
        refreshController.loadNoData();
      } else {
        onCompleted(data);
        list.addAll(data);
        if (data.length < pageSize) {
          refreshController.loadNoData();
        } else {
          refreshController.loadComplete();
        }
        notifyListeners();
      }
      return data;
    } catch (e, s) {
      _currentPageNum--;
      refreshController.loadFailed();
      debugPrint('error--->\n' + e.toString());
      debugPrint('statck--->\n' + s.toString());
      return null;
    }
  }

  // 加载数据
  Future<List<T>> loadData({int pageNum});
}