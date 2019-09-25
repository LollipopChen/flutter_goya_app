import 'package:flutter/cupertino.dart';
import 'package:flutter_goya_app/config/storage_manager.dart';
import 'package:flutter_goya_app/entity/user_entity.dart';
import 'package:flutter_goya_app/viewmodel/favourite_view_model.dart';

class UserViewModel extends ChangeNotifier {
  static const String kUser = 'kUser';

  final GlobalFavouriteStateModel globalFavouriteStateModel;

  UserEntity _user;

  UserEntity get user => _user;

  bool get hasUser => user != null;

  UserViewModel({@required this.globalFavouriteStateModel}) {
    var userMap = StorageManager.localStorage.getItem(kUser);
    _user = userMap != null ? UserEntity.fromJson(userMap) : null;
  }

  saveUser(UserEntity user) {
    _user = user;
    notifyListeners();
    globalFavouriteStateModel.replaceAll(_user.collectIds);
    StorageManager.localStorage.setItem(kUser, user);
  }

  /// 清除持久化的用户数据
  clearUser() {
    _user = null;
    notifyListeners();
    StorageManager.localStorage.deleteItem(kUser);
  }
}