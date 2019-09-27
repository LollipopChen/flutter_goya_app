import 'package:flutter/cupertino.dart';
import 'package:flutter_goya_app/base/base_view_model.dart';
import 'package:flutter_goya_app/net/api.dart';
import 'package:flutter_goya_app/provider/view_state.dart';

///列表类型的Base ViewModel
abstract class BaseViewStateListViewModel<T> extends BaseViewModel<T> {
  ///页面数据
  List<T> list = [];
  /// 当前的页面状态
  ViewState _viewState;
  ViewState get viewState => _viewState;

  ///第一次进入页面Loading skeleton
  initData(BuildContext context) async {
    loading(true);
    await refresh(context: context, isRefreshed: true);
  }

  ///下拉刷新
  refresh({@required BuildContext context, bool isRefreshed}) async {
    try {
      List<T> data = await loadData();
      if (data.isEmpty) {
        onEmpty();
      } else {
        onCompleted(data);
        list = data;
        if (isRefreshed) {
          //改变页面状态为非加载中
          loading(false);
        } else {
          notifyListeners();
        }
      }
    } catch (e, s) {
      handleCatch(e, s);
    }
  }

  ///加载中
  void loading(bool isLoading){
    if(isLoading){
      _viewState = ViewState.loading;
    }else{
      _viewState = ViewState.completed;
    }
    notifyListeners();
  }

  ///无数据
  void onEmpty(){
    _viewState = ViewState.empty;
    notifyListeners();
  }

  ///完成
  @protected
  void onCompleted(List<T> data){
    loading(false);
    notifyListeners();
  }

  // 加载数据
  Future<List<T>> loadData();

  ///错误信息
  @protected
  void setError(String message){
    _viewState = ViewState.error;
    notifyListeners();
  }

  /// Handle Error and Exception
  ///
  /// 统一处理子类的异常情况
  /// [e],有可能是Error,也有可能是Exception.所以需要判断处理
  /// [s] 为堆栈信息
  void handleCatch(e, s) {
    // DioError的判断,理论不应该拿进来,增强了代码耦合性,抽取为时组件时.应移除
    if (e is DioError && e.error is UnAuthorizedException) {
      setError('未知错误');
    } else {
      debugPrint('error--->\n' + e.toString());
      debugPrint('statck--->\n' + s.toString());
      setError(e is Error ? e.toString() : e.message);
    }
  }
}
