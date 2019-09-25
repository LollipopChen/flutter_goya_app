import 'package:flutter_goya_app/entity/article_tree_item_entity.dart';
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
}
