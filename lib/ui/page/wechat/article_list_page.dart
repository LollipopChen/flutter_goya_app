import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_goya_app/base/view_model_provider.dart';
import 'package:flutter_goya_app/entity/we_chat_list_entity.dart';
import 'package:flutter_goya_app/ui/helper/refresh_helper.dart';
import 'package:flutter_goya_app/viewmodel/we_chat_list_view_model.dart';
import 'package:flutter_goya_app/widget/state_layout.dart';
import 'package:flutter_goya_app/widget/we_chat_article_list_Item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///公众号文章列表
class ArticleListPage extends StatefulWidget {
  final int id;

  const ArticleListPage({Key key, this.id}) : super(key: key);

  @override
  ArticleListPageState createState() => ArticleListPageState();
}

class ArticleListPageState extends State<ArticleListPage>
    with AutomaticKeepAliveClientMixin {
  WeChatListViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ViewModelProvider.of(context);
    viewModel.refresh(context, cid: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: StreamBuilder(
          stream: viewModel.projectListStream,
          builder: (BuildContext context,
              AsyncSnapshot<List<WeChatListData>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (!snapshot.hasData) {
              return InkWell(
                child: StateLayout(
                  type: StateType.noData,
                  hintText: snapshot.error.toString(),
                ),
                onTap: () {
                  viewModel.loadWeChatListData(context, 1, cid: widget.id);
                },
              );
            }
            var list = snapshot.data;
            return SmartRefresher(
                controller: viewModel.refreshController,
                header: WaterDropHeader(),
                footer: RefresherFooter(),
                onRefresh: () async {
                  viewModel.refresh(context, cid: widget.id);
                },
                onLoading: () async {
                  viewModel.onLoadMore(context, cid: widget.id);
                },
                enablePullUp: true,
                child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      WeChatListData item = list[index];
                      return WeChatArticleItemWidget(
                        item,
                        index: index,
                      );
                    }));
          }),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
