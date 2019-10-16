import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_goya_app/base/view_model_provider.dart';
import 'package:flutter_goya_app/entity/article_entity.dart';
import 'package:flutter_goya_app/entity/banner_entity.dart';
import 'package:flutter_goya_app/res/styles.dart';
import 'package:flutter_goya_app/viewmodel/home_view_model.dart';
import 'package:flutter_goya_app/widget/article_list_Item.dart';
import 'package:flutter_goya_app/widget/state_layout.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///首页

const double kHomeRefreshHeight = 180.0;

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  HomeViewModel homeModel;

  // banner 控制器
  SwiperController bannerController = SwiperController();

  // 上下拉刷新加载
  RefreshController refreshController = RefreshController(initialRefresh: true);
  AnimationController aniController, scaleController;
  AnimationController footerController;

  @override
  void initState() {
    // TODO: implement initState
    aniController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    scaleController = AnimationController(
        value: 0, vsync: this, duration: Duration(milliseconds: 3000));
    footerController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 3000));
    refreshController.headerMode.addListener(() {
      if (refreshController.headerStatus == RefreshStatus.idle) {
        scaleController.value = 0.0;
        aniController.reset();
      } else {
        aniController.repeat();
      }
    });

    homeModel = ViewModelProvider.of(context);
    homeModel.init(context);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    aniController.dispose();
    scaleController.dispose();
    footerController.dispose();
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// iPhoneX 头部适配
    double bannerHeight = 150 + MediaQuery.of(context).padding.top;
    return Scaffold(
      body: SmartRefresher(
        enablePullUp: true,
        controller: refreshController,
        onRefresh: () async {
          homeModel.onRefreshed(context);
          refreshController.refreshCompleted();
        },
        onLoading: () async {
          homeModel.onLoadMore(context);
          refreshController.loadComplete();
        },
        footer: footerWidget(),
        header: headerWidget(),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(),
            SliverAppBar(
              pinned: true, //是否固定在顶部
              expandedHeight: bannerHeight,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: BannerWidget(
                  homeModel: homeModel,
                  bannerController: bannerController,
                ),
              ),
            ),
            ArticleListWidget(homeModel),
          ],
        ),
      ),
    );
  }

  ///底部
  Widget footerWidget() {
    // TODO: implement build
    return CustomFooter(onModeChange: (mode) {
      if (mode == LoadStatus.loading) {
        scaleController.value = 0.0;
        footerController.repeat();
      } else {
        footerController.reset();
      }
    }, builder: (context, mode) {
      Widget child;
      switch (mode) {
        case LoadStatus.failed:
          child = Text("加载失败！点击重试！");
          break;
        case LoadStatus.noMore:
          child = Text("没有更多数据了");
          break;
        default:
          child = SpinKitCircle(
            color: Theme.of(context).accentColor,
            size: 50.0,
          );
          break;
      }
      return Container(
        height: 60,
        child: Center(
          child: child,
        ),
      );
    });
  }

  ///头部
  Widget headerWidget() {
    return CustomHeader(
      refreshStyle: RefreshStyle.Behind,
      onOffsetChange: (offset) {
        if (refreshController.headerMode.value != RefreshStatus.refreshing)
          scaleController.value = offset / 80.0;
      },
      builder: (context, model) {
        return Container(
          child: FadeTransition(
            opacity: scaleController,
            child: ScaleTransition(
              child: SpinKitCircle(
                color: Theme.of(context).accentColor,
                size: 50.0,
              ),
              scale: scaleController,
            ),
          ),
          alignment: Alignment.center,
        );
      },
    );
  }
}

///广告
class BannerWidget extends StatefulWidget {
  final HomeViewModel homeModel;
  final SwiperController bannerController;

  const BannerWidget({Key key, this.homeModel, this.bannerController})
      : super(key: key);

  @override
  BannerListState createState() {
    // TODO: implement createState
    return BannerListState();
  }
}

class BannerListState extends State<BannerWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
        stream: widget.homeModel.bannerDataStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<BannerEntity>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CupertinoActivityIndicator();
          }

          var banners = snapshot?.data ?? [];
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 150 + MediaQuery.of(context).padding.top,
            child: banners.length == 0
                ? Gaps.empty
                : Swiper(
                    loop: true,
                    autoplay: true,
                    autoplayDelay: 3000,
                    controller: widget.bannerController,
                    itemWidth: MediaQuery.of(context).size.width,
                    itemHeight: 150 + MediaQuery.of(context).padding.top,
                    pagination: pagination(banners),
                    itemBuilder: (BuildContext context, int index) {
                      return Image.network(
                        banners[index]?.imagePath,
                        fit: BoxFit.fill,
                      );
                    },
                    itemCount: snapshot.data?.length ?? 0,
                    viewportFraction: 1.0,
                  ),
          );
        });
  }

  ///广告的文字说明和dot
  SwiperPagination pagination(List<BannerEntity> data) => SwiperPagination(
        margin: EdgeInsets.all(0.0),
        builder: SwiperCustomPagination(
            builder: (BuildContext context, SwiperPluginConfig config) {
          return Container(
            color: Colors.black45,
            height: 40,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: <Widget>[
                Text(
                  data[config.activeIndex].title,
                  style: TextStyle(fontSize: 14.0, color: Colors.white),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: DotSwiperPaginationBuilder(
                            color: Colors.white70,
                            activeColor: Colors.green,
                            size: 6.0,
                            activeSize: 6.0)
                        .build(context, config),
                  ),
                )
              ],
            ),
          );
        }),
      );
}

///文章
class ArticleListWidget extends StatefulWidget {
  final HomeViewModel homeModel;

  ArticleListWidget(this.homeModel);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ArticleListWidgetState();
  }
}

class ArticleListWidgetState extends State<ArticleListWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
        stream: widget.homeModel.articleDataStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<ArticleEntity>> snapshot) {
          var articleList = snapshot.data ?? [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: CupertinoActivityIndicator(),//Loading
              ),
            );
          }
          if(snapshot.hasError){
            return SliverToBoxAdapter(
              child: InkWell(
                child: StateLayout(type:StateType.noData,hintText: snapshot.error.toString(),),
                onTap: (){
                  widget.homeModel.onRefreshed(context);
                },
              ),
            );
          }
          if (articleList.length == 0) {
            return SliverToBoxAdapter(
              child: InkWell(
                child: StateLayout(type:StateType.noData),
                onTap: (){
                  widget.homeModel.onRefreshed(context);
                },
              ),
            );
          }

          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                ArticleEntity item = articleList[index];
                return ArticleItemWidget(
                  item,
                  index: index,
                );
              },
              childCount: articleList.length,
            ),
          );
        });
  }
}
