import 'package:flutter/material.dart';
import 'package:flutter_goya_app/base/view_model_provider.dart';
import 'package:flutter_goya_app/generated/i18n.dart';
import 'package:flutter_goya_app/viewmodel/collection_view_model.dart';
import 'package:flutter_goya_app/widget/back_title_bar.dart';

///收藏
class CollectionPage extends StatefulWidget {
  @override
  CollectionPageState createState() => CollectionPageState();

}

class CollectionPageState extends State<CollectionPage> {
  CollectionViewModel viewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = ViewModelProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: BackTitleBar(
        titleText: S.of(context).favourites,
        isShowBack: true,
      ),
      body:Center(
        child:  Text("收藏"),
      ),
    );
  }

}