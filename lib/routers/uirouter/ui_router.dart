import 'package:fluro/fluro.dart';
import 'package:flutter_goya_app/base/view_model_provider.dart';
import 'package:flutter_goya_app/main_page.dart';
import 'package:flutter_goya_app/routers/router_provider.dart';
import 'package:flutter_goya_app/ui/page/splash.dart';
import 'package:flutter_goya_app/ui/page/user/about.dart';
import 'package:flutter_goya_app/ui/page/user/collection.dart';
import 'package:flutter_goya_app/ui/page/user/login.dart';
import 'package:flutter_goya_app/ui/page/user/setting.dart';
import 'package:flutter_goya_app/viewmodel/collection_view_model.dart';
import 'package:flutter_goya_app/viewmodel/login_view_model.dart';
import 'package:flutter_goya_app/viewmodel/setting_view_model.dart';

class UIRouter implements IRouterProvider {
  static String splashPage = "splash_page";
  static String mainPage = "main_page";
  static String homeSecondFloor = "home_second_floor";
  static String loginPage = "login_page";
  static String settingPage = "setting_page";
  static String collectionPage = "collection_page";
  static String aboutPage = "about_page";

  @override
  void initRouter(Router router) {
    // TODO: implement initRouter
    //启动页
    router.define(splashPage,
        handler: Handler(handlerFunc: (_, params) => SplashPage()));
    //主页
    router.define(mainPage,
        handler: Handler(handlerFunc: (_, params) => MainPage()));
    //登录页
    router.define(loginPage,
        handler: Handler(
            handlerFunc: (_, params) => ViewModelProvider(
                viewModel: LoginViewModel(), child: LoginPage())));
    //设置
    router.define(settingPage,
        handler: Handler(
            handlerFunc: (_, params) => ViewModelProvider(
                viewModel: SettingViewModel(), child: SettingPage())));
    //收藏
    router.define(collectionPage,
        handler: Handler(
            handlerFunc: (_, params) => ViewModelProvider(
                viewModel: CollectionViewModel(), child: CollectionPage())));
    //关于
    router.define(aboutPage,
        handler: Handler(
            handlerFunc: (_, params) => AboutPage()));
  }
}
