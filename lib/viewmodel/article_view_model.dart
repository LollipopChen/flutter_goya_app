import 'package:flutter/material.dart';
import 'package:flutter_goya_app/base/base_view_model.dart';
import 'package:flutter_goya_app/entity/article_tree_item_entity.dart';
import 'package:flutter_goya_app/entity/navigation_site_entity.dart';
import 'package:flutter_goya_app/repository/wan_android_repository.dart';
import 'package:rxdart/rxdart.dart';

///体系ViewModel类，用来和业务层交互
class ArticleViewModel extends BaseViewModel<ArticleTreeItemEntity> {
  BehaviorSubject<List<ArticleTreeItemEntity>> _dataObservable =
      BehaviorSubject();

  Stream<List<ArticleTreeItemEntity>> get dataStream => _dataObservable.stream;

  @override
  void doInit(BuildContext context) {
    refreshListData(context);
  }

  @override
  Future<List<ArticleTreeItemEntity>> refreshListData(
      BuildContext context) async {
    return await WanAndroidRepository.fetchTreeCategories()
        .then((List<ArticleTreeItemEntity> list) {
      _dataObservable.add(list);
    }).catchError((error) {
      _dataObservable.addError(error);
    });
  }
}

///导航ViewModel类
class NavigationSiteViewModel extends BaseViewModel<NavigationSiteEntity> {
  BehaviorSubject<List<NavigationSiteEntity>> _dataObservable =
      BehaviorSubject();

  Stream<List<NavigationSiteEntity>> get dataStream => _dataObservable.stream;

  @override
  void dispose() {
    _dataObservable.close();
    super.dispose();
  }

  @override
  void doInit(BuildContext context) {
    refreshListData(context);
  }

  @override
  Future<List<NavigationSiteEntity>> refreshListData(
      BuildContext context) async {
    return await WanAndroidRepository.fetchNavigationSite()
        .then((List<NavigationSiteEntity> list) {
          _dataObservable.add(list);
    }).catchError((error){
      _dataObservable.addError(error);
    });
  }
}
