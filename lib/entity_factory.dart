import 'package:flutter_goya_app/entity/article_entity.dart';
import 'package:flutter_goya_app/entity/article_tree_item_entity.dart';
import 'package:flutter_goya_app/entity/favourite_entity.dart';
import 'package:flutter_goya_app/entity/navigation_site_entity.dart';
import 'package:flutter_goya_app/entity/user_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "ArticleEntity") {
      return ArticleEntity.fromJson(json) as T;
    } else if (T.toString() == "ArticleTreeItemEntity") {
      return ArticleTreeItemEntity.fromJson(json) as T;
    } else if (T.toString() == "FavouriteEntity") {
      return FavouriteEntity.fromJson(json) as T;
    } else if (T.toString() == "NavigationSiteEntity") {
      return NavigationSiteEntity.fromJson(json) as T;
    } else if (T.toString() == "UserEntity") {
      return UserEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}