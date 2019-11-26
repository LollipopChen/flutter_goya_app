import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_goya_app/base/view_model_provider.dart';
import 'package:flutter_goya_app/constant/user_constant.dart';
import 'package:flutter_goya_app/entity/user_entity.dart';
import 'package:flutter_goya_app/generated/i18n.dart';
import 'package:flutter_goya_app/res/styles.dart';
import 'package:flutter_goya_app/routers/uirouter/ui_router.dart';
import 'package:flutter_goya_app/utils/novigator_utils.dart';
import 'package:flutter_goya_app/utils/utils.dart';
import 'package:flutter_goya_app/view_model/theme_model.dart';
import 'package:flutter_goya_app/viewmodel/login_view_model.dart';
import 'package:flutter_goya_app/widget/app_bar.dart';
import 'package:flutter_goya_app/widget/bottom_clipper.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            actions: <Widget>[BarWidget()],
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            expandedHeight: 200 + MediaQuery.of(context).padding.top,
            flexibleSpace: UserHeaderWidget(),
            pinned: true,
          ),
          UserListWidget()
        ],
      ),
    );
  }
}

/// 状态栏
class BarWidget extends StatefulWidget {
  @override
  BarWidgetState createState() => BarWidgetState();
}

class BarWidgetState extends State<BarWidget> {
  @override
  Widget build(BuildContext context) {
    if (UserInfo.hasUser) {
      return IconButton(
        tooltip: S.of(context).logout,
        icon: Icon(Icons.exit_to_app),
        onPressed: () {
          //TODO 退出登录
        },
      );
    }
    return SizedBox.shrink();
  }
}

/// 头部
class UserHeaderWidget extends StatefulWidget {
  @override
  UserHeaderWidgetState createState() => UserHeaderWidgetState();
}

class UserHeaderWidgetState extends State<UserHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    var userInfo = UserInfo.user;
    return ClipPath(
      clipper: BottomClipper(),
      child: Container(
        color: Theme.of(context).primaryColor.withAlpha(200),
        padding: EdgeInsets.only(top: 10),
        child: InkWell(
          onTap: UserInfo.hasUser
              ? null
              : () {
                  // TODO  登录
                  NavigatorUtils.push(context, UIRouter.loginPage);
                },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                child: Hero(
                  tag: 'loginLogo',
                  child: ClipOval(
                      child: UserInfo.hasUser
                          ? Image.network(userInfo.icon,
                              fit: BoxFit.cover,
                              width: 80,
                              height: 80,
                              color: UserInfo.hasUser
                                  ? Theme.of(context).accentColor.withAlpha(200)
                                  : Theme.of(context).accentColor.withAlpha(10),
                              // https://api.flutter.dev/flutter/dart-ui/BlendMode-class.html
                              colorBlendMode: BlendMode.colorDodge)
                          : Image.asset(Utils.getImagePath('header'),
                              fit: BoxFit.cover,
                              width: 80,
                              height: 80,
                              color: UserInfo.hasUser
                                  ? Theme.of(context).accentColor.withAlpha(200)
                                  : Theme.of(context).accentColor.withAlpha(10),
                              colorBlendMode: BlendMode.colorDodge)),
                ),
              ),
              Gaps.vGap20,
              Column(
                children: <Widget>[
                  Text(
                      UserInfo.hasUser
                          ? userInfo.nickname
                          : S.of(context).toSignIn,
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .apply(color: Colors.white.withAlpha(200))),
                  SizedBox(
                    height: 10,
                  ),
//                    if (model.hasUser) UserCoin() //TODO  个人积分
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

///Item
class UserListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var iconColor = Theme.of(context).accentColor;
    return ListTileTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: SliverList(
        delegate: SliverChildListDelegate([
          ListTile(
            title: Text(S.of(context).favourites),
            onTap: () {
              //TODO 收藏
              NavigatorUtils.push(context, UIRouter.collectionPage);
            },
            leading: Icon(
              Icons.favorite_border,
              color: iconColor,
            ),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            title: Text(S.of(context).darkMode),
            onTap: () {
              Provider.of<ThemeModel>(context).switchTheme(
                  brightness: Theme.of(context).brightness == Brightness.light
                      ? Brightness.dark
                      : Brightness.light);
            },
            leading: Transform.rotate(
              angle: -pi,
              child: Icon(
                Theme.of(context).brightness == Brightness.light
                    ? Icons.brightness_2
                    : Icons.brightness_5,
                color: iconColor,
              ),
            ),
            trailing: CupertinoSwitch(
                activeColor: iconColor,
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (value) {
                  Provider.of<ThemeModel>(context).switchTheme(
                      brightness: value ? Brightness.dark : Brightness.light);
                }),
          ),
          ThemeSettingWidget(),
          ListTile(
            title: Text(S.of(context).setting),
            onTap: () {
              //TODO 设置
              NavigatorUtils.push(context, UIRouter.settingPage);
            },
            leading: Icon(
              Icons.settings,
              color: iconColor,
            ),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            title: Text(S.of(context).evaluate),
            onTap: () {
              //TODO 评价
            },
            leading: Icon(
              Icons.star,
              color: iconColor,
            ),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            title: Text(S.of(context).about),
            onTap: () {
              //TODO 关于
              NavigatorUtils.push(context, UIRouter.aboutPage);
            },
            leading: Icon(
              Icons.error_outline,
              color: iconColor,
            ),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            title: Text(S.of(context).versionUpdate),
            onTap: () {
              //TODO 版本更新
            },
            leading: Icon(
              Icons.system_update,
              color: iconColor,
            ),
            trailing: Icon(Icons.chevron_right),
          ),
        ]),
      ),
    );
  }
}

///主题颜色
class ThemeSettingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      //闭合列表
      title: Text(S.of(context).theme),
      leading: Icon(
        Icons.color_lens,
        color: Theme.of(context).accentColor,
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Wrap(
            spacing: 5,
            runSpacing: 5,
            children: <Widget>[
              ...Colors.primaries.map((color) {
                return Material(
                  color: color,
                  child: InkWell(
                    onTap: () {
                      var model = Provider.of<ThemeModel>(context);
                      var brightness = Theme.of(context).brightness;
                      model.switchTheme(brightness: brightness, color: color);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                    ),
                  ),
                );
              }).toList(),
              Material(
                  child: InkWell(
                onTap: () {
                  var model = Provider.of<ThemeModel>(context);
                  var brightness = Theme.of(context).brightness;
                  model.switchRandomTheme(brightness: brightness); //随机主题颜色
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).accentColor)),
                  width: 40,
                  height: 40,
                  child: Text(
                    "?",
                    style: TextStyle(
                        fontSize: 20, color: Theme.of(context).accentColor),
                  ),
                ),
              ))
            ],
          ),
        ),
      ],
    );
  }
}
