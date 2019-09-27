import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utils {
  static String getIconPath(String name,{String format:'png'}) {
    return 'assets/icon/$name.$format';
  }

  static String getImagePath(String name,{String format:'png'}) {
    return 'assets/image/$name.$format';
  }

  static String getStateImagePath(String name,{String format:'png'}) {
    return 'assets/state/$name.$format';
  }

  static Widget placeHolder({double width, double height}) {
    return SizedBox(
        width: width, height: height, child: CupertinoActivityIndicator(
        radius: min(10.0, width / 3)
    ));
  }

  static Widget error({double width, double height, double size}) {
    return SizedBox(
        width: width,
        height: height,
        child: Icon(
          Icons.error_outline,
          size: size,
        ));
  }

  static String randomUrl(
      {int width = 100, int height = 100, Object key = ''}) {
    return 'http://placeimg.com/$width/$height/${key.hashCode.toString()+key.toString()}';
  }
}
