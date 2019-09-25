import 'package:flutter/material.dart';
import 'package:flutter_goya_app/res/colors.dart';
import 'package:flutter_goya_app/res/styles.dart';
import 'package:flutter_goya_app/res/text_styles.dart';
import 'package:flutter_goya_app/utils/image_utils.dart';

///Me Item 封装
Widget defaultItem({
  String text,
  IconData iconData,
  int maxLines = 1,
  double padding = 10.0,
  double imageSize = 20.0,
  bool isDivider = true,
  Color iconColor = Colours.text_dark,
  Color textColor = Colours.text_dark,
  VoidCallback onPressed,
  TextStyle style,
}) {
  return InkWell(
    onTap: onPressed,//点击
    child: Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: padding, bottom: 0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              iconData == null
                  ? Gaps.empty
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(6.0),
                      child: loadIcon(iconData, color: iconColor),
                    ),
              iconData == null ? Gaps.empty : Gaps.hGap8,
              Expanded(
                //文本过长，打点
                flex: 1,
                child: Text(
                  text,
                  maxLines: maxLines,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: style ?? TextStyles.textDark16,
                ),
              ),
              Opacity(
                  opacity: onPressed == null ? 0 : 1,
                  child: Padding(
                    padding: EdgeInsets.only(top: maxLines == 1 ? 0.0 : 2.0),
                    child:
                        loadAssetsIcon('ic_right', height: imageSize, width: imageSize),
                  ))
            ],
          ),
          isDivider
              ? Container(
                  padding: EdgeInsets.only(top: padding + 2),
                  child: Gaps.line,
                )
              : Gaps.vGap14
        ],
      ),
    ),
  );
}
