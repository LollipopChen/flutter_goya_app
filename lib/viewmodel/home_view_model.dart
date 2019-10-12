import 'package:flutter/material.dart';
import 'package:flutter_goya_app/base/base_view_model.dart';
import 'package:flutter_goya_app/entity/article_entity.dart';
import 'package:flutter_goya_app/entity/banner_entity.dart';
import 'package:flutter_goya_app/repository/wan_android_repository.dart';
import 'package:rxdart/rxdart.dart';

///首页
class HomeViewModel extends BaseViewModel{

  ///广告
  BehaviorSubject<List<BannerEntity>> _bannerDataObservable = BehaviorSubject();
  Stream<List<BannerEntity>> get bannerDataStream => _bannerDataObservable.stream;

  ///文章列表
  BehaviorSubject<List<ArticleEntity>> _articleDataObservable = BehaviorSubject();
  Stream<List<ArticleEntity>> get articleDataStream => _articleDataObservable.stream;
  List<ArticleEntity> articleList = [];

  int pageNum = 1;

  @override
  void dispose() {
    _bannerDataObservable.close();
    _articleDataObservable.close();
    super.dispose();
  }

  @override
  void doInit(BuildContext context) {
    // TODO: 初始化
    loadBannerData(context);
  }

  ///获取广告数据
  Future<List<BannerEntity>> loadBannerData(BuildContext context) async{
    return await WanAndroidRepository.fetchBanners().then((List<BannerEntity> list){
      _bannerDataObservable.add(list);
    }).catchError((error){
      _bannerDataObservable.addError(error);
    });
  }

  //获取文章列表
  Future<List<ArticleEntity>> loadArticlesData(BuildContext context,int pageNum,{int cid}) async{
    return await WanAndroidRepository.fetchArticles(pageNum).then((List<ArticleEntity> list){
      articleList.addAll(list);
      _articleDataObservable.add(articleList);
    }).catchError((error){
      _articleDataObservable.addError(error);
    });
  }

  //下拉刷新
  onRefreshed(BuildContext context,{int cid}){
    articleList.clear();
    loadArticlesData(context,1,cid: cid);
  }

  //上拉加载
  onLoadMore(BuildContext context,{int cid}){
    loadArticlesData(context,pageNum++,cid: cid);
  }
}