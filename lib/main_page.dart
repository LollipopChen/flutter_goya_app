import 'package:flutter/material.dart';
import 'package:flutter_goya_app/ui/page/home/home.dart';
import 'package:flutter_goya_app/ui/page/project/project.dart';

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> with TickerProviderStateMixin {
  // tab index
  int tagIndex = 0;

  //上次点击时间
  DateTime lastPressedAt;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      // 导航返回拦截:为了避免用户误触返回按钮而导致APP退出
      child: Material(
        child: Scaffold(
          //body 使用IndexedStack，切换page时，页面的状态才能被保存下来
          body: IndexedStack(
            index: tagIndex,
            children: <Widget>[
              HomePage(),
              ProjectPage(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: tagIndex,
              selectedFontSize: 14.0,
              unselectedFontSize: 14.0,
              type: BottomNavigationBarType.fixed,
              fixedColor: Colors.green[600],
              backgroundColor: Colors.white,
              onTap: (index) => tap(index),
              items: [
                BottomNavigationBarItem(
                    title: Text('首页'), icon: Icon(Icons.home)),
                BottomNavigationBarItem(
                    title: Text('项目'), icon: Icon(Icons.list)),
                BottomNavigationBarItem(
                    title: Text('公众号'), icon: Icon(Icons.group_work)),
                BottomNavigationBarItem(
                    title: Text('体系'), icon: Icon(Icons.share)),
                BottomNavigationBarItem(
                    title: Text('我的'), icon: Icon(Icons.person)),
              ]),
        ),
      ),
      onWillPop: () async {
        if (lastPressedAt == null ||
            DateTime.now().difference(lastPressedAt) > Duration(seconds: 1)) {
          //两次点击间隔超过1秒则重新计时
          lastPressedAt = DateTime.now();
          return false;
        }
        return true;
      },
    );
  }

  tap(int index) {
    setState(() {
      tagIndex = index;
    });
  }
}
