import 'package:flutter/material.dart';
import 'package:flutter_goya_app/utils/utils.dart';

Icon loadIcon(IconData iconData,
    {double size = 24.0,  Color color}) {
  return Icon(iconData,size: size, color: color);
}

///加载本地图片Icon
Image loadAssetsIcon(String name,
    {double width, double height, BoxFit fit, Color color}) {
  return Image.asset(Utils.getIconPath(name),
      height: height, width: width, fit: fit, color: color);
}

///加载本地image
Image loadAssetsImage(String name,
    {double width, double height, BoxFit fit, Color color}) {
  return Image.asset(Utils.getImagePath(name),
      height: height, width: width, fit: fit, color: color);
}

///加载网络图片
Image loadAssetsUrl(String url,
    {double width, double height, BoxFit fit, Color color}) {
  return Image.network(url, height: height, width: width, fit: fit, color: color);
}

///加载圆形网络图片
Row loadOvalImage(String url,
    {double width, double height, BoxFit fit, Color color}){
  return Row(
    children: <Widget>[
      ClipOval(
        child: Image.network(url, height: height, width: width, fit: fit, color: color),
      )
    ],
  );
}

///加载圆形网络图片
Widget loadAssetsOvalImage(String name,
    {double width, double height, BoxFit fit, Color color}){
  return ClipOval(
    child: Image.asset(name, height: height, width: width, fit: fit, color: color),
  );
}
