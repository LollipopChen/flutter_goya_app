import 'package:flutter/material.dart';
import 'package:flutter_goya_app/base/base_view_model.dart';
import 'package:flutter_goya_app/entity/project_list_entity.dart';
import 'package:flutter_goya_app/entity/we_chat_list_entity.dart';
import 'package:flutter_goya_app/repository/wan_android_repository.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

class WeChatListViewModel extends BaseViewModel {
  /// 分页第一页页码
  static const int pageNumFirst = 1;

  /// 当前页码
  int _currentPageNum = pageNumFirst;

  //文章数据
  BehaviorSubject<List<WeChatListData>> _projectListObservable =
      BehaviorSubject();

  Stream<List<WeChatListData>> get projectListStream =>
      _projectListObservable.stream;

  List<WeChatListData> articleList = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  RefreshController get refreshController => _refreshController;

  bool isRefresh = true;

  @override
  void doInit(BuildContext context) {
  }

  @override
  void dispose() {
//    _projectListObservable.close();
//    _refreshController.dispose();
    super.dispose();
  }

  ///获取文章数据
  Future<WeChatListEntity> loadWeChatListData(BuildContext context, int pageNum,
      {int cid}) async {
    return await WanAndroidRepository.fetchWeChatArticles(pageNum, cid)
        .then((WeChatListEntity weChatListEntity) {
      var data = weChatListEntity.datas;
      if (weChatListEntity.datas.isEmpty && !isRefresh) {
        _currentPageNum--;
      }
      if(isRefresh){
        refreshController.refreshCompleted();
      }else{
        //防止上次上拉加载更多失败,需要重置状态
        refreshController.loadComplete();
      }

      if (data.length == weChatListEntity.total) {
        refreshController.loadNoData();
      }
      articleList.addAll(data);
      _projectListObservable.add(articleList);
    }).catchError((error) {
      _projectListObservable.addError(error);
    });
  }

  ///下拉刷新
  refresh(BuildContext context, {int cid}){
    isRefresh = true;
    articleList.clear();
    _currentPageNum = pageNumFirst;
    loadWeChatListData(context, _currentPageNum, cid: cid);
  }

  //上拉加载
  onLoadMore(BuildContext context, {int cid}) {
    isRefresh = false;
    loadWeChatListData(context, _currentPageNum++, cid: cid);
  }
}
