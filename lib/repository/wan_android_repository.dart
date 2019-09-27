import 'package:flutter_goya_app/entity/article_entity.dart';
import 'package:flutter_goya_app/entity/article_tree_item_entity.dart';
import 'package:flutter_goya_app/entity/banner_entity.dart';
import 'package:flutter_goya_app/entity/navigation_site_entity.dart';
import 'package:flutter_goya_app/entity/user_entity.dart';
import 'package:flutter_goya_app/net/wan_android_api.dart';

///玩安卓
class WanAndroidRepository {
  // 体系数据
  static Future<List<ArticleTreeItemEntity>> fetchTreeCategories() async {
    var response = await http.get('tree/json');
    return response.data
        .map<ArticleTreeItemEntity>(
            (item) => ArticleTreeItemEntity.fromJson(item))
        .toList();
  }

  // 体系分类
  static Future<List<ArticleTreeItemEntity>> fetchProjectCategories() async {
    var response = await http.get('project/tree/json');
    return response.data
        .map<ArticleTreeItemEntity>(
            (item) => ArticleTreeItemEntity.fromJson(item))
        .toList();
  }

  ///导航数据
  static Future<List<NavigationSiteEntity>> fetchNavigationSite() async {
    var response = await http.get('navi/json');
    return response.data
        .map<NavigationSiteEntity>(
            (item) => NavigationSiteEntity.fromJson(item))
        .toList();
  }

  ///登录
  /// [Http._init] 添加了拦截器 设置了自动cookie.
  static Future login(String username, String password) async {
    var response = await http.post<Map>('user/login', queryParameters: {
      'username': username,
      'password': password,
    });
    return UserEntity.fromJson(response.data);
  }

  /// 登出
  static logout() async {
    /// 自动移除cookie
    await http.get('user/logout/json');
  }

  ///首页--轮播--广告
  static Future fetchBanners() async{
    var response = await http.get('banner/json');
    return response.data
        .map<BannerEntity>((item) => BannerEntity.fromJson(item))
        .toList();
  }

  // 置顶文章
  static Future fetchTopArticles() async {
    var response = await http.get('article/top/json');
    return response.data.map<ArticleEntity>((item) => ArticleEntity.fromJson(item)).toList();
  }

  // 首页 文章
  static Future fetchArticles(int pageNum, {int cid}) async {
//    await Future.delayed(Duration(seconds: 1));
    var response = await http.get('article/list/$pageNum/json',
        queryParameters: (cid != null ? {'cid': cid} : null));
    return response.data['datas']
        .map<ArticleEntity>((item) => ArticleEntity.fromJson(item))
        .toList();
  }
}
