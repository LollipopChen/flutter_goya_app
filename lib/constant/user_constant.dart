
import 'package:flutter_goya_app/entity/user_entity.dart';

///用户信息
class UserInfo{
  static UserEntity _user;

  static set userInfo(UserEntity user){
    _user = user;
  }

  static UserEntity get user => _user;

  ///用于判断当前用户是否登录
  static bool get hasUser => user != null;

}