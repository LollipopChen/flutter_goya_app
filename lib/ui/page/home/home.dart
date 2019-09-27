import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_goya_app/base/view_model_provider.dart';
import 'package:flutter_goya_app/base/view_state_widget.dart';
import 'package:flutter_goya_app/entity/article_entity.dart';
import 'package:flutter_goya_app/entity/banner_entity.dart';
import 'package:flutter_goya_app/generated/i18n.dart';
import 'package:flutter_goya_app/provider/animated_provider.dart';
import 'package:flutter_goya_app/provider/view_state.dart';
import 'package:flutter_goya_app/res/styles.dart';
import 'package:flutter_goya_app/routers/uirouter/ui_router.dart';
import 'package:flutter_goya_app/ui/helper/refresh_helper.dart';
import 'package:flutter_goya_app/viewmodel/home_view_model.dart';
import 'package:flutter_goya_app/viewmodel/scroll_controller_model.dart';
import 'package:flutter_goya_app/widget/article_list_Item.dart';
import 'package:flutter_goya_app/widget/article_skeleton.dart';
import 'package:flutter_goya_app/widget/banner_image.dart';
import 'package:flutter_goya_app/widget/skeleton.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///首页

const double kHomeRefreshHeight = 180.0;

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  HomeViewModel homeModel;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeModel = ViewModelProvider.of(context);
    homeModel.init(context);
    homeModel.doInit(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    double bannerHeight = 150 + MediaQuery.of(context).padding.top;
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: false,
        child: Builder(builder: (_) {
          if (homeModel.viewState == ViewState.error) {
            return ViewStateWidget(onPressed: () {
              homeModel.doInit(context);
            });
          }
          return RefreshConfiguration.copyAncestor(
            context: context,
            // 下拉触发二楼距离
            twiceTriggerDistance: kHomeRefreshHeight - 15,
            //最大下拉距离,android默认为0,这里为了触发二楼
            maxOverScrollExtent: kHomeRefreshHeight,
            child: SmartRefresher(
              enableTwoLevel: true,
              controller: homeModel.refreshController,
              header: HomeRefreshHeader(),
              //下拉头部
              onTwoLevel: () async {
                //第二层页面
                await Navigator.of(context).pushNamed(UIRouter.homeSecondFloor);
                await Future.delayed(Duration(milliseconds: 300));
                Provider.of<HomeViewModel>(context)
                    .refreshController
                    .twoLevelComplete();
              },
              footer: RefresherFooter(),
              //上拉底部
              onRefresh: homeModel.refresh,
              //下拉刷新
              onLoading: homeModel.loadMore,
              //上拉加载
              enablePullUp: homeModel.list.isNotEmpty,
              child: ViewModelProvider(
                  viewModel: TapToTopModel(PrimaryScrollController.of(context),
                      height: bannerHeight - kToolbarHeight),
                  child: ListPage(homeModel)),
            ),
          );
        }),
      ),
    );
  }
}

///UI页面
class ListPage extends StatefulWidget {
  final HomeViewModel homeModel;

  ListPage(this.homeModel);

  @override
  ListPageState createState() => ListPageState();
}

class ListPageState extends State<ListPage> {
  TapToTopModel tapToTopModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tapToTopModel = ViewModelProvider.of(context);
    tapToTopModel.init(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double bannerHeight = 150 + MediaQuery.of(context).padding.top;
    return CustomScrollView(
      controller: tapToTopModel.scrollController,
      slivers: <Widget>[
        SliverToBoxAdapter(),
        SliverAppBar(
          actions: <Widget>[
            EmptyAnimatedSwitcher(
              display: tapToTopModel.showTopBtn,
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  //TODO 搜索
//                  showSearch(context: context, delegate: DefaultSearchDelegate());
                },
              ),
            )
          ],
          flexibleSpace: FlexibleSpaceBar(
            //广告
            background: BannerWidget(widget.homeModel),
            centerTitle: true,
            title: GestureDetector(
              onDoubleTap: tapToTopModel.scrollToTop,
              child: EmptyAnimatedSwitcher(
                display: tapToTopModel.showTopBtn,
                child:
                    Text(Platform.isIOS ? 'FunFlutter' : 'QFun Android'),
              ),
            ),
          ),
          expandedHeight: bannerHeight,
          pinned: true,
        ),
        if (widget.homeModel.viewState == ViewState.completed)
          HomeTopArticleList(widget.homeModel),
        HomeArticleList(widget.homeModel),
      ],
    );
  }
}

class BannerWidget extends StatelessWidget {
  final HomeViewModel homeModel;

  BannerWidget(this.homeModel);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (homeModel.viewState == ViewState.loading) {
      return CupertinoActivityIndicator();
    }

    return StreamBuilder(
      stream: homeModel.bannerDataStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<BannerEntity>> snapshot) {
        if (snapshot.hasError) {
          return ViewStateWidget(
            message: snapshot.error.toString(),
            onPressed: () {
              homeModel.doInit(context);
            },
          );
        }

        if (!snapshot.hasData) {
          return Gaps.empty;
        }

        var banners = snapshot.data;
        return Container(
          height: 150 + MediaQuery.of(context).padding.top,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Swiper(
            loop: true,
            autoplay: true,
            autoplayDelay: 5000,
            pagination: SwiperPagination(),
            itemCount: banners.length,
            itemBuilder: (ctx, index) {
              return InkWell(
                  onTap: () {
                    var banner = banners[index];
//                    Navigator.of(context).pushNamed(RouteName.articleDetail,
//                        arguments: Article()
//                          ..id = banner.id
//                          ..title = banner.title
//                          ..link = banner.url
//                          ..collect = false);
                  },
                  child: BannerImage(url: banners[index].imagePath));
            },
          ),
        );
      },
    );
  }
}

class HomeTopArticleList extends StatelessWidget {
  final HomeViewModel homeModel;

  HomeTopArticleList(this.homeModel);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: homeModel.topArticleDataStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<ArticleEntity>> snapshot) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                ArticleEntity item = snapshot.data[index];
                return ArticleItemWidget(
                  item,
                  index: index,
                  top: true,
                );
              },
              childCount: snapshot.data?.length ?? 0,
            ),
          );
        });
  }
}

class HomeArticleList extends StatelessWidget {
  final HomeViewModel homeModel;

  const HomeArticleList(this.homeModel);

  @override
  Widget build(BuildContext context) {
    if (homeModel.viewState == ViewState.loading) {
      return SliverToBoxAdapter(
        child: SkeletonList(
          builder: (context, index) => ArticleSkeletonItem(),
        ),
      );
    }
    return StreamBuilder(
        stream: homeModel.articleDataStream,
        builder: (BuildContext context, AsyncSnapshot<List<ArticleEntity>> snapshot){
      return SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            ArticleEntity item = snapshot.data[index];
            return ArticleItemWidget(
              item,
              index: index,
            );
          },
          childCount: snapshot.data?.length ?? 0,
        ),
      );
    });
  }
}

