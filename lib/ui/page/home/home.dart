import 'package:flutter/material.dart';

///首页

const double kHomeRefreshHeight = 180.0;

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    double bannerHeight = 150 + MediaQuery.of(context).padding.top;
    return Scaffold(

    );
  }
}
