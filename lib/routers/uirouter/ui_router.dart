import 'package:fluro/fluro.dart';
import 'package:flutter_goya_app/main_page.dart';
import 'package:flutter_goya_app/routers/router_provider.dart';
import 'package:flutter_goya_app/ui/page/splash.dart';

class UIRouter implements IRouterProvider {
  static String splashPage = "splash_page";
  static String mainPage = "main_page";

  @override
  void initRouter(Router router) {
    // TODO: implement initRouter
    //启动页
    router.define(splashPage,
        handler: Handler(handlerFunc: (_, params) => SplashPage()));

    router.define(mainPage,
        handler: Handler(handlerFunc: (_, params) => MainPage()));
  }
}
