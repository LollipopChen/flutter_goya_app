import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_goya_app/config/storage_manager.dart';
import 'package:flutter_goya_app/routers/application.dart';
import 'package:flutter_goya_app/routers/routes.dart';
import 'package:flutter_goya_app/routers/uirouter/ui_router.dart';
import 'package:flutter_goya_app/view_model/locale_model.dart';
import 'package:flutter_goya_app/view_model/theme_model.dart';
import 'package:flutter_goya_app/viewmodel/favourite_view_model.dart';
import 'package:flutter_goya_app/viewmodel/user_view_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'generated/i18n.dart';

///应用入口
void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await StorageManager.init();

  runApp(MyApp());

  //设置透明状态栏
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  MyApp() {
    //配置路由
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
      /// set toast style, optional
      /// 全局设置隐藏之前的属性,这里设置后,每次当你显示新的 toast 时,旧的就会被关闭
      dismissOtherOnShow: true,
      backgroundColor: Colors.black54,
      textPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      radius: 20.0,
      position: ToastPosition.bottom,
      child: MultiProvider(
        //初始化配置的Model
        providers: <SingleChildCloneableWidget>[
          ChangeNotifierProvider.value(value: ThemeModel()),
          ChangeNotifierProvider.value(value: LocaleModel()),
          ChangeNotifierProvider.value(value:  GlobalFavouriteStateModel()),
          ChangeNotifierProxyProvider<GlobalFavouriteStateModel, UserViewModel>(
            builder: (context, globalFavouriteStateModel, userModel) =>
            userModel ?? UserViewModel(globalFavouriteStateModel: globalFavouriteStateModel),
          )
        ],
        child: Consumer2<ThemeModel,LocaleModel>(builder: (context, themeModel, localeModel, child) {
          return RefreshConfiguration(
            hideFooterWhenNotFull: true, //列表数据不满一页,不触发加载更多
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: localeModel.locale,
              title: 'QFlutterDemo',
              theme: themeModel.themeData,
              darkTheme: themeModel.darkTheme,
              localizationsDelegates: const [
                // 本地化的代理类
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,//只支持美国英语和中文简体
              localeResolutionCallback:(Locale _locale, Iterable<Locale> supportedLocales) {
                if (localeModel.locale != null) {
                  //如果已经选定语言，则不跟随系统
                  return localeModel.locale;
                } else {
                  Locale locale;
                  //APP语言跟随系统语言，如果系统语言不是中文简体或美国英语，
                  //则默认使用美国英语
                  if (supportedLocales.contains(_locale)) {
                    locale= _locale;
                  } else {
                    locale= Locale('en', 'US');
                  }
                  return locale;
                }
              },
              onGenerateRoute: Application.router.generator,
              initialRoute: UIRouter.splashPage,
            ),
          );
        }),
      ),
    );
  }
}
