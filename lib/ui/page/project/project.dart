import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_goya_app/base/view_model_provider.dart';
import 'package:flutter_goya_app/entity/project_tree_entity.dart';
import 'package:flutter_goya_app/ui/page/project/article_list_page.dart';
import 'package:flutter_goya_app/viewmodel/project_list_view_model.dart';
import 'package:flutter_goya_app/viewmodel/project_view_model.dart';
import 'package:flutter_goya_app/widget/state_layout.dart';
import 'package:provider/provider.dart';

///项目
class ProjectPage extends StatefulWidget {
  @override
  ProjectPageState createState() => ProjectPageState();
}

class ProjectPageState extends State<ProjectPage>
    with TickerProviderStateMixin {
  ProjectViewModel projectViewModel;
  TabController tabController;
  ValueNotifier<int> valueNotifier = ValueNotifier(0);

  @override
  void initState() {
    projectViewModel = ViewModelProvider.of(context);
    projectViewModel.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var primaryColor = Theme.of(context).primaryColor;
    return StreamBuilder(
        stream: projectViewModel.projectTabStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<ProjectTreeEntity>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return InkWell(
              child: StateLayout(
                type: StateType.noData,
                hintText: snapshot.error.toString(),
              ),
              onTap: () {
                projectViewModel.loadTabData(context);
              },
            );
          }

          var tabList = snapshot.data ?? [];
          List<ProjectTreeEntity> list = [];
          for(int i=0; i< tabList.length;i++){
            var tab = tabList[i];
            if(tab.visible == 1){
              list.add(tab);
            }
          }
          if(tabList.isEmpty){
            return InkWell(
              child: StateLayout(type: StateType.noData),
              onTap: () {
                projectViewModel.loadTabData(context);
              },
            );
          }

          return ValueListenableProvider<int>.value(
            value: valueNotifier,
            child: DefaultTabController(
              length: list.length,
              initialIndex: valueNotifier.value,
              child: Builder(builder: (context) {
                if (tabController == null) {
                  tabController = DefaultTabController.of(context);
                  tabController.addListener(() {
                    valueNotifier.value = tabController.index;
                  });
                }
                return Scaffold(
                  appBar: AppBar(
                    title: Stack(
                      children: <Widget>[
                        CategoryDropdownWidget(tabList: list),
                        Container(
                          margin: const EdgeInsets.only(right: 25),
                          color: primaryColor.withOpacity(1),
                          child: TabBar(
                            isScrollable: true,
                            tabs: List.generate(
                              list.length,
                              (index) => Tab(text: list[index].name,),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: List.generate(
                        list.length,
                        (index) => ViewModelProvider(
                            viewModel: ProjectListViewModel(),
                            child: ArticleListPage(id: list[index].id))),
                  ),
                );
              }),
            ),
          );
        });
  }
}

///下拉列表
class CategoryDropdownWidget extends StatelessWidget {
  final List<ProjectTreeEntity> tabList;

  const CategoryDropdownWidget({Key key, this.tabList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int currentIndex = Provider.of<int>(context);
    return Align(
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Theme.of(context).primaryColor,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
              elevation: 0,
              value: currentIndex,
              style: Theme.of(context).primaryTextTheme.subhead,
              items: List.generate(tabList.length, (index) {
                var theme = Theme.of(context);
                var subhead = theme.primaryTextTheme.subhead;
                return DropdownMenuItem(
                  value: index,
                  child: Text(
                    tabList[index].name,
                    style: currentIndex == index
                        ? subhead.apply(
                            fontSizeFactor: 1.0,
                            color: theme.brightness == Brightness.light
                                ? Colors.white
                                : theme.accentColor)
                        : subhead.apply(color: subhead.color.withAlpha(200)),
                  ),
                );
              }),
              onChanged: (value) {
                DefaultTabController.of(context).animateTo(value);
              },
              isExpanded: true,
              icon: Container(
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
              )),
        ),
      ),
      alignment: Alignment(1.1, -1),
    );
  }
}
