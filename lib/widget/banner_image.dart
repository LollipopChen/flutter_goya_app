import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BannerImage extends StatelessWidget{
  final String url;
  final BoxFit fit;

  const BannerImage({Key key, @required this.url, this.fit:BoxFit.fill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CachedNetworkImage(
        imageUrl: url,
        placeholder: (context, url) =>
            Center(child: CupertinoActivityIndicator()),
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: fit);
  }

}