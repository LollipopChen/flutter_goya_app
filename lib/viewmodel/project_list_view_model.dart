import 'package:flutter/material.dart';
import 'package:flutter_goya_app/base/base_view_model.dart';
import 'package:flutter_goya_app/entity/project_list_entity.dart';
import 'package:flutter_goya_app/repository/wan_android_repository.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

class ProjectListViewModel extends BaseViewModel {
  /// 分页第一页页码
  static const int pageNumFirst = 0;

  /// 当前页码
  int _currentPageNum = pageNumFirst;

  //文章数据
  BehaviorSubject<List<ProjectListData>> _projectListObservable =
      BehaviorSubject();

  Stream<List<ProjectListData>> get projectListStream =>
      _projectListObservable.stream;

  List<ProjectListData> articleList = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  RefreshController get refreshController => _refreshController;

  bool isRefresh = true;

  @override
  void doInit(BuildContext context) {
  }

  @override
  void dispose() {
    _projectListObservable.close();
    refreshController.dispose();
    super.dispose();
  }

  ///获取文章数据
  Future<ProjectListEntity> loadProjectData(BuildContext context, int pageNum,
      {int cid}) async {
    return await WanAndroidRepository.fetchProjectArticles(pageNum, cid: cid)
        .then((ProjectListEntity projectListEntity) {
      var data = projectListEntity.datas;
      if (projectListEntity.datas.isEmpty && !isRefresh) {
        _currentPageNum--;
      }
      if(isRefresh){
        refreshController.refreshCompleted();
      }else{
        //防止上次上拉加载更多失败,需要重置状态
        refreshController.loadComplete();
      }

      if (data.length == projectListEntity.total) {
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
    loadProjectData(context, _currentPageNum, cid: cid);
  }

  //上拉加载
  onLoadMore(BuildContext context, {int cid}) {
    isRefresh = false;
    loadProjectData(context, _currentPageNum++, cid: cid);
  }
}
