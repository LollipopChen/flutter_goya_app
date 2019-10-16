import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_goya_app/res/colors.dart';
import 'package:flutter_goya_app/res/dimens.dart';
import 'package:flutter_goya_app/res/styles.dart';
import 'package:flutter_goya_app/utils/image_utils.dart';
import 'package:flutter_goya_app/utils/novigator_utils.dart';

///返回标题栏,需要实现PreferredSizeWidget接口才能直接当做AppBar使用
class BackTitleBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isShowBack; //是否显示左边的返回按钮
  final String backIconName; //返回按钮的资源图片名称
  final String titleText; //标题
  final bool isShowRightIcon; //是否显示右边的按钮
  final String rightIconName; //右边按钮的资源图片名称
  final Color backgroundColor; //标题栏的背景颜色
  final VoidCallback onBackPressed; //返回按钮的点击事件，默认‘点击返回上一页’
  final VoidCallback onRightPressed; //右边按钮的点击事件

  BackTitleBar({
    Key key,
    this.titleText,
    this.backIconName: 'ic_back_white',
    this.isShowBack: false,
    this.isShowRightIcon: false,
    this.rightIconName: 'setting',
    this.backgroundColor: Colours.app_main,
    this.onBackPressed,
    this.onRightPressed,
  }) : super(key: key);

  @override
  BackTitleBarState createState() => BackTitleBarState();

  @override
  // TODO: implement preferredSize 状态栏的高度
  Size get preferredSize => Size.fromHeight(48.0);
}

class BackTitleBarState extends State<BackTitleBar> {
  SystemUiOverlayStyle _overlayStyle = SystemUiOverlayStyle.light;

  Color getColor() {
    return _overlayStyle == SystemUiOverlayStyle.light
        ? Colors.white
        : Colours.text_dark;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _overlayStyle =
        ThemeData.estimateBrightnessForColor(widget.backgroundColor) ==
                Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      //修改状态栏字体颜色
      value: _overlayStyle, //状态栏字体颜色
      child: Material(
        color: widget.backgroundColor,
        child: SafeArea(
            child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text(
                    widget.titleText,
                    style: TextStyle(
                      fontSize: Dimens.font_sp18,
                      color: getColor(),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 48.0),
                )
              ],
            ),
            widget.isShowBack
                ? IconButton(
                    highlightColor: Colors.transparent,
                    icon:
                        loadAssetsIcon(widget.backIconName, color: getColor()),
                    onPressed: widget.onBackPressed == null
                        ? () => {NavigatorUtils.goBack(context)}
                        : widget.onBackPressed,
                    padding: const EdgeInsets.all(12.0),
                  )
                : Gaps.empty,
            Positioned(
                right: 0.0,
                child: Theme(
                    data: ThemeData(
                        buttonTheme: ButtonThemeData(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      minWidth: 40.0,
                    )),
                    child: widget.isShowRightIcon
                        ? IconButton(
                            icon: loadAssetsIcon(widget.rightIconName,
                                color: getColor()),
                            highlightColor: Colors.transparent,
                            onPressed: widget.onRightPressed,
                          )
                        : Gaps.empty)),
          ],
        )),
      ),
    );
  }
}
