import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_goya_app/entity/article_entity.dart';
import 'package:flutter_goya_app/entity/project_list_entity.dart';
import 'package:flutter_goya_app/generated/i18n.dart';
import 'package:flutter_goya_app/widget/Image.dart';
import 'package:flutter_goya_app/widget/article_tag.dart';
import 'package:flutter_html/flutter_html.dart';

class ProjectArticleItemWidget extends StatelessWidget {
  final ProjectListData article;
  final int index;
  final GestureTapCallback onTap;

  /// 首页置顶
  final bool top;

  /// 隐藏收藏按钮
  final bool hideFavourite;

  ProjectArticleItemWidget(this.article,
      {this.index, this.onTap, this.top: false, this.hideFavourite: false})
      : super(key: ValueKey(article.id));

  @override
  Widget build(BuildContext context) {
    var backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    /// 用于Hero动画的标记
    UniqueKey uniqueKey = UniqueKey();
    return Stack(
      children: <Widget>[
        Material(
          color: top
              ? Theme.of(context).accentColor.withAlpha(10)
              : backgroundColor,
          child: InkWell(
            onTap: onTap ??
                () {
                  //TODO  Item 点击
                },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  border: Border(
                bottom: Divider.createBorderSide(context, width: 0.7),
              )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      ClipOval(
                        child: WrapperImage(
                          imageType: ImageType.random,
                          url: article.author,
                          height: 20,
                          width: 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          article.author,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      Expanded(
                        child: SizedBox.shrink(),
                      ),
                      Text(article.niceDate,
                          style: Theme.of(context).textTheme.caption),
                    ],
                  ),
                  if (article.envelopePic.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 7),
                      child: ArticleTitleWidget(article.title),
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ArticleTitleWidget(article.title),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                article.desc,
                                style: Theme.of(context).textTheme.caption,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        WrapperImage(
                          url: article.envelopePic,
                          height: 60,
                          width: 60,
                        ),
                      ],
                    ),
                  Row(
                    children: <Widget>[
                      if (top) ArticleTag(S.of(context).articleTagTop),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          (article.superChapterName != null
                                  ? article.superChapterName + ' · '
                                  : '') +
                              (article.chapterName ?? ''),
                          style: Theme.of(context).textTheme.overline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ArticleTitleWidget extends StatelessWidget {
  final String title;

  ArticleTitleWidget(this.title);

  @override
  Widget build(BuildContext context) {
    return Html(
      padding: EdgeInsets.symmetric(vertical: 5),
      useRichText: false,
      data: title,
      defaultTextStyle: Theme.of(context).textTheme.subtitle,
    );
  }
}

