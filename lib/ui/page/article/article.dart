import 'package:flutter/material.dart';
import 'package:flutter_goya_app/base/view_model_provider.dart';
import 'package:flutter_goya_app/entity/article_tree_item_entity.dart';
import 'package:flutter_goya_app/entity/navigation_site_entity.dart';
import 'package:flutter_goya_app/viewmodel/article_view_model.dart';
import 'package:flutter_goya_app/widget/state_layout.dart';
import 'package:oktoast/oktoast.dart';

///体系
class ArticlePage extends StatefulWidget {
  @override
  ArticlePageState createState() => ArticlePageState();
}

class ArticlePageState extends State<ArticlePage>
    with AutomaticKeepAliveClientMixin {

  List<String> tabs = ['体系', '导航'];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: TabBar(
            isScrollable: true,
            tabs: List.generate(
              tabs.length,
              (index) => Tab(
                text: tabs[index],
              ),
            ),
          ),
        ),
        body: TabBarView(children: [
          ViewModelProvider(viewModel: ArticleViewModel(),child: StructureCategoryList(),),
          ViewModelProvider(viewModel: NavigationSiteViewModel(),child: NavigationSiteCategoryList(),),
        ]),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

///体系---> 体系
class StructureCategoryList extends StatefulWidget {

  @override
  StructureCategoryListState createState() => StructureCategoryListState();
}

class StructureCategoryListState extends State<StructureCategoryList>
    with AutomaticKeepAliveClientMixin {
  ArticleViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ViewModelProvider.of(context);
    viewModel.init(context);
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
        stream: viewModel.dataStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<ArticleTreeItemEntity>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),//Loading
            );
          }
          if(snapshot.hasError){
            return InkWell(
              child: StateLayout(type:StateType.noData,hintText: snapshot.error.toString(),),
              onTap: (){
                viewModel.doInit(context);
              },
            );
          }
          if (!snapshot.hasData) {
            return InkWell(
              child: StateLayout(type:StateType.noData),
              onTap: (){
                 viewModel.refreshListData(context);
              },
            );
          }

          return ListView.builder(
              padding: EdgeInsets.all(15),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                ArticleTreeItemEntity item = snapshot.data[index];
                return StructureCategoryWidget(item);
              });
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

///体系标签
class StructureCategoryWidget extends StatelessWidget {
  final ArticleTreeItemEntity tree;

  StructureCategoryWidget(this.tree);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            tree.name,
            style: Theme.of(context).textTheme.subtitle,
          ),
          Wrap(
            spacing: 8,
            children: List.generate(
              tree.children.length,
              (index) => ActionChip(
                onPressed: () {
                  //TODO Flag 点击
                  showToast(tree.children[index].name);
                },
                label: Text(
                  tree.children[index].name,
                  maxLines: 1,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

///体系-->导航
class NavigationSiteCategoryList extends StatefulWidget{
  @override
  NavigationSiteCategoryListState createState() => NavigationSiteCategoryListState();
}

class NavigationSiteCategoryListState extends State<NavigationSiteCategoryList>
    with AutomaticKeepAliveClientMixin{
  NavigationSiteViewModel _viewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viewModel = ViewModelProvider.of(context);
    _viewModel.init(context);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
        stream: _viewModel.dataStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<NavigationSiteEntity>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),//Loading
            );
          }
          if(snapshot.hasError){
            return InkWell(
              child: StateLayout(type:StateType.noData,hintText: snapshot.error.toString(),),
              onTap: (){
                _viewModel.doInit(context);
              },
            );
          }
          if (!snapshot.hasData) {
            return InkWell(
              child: StateLayout(type:StateType.noData),
              onTap: (){
                _viewModel.refreshListData(context);
              },
            );
          }

          return ListView.builder(
              padding: EdgeInsets.all(15),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                NavigationSiteEntity item = snapshot.data[index];
                return NavigationSiteCategoryWidget(item);
              });
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

///导航标签
class NavigationSiteCategoryWidget extends StatelessWidget {
  final NavigationSiteEntity site;

  NavigationSiteCategoryWidget(this.site);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            site.name,
            style: Theme.of(context).textTheme.subtitle,
          ),
          Wrap(
            spacing: 8,
            children: List.generate(
              site.articles.length,
                  (index) => ActionChip(
                onPressed: () {
                  //TODO Flag 点击
                  showToast(site.articles[index].title);
                },
                label: Text(
                  site.articles[index].title,
                  maxLines: 1,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
