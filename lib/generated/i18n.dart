import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 默认
class S implements WidgetsLocalizations {
  const S();

  static S current;

  static const GeneratedLocalizationsDelegate delegate =
      GeneratedLocalizationsDelegate();

  static S of(BuildContext context) => Localizations.of<S>(context, S);

  @override
  // TODO: implement textDirection
  TextDirection get textDirection => TextDirection.ltr;

  String get appName => "QFun Android";

  String get splashSkip => "Skip";

  String get autoBySystem => "Auto";

  String get fontKuaiLe => "ZCOOL KuaiLe";

  String get home => 'Home';

  String get project => 'Project';

  String get wechat => 'WeChat';

  String get article => 'Article';

  String get me => 'Me';

  String get logout => 'Logout';

  String get toSignIn => "Sign In";

  String get favourites => "Favorites";

  String get darkMode => "Dark Mode";

  String get setting => "Setting";

  String get versionUpdate => "Version Update";

  String get theme => "Theme";

  String get retry => "Retry";

  String get coin => "Coin";

  String get catalogue => "Catalogue";

  String get evaluate => 'Evaluate';

  String get about => 'About';

  String get pageStateError => "Load Failed";

  String get viewStateButtonRefresh => "Refresh";

  String get viewStateMessageEmpty => "Nothing Found";

  String get viewStateMessageUnAuth => "Not sign in yet";

  String get loadFailed => "Load failed,retry later";

  String get loadMoreFailed => "Load Failed,Click Retry!";

  String get loadMoreIdle => "Load More..";

  String get loadMoreLoading => "Loading...";

  String get loadMoreNoData => "No more data";

  String get refreshing => "Refreshing...";

  String get refreshRefreshWhenRelease => "Refresh when release";

  String get refreshComplete => "Refresh Complete";

  String get pageStateRetry => "Retry";
  String get refreshIdle => "Pull down to refresh";
  String get refreshTwoLevel => "release to enter second floor";
  String get articleTagTop => "Top";
}

/// 英文
class $en extends S {
  const $en();
}

///中文
class $zh_CN extends S {
  const $zh_CN();

  @override
  TextDirection get textDirection => TextDirection.ltr;
  String get appName => "QFun Android";
  @override
  String get splashSkip => "跳过";

  @override
  String get autoBySystem => "跟随系统";

  @override
  String get fontKuaiLe => "快乐字体";

  @override
  String get home => '首页';

  @override
  String get project => '项目';

  @override
  String get wechat => '公众号';

  @override
  String get article => '体系';

  @override
  String get me => '我的';

  @override
  String get logout => '退出登录';

  @override
  String get toSignIn => '登录';

  @override
  String get favourites => '收藏';

  @override
  String get darkMode => "黑夜模式";

  @override
  String get setting => "设置";

  @override
  String get versionUpdate => "版本更新";

  @override
  String get theme => "色彩主题";

  @override
  String get retry => "重试";

  @override
  String get coin => "积分";

  @override
  String get catalogue => "导航";

  @override
  String get evaluate => '评价';

  @override
  String get about => '关于';

  @override
  String get pageStateError => "加载失败";

  @override
  String get loadMoreFailed => "加载失败,请点击重试";

  @override
  String get refreshRefreshWhenRelease => "释放可刷新";

  @override
  String get refreshComplete => "刷新完成";

  @override
  String get viewStateButtonRefresh => "刷新一下";

  @override
  String get loadFailed => "加载失败,请稍后重试";

  @override
  String get refreshing => "刷新中";

  @override
  String get loadMoreNoData => "没有更多数据了";

  @override
  String get loadMoreLoading => "加载中...";

  @override
  String get loadMoreIdle => "上拉加载更多";

  String get viewStateMessageUnAuth => "Not sign in yet";

  @override
  String get viewStateMessageEmpty => "空空如也";

  @override
  String get pageStateRetry => "重试";

  @override
  String get refreshIdle => "下拉可刷新";
  @override
  String get articleTagTop => "置顶";
}

class GeneratedLocalizationsDelegate extends LocalizationsDelegate<S> {
  const GeneratedLocalizationsDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      const Locale('en', 'US'), // 美国英语
      const Locale('zh', 'CN'), // 中文简体
    ];
  }

  LocaleListResolutionCallback listResolution(
      {Locale fallback, bool withCountry = true}) {
    return (List<Locale> locales, Iterable<Locale> supported) {
      if (locales == null || locales.isEmpty) {
        return fallback ?? supported.first;
      } else {
        return _resolve(locales.first, fallback, supported, withCountry);
      }
    };
  }

  LocaleResolutionCallback resolution(
      {Locale fallback, bool withCountry = true}) {
    return (Locale locale, Iterable<Locale> supported) {
      return _resolve(locale, fallback, supported, withCountry);
    };
  }

  @override
  Future<S> load(Locale locale) {
    final String lang = getLang(locale);
    if (lang != null) {
      switch (lang) {
        case "en":
          S.current = const $en();
          return SynchronousFuture<S>(S.current);
        case "zh_CN":
          S.current = const $zh_CN();
          return SynchronousFuture<S>(S.current);
        default:
        // NO-OP.
      }
    }
    S.current = const S();
    return SynchronousFuture<S>(S.current);
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale, true);

  @override
  bool shouldReload(GeneratedLocalizationsDelegate old) => false;

  ///
  /// Internal method to resolve a locale from a list of locales.
  ///
  Locale _resolve(Locale locale, Locale fallback, Iterable<Locale> supported,
      bool withCountry) {
    if (locale == null || !_isSupported(locale, withCountry)) {
      return fallback ?? supported.first;
    }

    final Locale languageLocale = Locale(locale.languageCode, "");
    if (supported.contains(locale)) {
      return locale;
    } else if (supported.contains(languageLocale)) {
      return languageLocale;
    } else {
      final Locale fallbackLocale = fallback ?? supported.first;
      return fallbackLocale;
    }
  }

  ///
  /// Returns true if the specified locale is supported, false otherwise.
  ///
  bool _isSupported(Locale locale, bool withCountry) {
    if (locale != null) {
      for (Locale supportedLocale in supportedLocales) {
        // Language must always match both locales.
        if (supportedLocale.languageCode != locale.languageCode) {
          continue;
        }

        // If country code matches, return this locale.
        if (supportedLocale.countryCode == locale.countryCode) {
          return true;
        }

        // If no country requirement is requested, check if this locale has no country.
        if (true != withCountry &&
            (supportedLocale.countryCode == null ||
                supportedLocale.countryCode.isEmpty)) {
          return true;
        }
      }
    }
    return false;
  }
}

String getLang(Locale l) => l == null
    ? null
    : l.countryCode != null && l.countryCode.isEmpty
        ? l.languageCode
        : l.toString();
