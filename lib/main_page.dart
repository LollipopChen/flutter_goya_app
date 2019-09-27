import 'package:flutter/material.dart';
import 'package:flutter_goya_app/base/view_model_provider.dart';
import 'package:flutter_goya_app/generated/i18n.dart';
import 'package:flutter_goya_app/ui/page/article/article.dart';
import 'package:flutter_goya_app/ui/page/home/home.dart';
import 'package:flutter_goya_app/ui/page/project/project.dart';
import 'package:flutter_goya_app/ui/page/user/user.dart';
import 'package:flutter_goya_app/ui/page/wechat/wechat.dart';
import 'package:flutter_goya_app/viewmodel/article_view_model.dart';
import 'package:flutter_goya_app/viewmodel/home_view_model.dart';
import 'package:flutter_goya_app/viewmodel/login_view_model.dart';

List<Widget> pages = <Widget>[
  HomePage(),
  ProjectPage(),
  WeChatPage(),
  ArticlePage(),
  UserPage()
];

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage>{
  // tab index
  int tagIndex = 0;

  //上次点击时间
  DateTime lastPressedAt;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      // 导航返回拦截:为了避免用户误触返回按钮而导致APP退出
      onWillPop: () async {
        if (lastPressedAt == null ||
            DateTime.now().difference(lastPressedAt) > Duration(seconds: 1)) {
          //两次点击间隔超过1秒则重新计时
          lastPressedAt = DateTime.now();
          return false;
        }
        return true;
      },
      child:Material(
        child: Scaffold(
          body:  IndexedStack(
            //body 使用IndexedStack，切换page时，页面的状态才能被保存下来
            index: tagIndex,
            children: <Widget>[
              ViewModelProvider(viewModel: HomeViewModel(),child: HomePage(),),
              ProjectPage(),
              WeChatPage(),
              ArticlePage(),
              ViewModelProvider(viewModel:LoginViewModel() , child: UserPage())
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: tagIndex,
              selectedFontSize: 14.0,
              unselectedFontSize: 14.0,
              type: BottomNavigationBarType.fixed,
//              backgroundColor: Colors.white,//设置黑夜模式时：不能设置背景颜色
              onTap: (index)=>tap(index),
              items: [
                BottomNavigationBarItem(
                    title: Text(S.of(context).home), icon: Icon(Icons.home)),
                BottomNavigationBarItem(
                    title: Text(S.of(context).project), icon: Icon(Icons.list)),
                BottomNavigationBarItem(
                    title: Text(S.of(context).wechat),
                    icon: Icon(Icons.group_work)),
                BottomNavigationBarItem(
                    title: Text(S.of(context).article), icon: Icon(Icons.share)),
                BottomNavigationBarItem(
                    title: Text(S.of(context).me), icon: Icon(Icons.person)),
              ]),
        ),
      ),
    );
  }

  tap(index) {
    setState(() {
      tagIndex = index;
    });
  }
}
