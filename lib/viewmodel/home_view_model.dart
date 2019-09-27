import 'package:flutter/material.dart';
import 'package:flutter_goya_app/base/base_refresh_list_view_model.dart';
import 'package:flutter_goya_app/entity/article_entity.dart';
import 'package:flutter_goya_app/entity/banner_entity.dart';
import 'package:flutter_goya_app/repository/wan_android_repository.dart';
import 'package:rxdart/rxdart.dart';

///首页
class HomeViewModel extends BaseRefreshListViewModel{

  ///广告
  BehaviorSubject<List<BannerEntity>> _bannerDataObservable = BehaviorSubject();
  Stream<List<BannerEntity>> get bannerDataStream => _bannerDataObservable.stream;
  ///顶部文章
  BehaviorSubject<List<ArticleEntity>> _topArticleDataObservable = BehaviorSubject();
  Stream<List<ArticleEntity>> get topArticleDataStream => _topArticleDataObservable.stream;
  ///文章列表
  BehaviorSubject<List<ArticleEntity>> _articleDataObservable = BehaviorSubject();
  Stream<List<ArticleEntity>> get articleDataStream => _articleDataObservable.stream;


  @override
  void dispose() {
    _bannerDataObservable.close();
    _topArticleDataObservable.close();
    _articleDataObservable.close();
    super.dispose();
  }

  @override
  void doInit(BuildContext context) {
    // TODO: 初始化
    loadData();
  }

  @override
  Future<List> loadData({int pageNum = 0}) async{
    List<Future> futures = [];
    if(pageNum == BaseRefreshListViewModel.pageNumFirst){
      ///广告
      futures.add(WanAndroidRepository.fetchBanners());
      ///顶部文章
      futures.add(WanAndroidRepository.fetchTopArticles());
    }
    ///文章列表
    futures.add(WanAndroidRepository.fetchArticles(pageNum));

    var result = await Future.wait(futures);
    if (pageNum == BaseRefreshListViewModel.pageNumFirst) {
      _bannerDataObservable.add(result[0]);
      _topArticleDataObservable.add(result[1]);
      return result[2];
    } else {
      return result[0];
    }
  }
  @override
  onCompleted(List data) {
    super.onCompleted(data);
    _articleDataObservable.add(data);
  }

}